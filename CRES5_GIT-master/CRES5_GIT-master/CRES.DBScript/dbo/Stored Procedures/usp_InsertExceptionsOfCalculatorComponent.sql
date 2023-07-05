    
CREATE PROCEDURE [dbo].[usp_InsertExceptionsOfCalculatorComponent]     
@NoteID UNIQUEIDENTIFIER,    
@AnalysisID UNIQUEIDENTIFIER,    
@UserID nvarchar(256)    
AS    
BEGIN    

---------------------------------------------------    
Declare @AnalysisName nvarchar(50);
Set @AnalysisName = (Select name from core.analysis where AnalysisID = @AnalysisID)

IF(@AnalysisName <> 'Default')
BEGIN
	Delete from core.Exceptions where ObjectID=@NoteID and FieldName in ('GAAP Component' ,'Amort Fee Check','Amort Discount Premium Check','Amort Cap Cost Check')
	return;
END
---------------------------------------------------    

Declare @EnableM61Calculations int;    
Declare @ObjectTypeID   int;    
Declare @ActionLevelID  int;    
    
SET @EnableM61Calculations = (Select ISNULL(EnableM61Calculations,3) from cre.note where noteid = @NoteID)    
    
IF(@EnableM61Calculations = 4)    
BEGIN    
	Delete from core.Exceptions where ObjectID=@NoteID and FieldName in ('GAAP Component' ,'Amort Fee Check','Amort Discount Premium Check','Amort Cap Cost Check')
END    
ELSE    
BEGIN    
	SET @ObjectTypeID = (Select Lookupid from core.lookup where name = 'Note' and ParentID = 27)    
	SET @ActionLevelID = (Select Lookupid from core.lookup where name = 'Normal' and ParentID = 46)    
    
    
	Declare @ISException_GAAPComponent bit = 0;   
	Declare @ISException_AmortFeeCheck bit = 0;   
	Declare @ISException_AmortDiscountPremiumCheck bit = 0;   
	Declare @ISException_AmortCapCostCheck bit = 0;   

 
	Declare @GAAPCOmponent decimal(28,15) = 0;  
  
	Select @GAAPCOmponent = ROUND(Delta,2)  ---as GaapComponent
	From(
		Select crenoteid
		,SUM(EndingGAAPBookValue) EndingGAAPBookValue
		,SUM(Cleancost ) CleanCost
		,SUM(InterestSuspenseAccountBalance)InterestSuspenseAccountBalance
		,SUM(AccumaltedDiscountPremiumBI)AccumaltedDiscountPremiumBI
		,SUM( CurrentPeriodPIKInterestAccrualPeriodEnddate)CurrentPeriodPIKInterestAccrualPeriodEnddate
		,SUM(CurrentPeriodInterestAccrualPeriodEnddate)CurrentPeriodInterestAccrualPeriodEnddate
		,SUM(AccumulatedAmort)AccumulatedAmort
		,SUM(AccumalatedCapitalizedCostBI)AccumalatedCapitalizedCostBI
		,SUM(CalcGAAP) CalcGAAP
		, ABS(SUM(EndingGAAPBookValue) - SUM(CAlcGAAP)) as Delta
		From(
			Select CreNoteid ,
			NoteID ,
			PeriodEndDate ,
			EndingGAAPBookValue ,
			CleanCost ,
			CurrentPeriodPIKInterestAccrualPeriodEnddate ,
			AccumalatedCapitalizedCostBI ,
			CurrentPeriodInterestAccrualPeriodEnddate ,
			AccumaltedDiscountPremiumBI ,
			AccumulatedAmort ,
			TotalAmortAccrualForPeriod ,
			DiscountPremiumAccrual ,
			CapitalizedCostAccrual ,
			InterestSuspenseAccountActivityforthePeriod ,
			InterestSuspenseAccountBalance ,
			CalcGAAP= (Cleancost-InterestSuspenseAccountBalance+[AccumaltedDiscountPremiumBI]+ [CurrentPeriodPIKInterestAccrualPeriodEnddate]+[CurrentPeriodInterestAccrualPeriodEnddate]+ AccumulatedAmort+[AccumalatedCapitalizedCostBI])
			From(

			Select
			CreNoteid
			,Nc.[NoteID]
			, [PeriodEndDate]
			, EndingGAAPBookValue
			, ISNULL(CleanCost,0) as CleanCost
			,ISNULL([CurrentPeriodPIKInterestAccrualPeriodEnddate],0) as CurrentPeriodPIKInterestAccrualPeriodEnddate
			--,[AccumalatedCapitalizedCostBI]
			,SUM(ISNULL(nc.CapitalizedCostAccrual,0)) OVER(PARTITION BY nc.AnalysisID,nc.NoteID ORDER BY nc.AnalysisID,nc.NoteID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI
			,ISNULL([CurrentPeriodInterestAccrualPeriodEnddate],0) as CurrentPeriodInterestAccrualPeriodEnddate
			,SUM(ISNULL(nc.DiscountPremiumAccrual,0)) OVER(PARTITION BY nc.AnalysisID,nc.NoteID ORDER BY nc.AnalysisID,nc.NoteID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI
			--,[AccumaltedDiscountPremiumBI]
			,ISNULL(AccumulatedAmort,0) as AccumulatedAmort
			,ISNULL(TotalAmortAccrualForPeriod,0) as TotalAmortAccrualForPeriod
			,ISNULL([DiscountPremiumAccrual],0) as DiscountPremiumAccrual
			,ISNULL([CapitalizedCostAccrual],0) as CapitalizedCostAccrual
			,ISNULL(InterestSuspenseAccountActivityforthePeriod,0) as InterestSuspenseAccountActivityforthePeriod
			,ISNULL(InterestSuspenseAccountBalance,0) as InterestSuspenseAccountBalance		

			from [cre].[NotePeriodicCalc] Nc 
			Inner join cre.Note n on n.noteid = nc.NoteID
			Inner JOin core.account acc on acc.accountid = n.account_accountid
			Where acc.isdeleted <> 1
			and nc.Month is not null		
			and Periodenddate = eomonth (Periodenddate,0)
			and Periodenddate <> ISNULL(eomonth(n.ActualPayoffdate,0),eomonth(n.FullyextendedMaturitydate,0))	
			and Analysisid = @AnalysisID
			and n.noteid = @NoteID

			)a
		)y
		group by crenoteid
	)z

	--Select @GAAPCOmponent = SUM(Sum_GaapComponent)     
	--From(    
	--	Select     
	--	n.Noteid    
	--	, nc.PeriodEndDate     
	--	, nc.[Month]    
	--	, nc.EndingBalance    
	--	, nc.EndingGAAPBookValue     
	--	, nc.CleanCost    
	--	, nc.AccumulatedAmort As AccAmort    
	--	, nc.CurrentPeriodInterestAccrualPeriodEnddate AccInterest    
	--	, nc.CurrentPeriodPIKInterestAccrualPeriodEnddate AccPikInterest    
	--	, n.Discount    
	--	, n.CapitalizedClosingCosts CapCost    
	--	,(nc.EndingGAAPBookValue - (CleanCost + AccumulatedAmort + CurrentPeriodInterestAccrualPeriodEnddate + CurrentPeriodPIKInterestAccrualPeriodEnddate + Discount + CapitalizedClosingCosts)) as Sum_GaapComponent    
	--	from Cre.NoteperiodicCalc nc    
	--	Inner join cre.note n on n.noteid = nc.noteid    
	--	where nc.[Month] is not null    
	--	and nc.AnalysisID = @AnalysisID    
	--	and nc.noteid = @NoteID    
	--)a    
	--group by a.noteid    
 
	IF(ABS(@GAAPCOmponent) > 0.01)    
	BEGIN 
		SET @ISException_GAAPComponent = 1
	END   
  
	-----n.noteid,ROUND(SUM(TotalAmortAccrualForPeriod),0) TotalAmortAccrualForPeriod,ROUND(SUM(DiscountPremiumAccrual),0) DiscountPremiumAccrual,ROUND(SUM(CapitalizedCostAccrual),0) CapitalizedCostAccrual


	----Amort Check
	--Select 
	--@ISException_AmortFeeCheck = (CASE WHEN ABS(Delta_AmortFeeCheck) > 10 THEN 1 ELSE 0 end) ,
	--@ISException_AmortDiscountPremiumCheck = (CASE WHEN ABS(Delta_AmortDiscountPremiumCheck) > 10 THEN 1 ELSE 0 end) ,
	--@ISException_AmortCapCostCheck = (CASE WHEN ABS(Delta_AmortCapCostCheck) > 10 THEN 1 ELSE 0 end) 
	--From(

	--	Select 
	--	(ROUND(SUM(TotalAmortAccrualForPeriod),0) - ROUND(tblTr.[IncludedInLevelYield],0)) as Delta_AmortFeeCheck
	--	,(ROUND(SUM(DiscountPremiumAccrual),0) - ROUND(tblTr.[DiscountPremium],0)) as Delta_AmortDiscountPremiumCheck
	--	,(ROUND(SUM(CapitalizedCostAccrual),0) - ROUND(tblTr.[CapitalizedClosingCost],0)) as Delta_AmortCapCostCheck
	--	from Cre.NoteperiodicCalc nc    
	--	Inner join cre.note n on n.noteid = nc.noteid    
	--	LEFT JOIN(
	--		Select noteid,ISNULL([IncludedInLevelYield],0) as [IncludedInLevelYield],ISNULL([DiscountPremium],0) as [DiscountPremium],ISNULL([CapitalizedClosingCost],0) as [CapitalizedClosingCost]
	--		From(
	--			Select noteid,[Type],SUM(Amount) as Amount
	--			From(
	--				Select noteid,Amount,(CASE WHEN [Type] like '%IncludedInLevelYield%' THEN 'IncludedInLevelYield' WHEN [Type] = 'Discount/Premium' THEN 'DiscountPremium' ELSE [Type] END) as [Type]
	--				from cre.transactionEntry
	--				Where ([Type] like '%IncludedInLevelYield%' OR [Type] = 'Discount/Premium' OR [Type] = 'CapitalizedClosingCost')
	--				and analysisid =@AnalysisID
	--				and noteid = @NoteID
	--			)a
	--			group by noteid,[Type]

	--		) AS SourceTable  
	--		PIVOT  
	--		(  
	--			MIN(Amount)  
	--			FOR [Type] IN ([IncludedInLevelYield],[DiscountPremium],[CapitalizedClosingCost])  
	--		) AS PivotTable
	--	)tblTr on tblTr.noteid = n.noteid
	--	where nc.[Month] is not null    
	--	and nc.AnalysisID = @AnalysisID
	--	and nc.noteid =@NoteID
	--	group by n.noteid,tblTr.[IncludedInLevelYield],tblTr.[DiscountPremium],tblTr.[CapitalizedClosingCost]
	--)z
	



		--Amort Check
	Select 
	@ISException_AmortFeeCheck = (CASE WHEN ABS(Delta_AmortFeeCheck) > 10 THEN 1 ELSE 0 end) ,
	@ISException_AmortDiscountPremiumCheck = (CASE WHEN ABS(Delta_AmortDiscountPremiumCheck) > 10 THEN 1 ELSE 0 end) ,
	@ISException_AmortCapCostCheck = (CASE WHEN ABS(Delta_AmortCapCostCheck) > 10 THEN 1 ELSE 0 end) 
	From(
		Select n.crenoteid
		,(ROUND(SUM(TotalAmortAccrualForPeriod),0) - ROUND(ISNULL(tblTr.[IncludedInLevelYield],0),0)) as Delta_AmortFeeCheck
		,(ROUND(SUM(DiscountPremiumAccrual),0) - ROUND(ISNULL(tblTr.[DiscountPremium],0),0)) as Delta_AmortDiscountPremiumCheck
		,(ROUND(SUM(CapitalizedCostAccrual),0) - ROUND(ISNULL(tblTr.[CapitalizedClosingCost],0),0)) as Delta_AmortCapCostCheck
		from Cre.NoteperiodicCalc nc    
		Inner join cre.note n on n.noteid = nc.noteid    
		inner join core.account acc on acc.accountid = n.account_accountid
		LEFT JOIN(
			Select noteid,ISNULL([IncludedInLevelYield],0) as [IncludedInLevelYield],ISNULL([DiscountPremium],0) as [DiscountPremium],ISNULL([CapitalizedClosingCost],0) as [CapitalizedClosingCost]
			From(
				
				-------------------------------------------------
				Select z.noteid,z.[Type],SUM(Amount_Inc_reciev) as Amount
				From(
					Select b.noteid,(CASE WHEN b.[Type] = 'Discount/Premium' THEN 'DiscountPremium'	WHEN b.[Type] = 'CapitalizedClosingCost' THEN 'CapitalizedClosingCost' ELSE 'IncludedInLevelYield' end ) as [Type], 
					(SUM(Include_Amount)  + ISNULL(tblStrip.Strip_Amount,0)) Amount_Inc_reciev
					From(
						Select noteid,ISNULL(Amount,0) as Include_Amount,REPLACE([Type],'IncludedInLevelYield','') as [Type]
						from cre.transactionEntry tr
						Where ([Type] like '%IncludedInLevelYield%'	OR [Type] = 'Discount/Premium' OR [Type] = 'CapitalizedClosingCost')
						and analysisid = @AnalysisID
						and noteid = @NoteID
					)b
					Left Join(
						Select noteid,[Type],SUM(Strip_Amount) as Strip_Amount
						From(
							Select noteid,Amount as Strip_Amount,REPLACE(REPLACE([Type],'StripReceivable',''),'OriginationFeeStripping','OriginationFee') as [Type]
							from cre.transactionEntry
							Where ([Type] like '%StripReceivable%' OR [Type] = 'OriginationFeeStripping')	
							and analysisid = @AnalysisID
							and noteid = @NoteID
						)a
						group by noteid,[Type]

					)tblStrip on tblStrip.noteid = b.noteid and tblStrip.[Type] = b.[Type]
					group by b.noteid,b.[Type],tblStrip.Strip_Amount
				)z
				group by z.noteid,z.[Type]
				-------------------------------------------------

			) AS SourceTable  
			PIVOT  
			(  
				MIN(Amount)  
				FOR [Type] IN ([IncludedInLevelYield],[DiscountPremium],[CapitalizedClosingCost])  
			) AS PivotTable
		)tblTr on tblTr.noteid = n.noteid
		where nc.[Month] is not null    and acc.isdeleted <> 1
		and nc.AnalysisID = @AnalysisID
		and nc.noteid = @NoteID
		group by n.crenoteid, n.noteid,tblTr.[IncludedInLevelYield],tblTr.[DiscountPremium],tblTr.[CapitalizedClosingCost]
	)z
	
 
 
  
	----Insert Exeptions     
	Delete from core.Exceptions where ObjectID=@NoteID and FieldName in ('GAAP Component' ,'Amort Fee Check','Amort Discount Premium Check','Amort Cap Cost Check')
 
	IF(@ISException_GAAPComponent  = 1)    
	BEGIN    
		INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
		VALUES(@NoteID,@ObjectTypeID,'GAAP Component','GAAP Component is not matching',@ActionLevelID,@UserID,getdate(),@UserID,getdate())    
	END    

	IF(@ISException_AmortFeeCheck  = 1)    
	BEGIN    
		INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
		VALUES(@NoteID,@ObjectTypeID,'Amort Fee Check','Amort Fee is not matching',@ActionLevelID,@UserID,getdate(),@UserID,getdate())    
	END  

	IF(@ISException_AmortDiscountPremiumCheck  = 1)    
	BEGIN    
		INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
		VALUES(@NoteID,@ObjectTypeID,'Amort Discount Premium Check','Amort Discount Premium is not matching',@ActionLevelID,@UserID,getdate(),@UserID,getdate())    
	END  

	IF(@ISException_AmortCapCostCheck  = 1)    
	BEGIN    
		INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
		VALUES(@NoteID,@ObjectTypeID,'Amort Cap Cost Check','Amort Cap Cost is not matching',@ActionLevelID,@UserID,getdate(),@UserID,getdate())    
	END  
  
  
  
    
    
END    
    
    
    
    
    
    
END