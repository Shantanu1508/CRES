-- Procedure
-- Procedure

-- [HBOT].[usp_GetListEntityByIntent] 'Deal','name','the post','DealFullyfunded'
-- [HBOT].[usp_GetListEntityByIntent] 'Deal','name','Woodmere Rehabilitation','CapitalizedInterestTotalFunding'
-- [HBOT].[usp_GetListEntityByIntent] 'Deal','name','Griffin Club','FeeStripping'
-- [HBOT].[usp_GetListEntityByIntent] 'Deal','name','catalyst','FeeStripping'
-- [HBOT].[usp_GetListEntityByIntent] 'Note','id','2230','UnFundedNote'
-- [HBOT].[usp_GetListEntityByIntent] 'Deal','name','North Central Plaza III','NextAmortPaymentDate'
-- [HBOT].[usp_GetListEntityByIntent] 'deal','name','Urban Style Flats','DealWholeLoanSpread'
-- [HBOT].[usp_GetListEntityByIntent] 'deal','id','17-0255','InitialFunding'
-- [HBOT].[usp_GetListEntityByIntent] 'deal','name','Colony SE Hotel Portfolio','Property'
-- [HBOT].[usp_GetListEntityByIntent] 'deal','id','19-1471','PIKBalance'
--  [HBOT].[usp_GetListEntityByIntent] 'deal','id','17-1242','LoanAdvances'
-- [HBOT].[usp_GetListEntityByIntent] 'deal','id','18-0841','CurrentBalanceDeal'
-- [HBOT].[usp_GetListEntityByIntent] 'deal',null,null,'DealWithoutLIBORFloor'
-- [HBOT].[usp_GetListEntityByIntent] 'deal','name','Acore Credit IV','ClientTotalBalance'
-- [HBOT].[usp_GetListEntityByIntent] 'null','null','Delphi Financial','ClientSubDebtBalance'

CREATE PROCEDURE [HBOT].[usp_GetListEntityByIntent]  
	@ObjectType  nvarchar(256),
	@ObjectNature  nvarchar(256),
	@ObjectValue  nvarchar(256),
	@Intent  nvarchar(256)
AS  
BEGIN  
    SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
---------To set starttime for log------
	--DECLARE @StartTime datetime;
	--SET @StartTime = getdate();
	--------------------------------------

Declare @Analysisid uniqueidentifier = (SELECT AnalysisID from CORE.Analysis WHERE Name='Default');
Declare @todaydate date = cast(getdate() as date);
--IF(@ObjectType = 'Deal')
--BEGIN
	IF(@Intent = 'TimeLeftFullyExtended')
	BEGIN
	SELECT d.DealName,convert(varchar,MAX(fullymatdate.FullyExtendedMaturityDate),101) as FullyExtendedMaturityDate, 
		DATEDIFF(month,getdate(),MAX(fullymatdate.FullyExtendedMaturityDate)) as [Months] 
		from cre.note n
		inner join Core.Account acc on acc.AccountID = n.Account_AccountID
		inner join cre.deal d on d.DealId = n.dealid
		left join (
					Select n.noteid,mat.MaturityDate as FullyExtendedMaturityDate
					from [CORE].Maturity mat  
					INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
					INNER JOIN   
					(         
						Select   
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
						inner join cre.deal d on d.dealid = n.DealID
						where EventTypeID = 11  and eve.statusID = 1
						and d.dealname= @ObjectValue
						and acc.IsDeleted = 0  
						GROUP BY n.Account_AccountID,EventTypeID    
					) sEvent    
					ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.statusID = 1
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
					where acc.isdeleted <> 1	
					and mat.maturityType = 710
			      ) fullymatdate on fullymatdate.NoteID = n.NoteID
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1
		group by d.DealName
		
		--SELECT d.DealName,convert(varchar,MAX(n.FullyExtendedMaturityDate),101) as FullyExtendedMaturityDate, 
		--DATEDIFF(month,getdate(),MAX(n.FullyExtendedMaturityDate)) as [Months] 
		--from cre.note n
		--inner join Core.Account acc on acc.AccountID = n.Account_AccountID
		--inner join cre.deal d on d.DealId = n.dealid
		--where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		--and d.IsDeleted<>1
		--group by d.DealName
	END

	IF(@Intent = 'DateLoanOriginate')
	BEGIN
		Select d.DealName,convert(varchar,MIN(n.ClosingDate),101) ClosingDate,
		SUM(n.InitialFundingAmount) InitialFundingAmount
		from cre.Deal d 
		inner join cre.note n on n.dealid = d.dealid
		inner join core.account acc on acc.AccountID = n.Account_AccountID
		where d.DealName = @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1
		and acc.IsDeleted <>1
		group by d.DealName
	END

	IF(@Intent = 'FirstLoanAdvanceProjected')
	BEGIN
		Select top 1 convert(varchar,df.Date,101)as Date ,df.Amount
		from cre.Deal d 
		inner join cre.dealfunding df on df.dealid =d.dealid
		left join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and df.amount > 0
		and d.IsDeleted<>1
		order by df.date
	END

	IF(@Intent = 'CumulativeInterest')
	BEGIN
		Select isnull(CAST(SUM(df.amount) as varchar),'') as Amount, isnull(convert(varchar,MAX(df.Date),101),'') as Date
		from cre.dealfunding df 
		inner join cre.deal d on d.dealid =df.dealid
		inner join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and l.Name = 'Capitalized Interest' and d.IsDeleted<>1
		GROUP By d.dealid
	END

	IF(@Intent = 'FirstPayDown')
	BEGIN
		select top 1 CONVERT(varchar, df.Date, 101)  as Date,df.Amount
		from  cre.Deal d
		inner join cre.dealfunding df on df.Dealid = d.Dealid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and df.purposeid =631
		order by df.date
	END
	
	
	

	IF(@Intent = 'UnFunded')
	BEGIN
		SELECT  DealName ,SUM(Amount) as TotalUnfundedBalance ,convert(varchar,(Date),101) as LastPaydownDate
			FROM(
				SELECT df.Amount  , df.DealID, d.DealName,
				Min(df.Date) Over (Partition by d.DealName order by d.DealName,df.Date asc) as Date	
				from CRE.Deal d 
				left join cre.dealfunding df on df.DealID = d.DealID
				WHERE d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
				and df.Amount>0
				and df.Applied <> 1
				and d.IsDeleted<>1
			)a
			group by DealName,Date

		--SELECT top 1 d.DealName,SUM(n.TotalCommitment) - (ncalc.EndingBalance) as TotalUnfundedBalance,
		--convert(varchar,(ncalc.PeriodEndDate),101) as LastPaydownDate 
		--from CRE.Deal d 
		--left join CRE.Note n on n.dealID = d.DealID
		--left join CRE.NotePeriodicCalc ncalc on ncalc.NoteID = n.NoteID and ncalc.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		--WHERE d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		--and PeriodEndDate <= CAST(getdate() as Date)
		
		--group by d.DealName,ncalc.EndingBalance,ncalc.PeriodEndDate
		--order by ncalc.PeriodEndDate desc

		--Select d.AggregatedTotal - (SUM(Distinct n.initialfundingamount) + SUM(Distinct df.Amount)) as Amount  
		--,(Select MAX(ddf.date) from cre.dealfunding ddf where ddf.purposeid = 631 and ddf.dealid = d.dealid)  as [Date] 
		--from cre.Deal d 
		--inner join cre.dealfunding df on df.dealid =d.dealid
		--inner join cre.note n on n.dealid = d.dealid
		--where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		--and df.Applied = 1	
		--and df.Amount > 0	
		--group by d.dealid,d.AggregatedTotal

	END

	IF(@Intent = 'SpreadChangeDeal')
	BEGIN
		Select top 1 convert(varchar,rs.Date,101) as Date,rs.Value from [CORE].RateSpreadSchedule rs
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
		INNER JOIN (						
			Select 
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			inner join cre.deal d on d.dealid = n.dealid
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = 14
			and eve.StatusID = 1
			and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
			and acc.IsDeleted = 0
			GROUP BY n.Account_AccountID,EventTypeID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		where e.StatusID = 1
		and LValueTypeID.name = 'spread'
		and rs.Date <= getdate()
		order by rs.date desc
	END

	
	IF(@Intent = 'NextForceFunding')
	BEGIN
		Select  top 1 d.DealName,df.Amount,convert(varchar,df.Date,101) as Date
		from cre.Deal d 
		inner join cre.dealfunding df on df.dealid =d.dealid
		left join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and l.Name = 'Force Funding'
		and df.Applied <> 1
		and d.IsDeleted<>1
		order by df.date
	END

	IF(@Intent = 'Maturity')
	BEGIN
		Select dd.CREDealID as DealID
		,dd.DealName as [Deal Name]
		,CRENoteID as NoteID
		,a.Name as [Note Name]
		,Convert(varchar,
		(ISNULL(n.ActualPayoffDate,InitialMaturity.currMaturityDate)),101) as Maturity
		,tblBls.EndingBalance as [Estimated Balance]
		from cre.Note n
		inner join Core.Account a on n.Account_AccountID=a.AccountID
		inner join cre.Deal dd on dd.dealid = n.dealid
		left join(
					Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as currMaturityDate
					from cre.note n1
					Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
					inner join cre.deal d on d.dealid = n1.dealid
					Left Join(
						Select noteid,MaturityType,MaturityDate,Approved
						from (
								Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
								ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
								from [CORE].Maturity mat  
								INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
								INNER JOIN   
								(          
									Select   
									(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
									MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
									INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
									INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
									inner join cre.deal ddd on ddd.dealid = n.dealid
									where EventTypeID = 11 and eve.statusID = 1
									and  ddd.dealname = @ObjectValue   
									and acc.IsDeleted = 0  
									GROUP BY n.Account_AccountID,EventTypeID    
								) sEvent    
						ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.statusID = 1
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 
						inner join cre.deal dd on dd.dealid = n.dealid
						Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
						Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
						where dd.dealname = @ObjectValue
						and mat.MaturityDate > getdate()
						and lApproved.name = 'Y'
				)a where a.rno = 1
			)currMat on currMat.noteid = n1.noteid
			where acc1.IsDeleted <> 1
			and d.dealname = @ObjectValue
			)InitialMaturity on InitialMaturity.noteid = n.noteid
					--Select   
			--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			--	inner join cre.Deal ddd on ddd.dealid = n.dealid
			--	INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID  
			--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
			--	and ddd.dealname= @ObjectValue --IIF(@ObjectNature = 'name',ddd.DealName,ddd.credealid) =  @ObjectValue
			--	GROUP BY n.Account_AccountID,EventTypeID  
			--) sEvent  
			--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		Left Join(
			Select noteid,EndingBalance from(
			select Distinct nn.noteid,PeriodEndDate,ISNULL(EndingBalance,0) EndingBalance,
			ROW_NUMBER() Over (Partition by nn.noteid Order by nn.noteid,np.PeriodEndDate desc) as rno
			from [CRE].[NotePeriodicCalc] np
			Inner join cre.note nn on nn.Account_AccountID = np.AccountID
			inner join cre.Deal dd on dd.dealid = nn.dealid
			where dd.dealname= @ObjectValue --IIF(@ObjectNature = 'name',dd.DealName,dd.credealid) =  @ObjectValue
			and PeriodEndDate <= CAST(getdate() as Date) and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			)a where a.rno = 1
		)tblBls on tblBls.NoteID = n.NoteID
		where dd.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name

	END
	--IF(@Intent = 'BalloonPayment')
	--BEGIN
	--	SELECT 
	--	d.CREDealID
	--	,d.DealName 
	--	,CRENoteID   
	--	,a.Name as [Name] 
	--	,tr.balloon
 
	--	FROM CRE.Note n 
	--	inner join Core.Account a on n.Account_AccountID=a.AccountID  
	--	inner join cre.Deal d on d.dealid = n.dealid
	--	left join
	--	(
	--		Select noteid, Abs(Amount) as balloon from CRE.TransactionEntry 
	--		where AnalysisID = @Analysisid
	--		and [Type] = 'Balloon'
	--	)Tr on Tr.noteid = n.noteid
	--	where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
	--	and d.IsDeleted<>1
	--	order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name 
	--END

	IF(@Intent = 'PayDowns')
	BEGIN
		Select SUM(df.Amount) as TotalAmount ,count(df.purposeid) as Cnt ,convert(varchar,MAX(df.date),101) as [Date]
		from cre.Deal d 
		inner join cre.dealfunding df on df.dealid =d.dealid
		left join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and l.Name = 'Paydown' and d.IsDeleted<>1
		Group by l.name
	END

	IF(@Intent = 'DealFullyfunded')
    BEGIN
         SELECT n.CRENoteID,
		 convert(varchar,maturitydate.Maturity,101) as Maturity
        from cre.note n
        inner join cre.deal d on d.dealid = n.dealid 
        inner join core.account acc on acc.AccountID = n.Account_AccountID
		left join (Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as Maturity
					from cre.note n1
					Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
					inner join cre.deal d on d.dealid = n1.dealid
					Left Join(
						Select noteid,MaturityType,MaturityDate,Approved
						from (
								Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
								ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
								from [CORE].Maturity mat  
								INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
								INNER JOIN   
								(          
									Select   
									(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
									MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
									INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
									INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
									inner join cre.deal ddd on ddd.dealid = n.dealid
									where EventTypeID = 11 and eve.statusID = 1
									and  ddd.dealname = @ObjectValue   
									and acc.IsDeleted = 0  
									GROUP BY n.Account_AccountID,EventTypeID    
								) sEvent    
								ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.statusID = 1
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 
								inner join cre.deal dd on dd.dealid = n.dealid
								Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
								Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
								where dd.dealname = @ObjectValue
								and mat.MaturityDate > getdate()
								and lApproved.name = 'Y'
						)a where a.rno = 1
					)currMat on currMat.noteid = n1.noteid
					where acc1.IsDeleted <> 1
					and d.dealname = @ObjectValue) maturitydate on maturitydate.NoteID = n.NoteID
        where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1 and acc.IsDeleted<>1

		--convert(varchar,(case when n.ActualPayoffDate is not null then n.ActualPayoffDate  
                --when (select SelectedMaturityDate from core.Maturity where EventID=   
                --(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
                --) >= getdate() or (n.ExtendedMaturityScenario1 is null and n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null)   
                -- then (select SelectedMaturityDate from core.Maturity where EventID=   
                --(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
                --) else   
                --case when n.ExtendedMaturityScenario1>=GETDATE() or (n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else   
                --case when n.ExtendedMaturityScenario2 >=GETDATE() or (n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else   
                --case when n.ExtendedMaturityScenario3 >=GETDATE() or (n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario3 else  
                --n.FullyExtendedMaturityDate end --end   
                -- end end end ),101) as Maturity
    END
	
	IF(@Intent = 'NoteSplit')
    BEGIN
		
		SELECT n.CRENoteID,TrancheName,PercentofNote               
        from cre.note n
        inner join cre.deal d on d.dealid = n.dealid 
        inner join core.account acc on acc.AccountID = n.Account_AccountID
		left join CRE.NoteTranchePercentage nt on nt.crenoteid = n.crenoteid
        where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1 and acc.IsDeleted<>1
    END

	IF(@Intent = 'InitialFunding')
    BEGIN
		Select d.DealName,convert(varchar,MIN(n.ClosingDate),101) ClosingDate,
		SUM(n.InitialFundingAmount) InitialFundingAmount
		from cre.Deal d 
		inner join cre.note n on n.dealid = d.dealid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1
		group by d.DealName
   END

   IF(@Intent = 'LastFutureFunding')
    BEGIN
        select top 1  d.dealname as Deal,
		CONVERT(varchar, df.Date, 101)  as [FundingDate],
		df.Amount as [FundingAmount]
        from  cre.Deal d
        inner join cre.dealfunding df on df.Dealid = d.Dealid
        where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and df.Applied =1
		and df.Amount>0
		and d.IsDeleted<>1
        order by df.date Desc, dealfundingrowno desc
    END

	
	IF(@Intent ='FeeStripping')
	BEGIN
	SELECT top 1 d.[DealName],(CASE WHEN tblFeeStripp.FeetobeStripped = 1 THEN Cast(tblFeeStripp.CRENoteIDcount as nvarchar(256)) ELSE 'No' END )  as [Status]
	From cre.deal d
	Left Join
	(	
		Select 
		d1.DealId,d1.dealname as [DealName],pafs.FeetobeStripped, count(n1.CRENoteID) as CRENoteIDcount
		from [CORE].PrepayAndAdditionalFeeSchedule pafs
		INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId
		INNER JOIN 
		(
			Select 
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID 
			INNER JOIN [CRE].[Deal] d on d.DealID = n.DealID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')
			and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
			and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue
			and acc.IsDeleted = 0
			GROUP BY n.Account_AccountID,EventTypeID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		inner join core.account acc on acc.AccountID = e.AccountID
		inner join cre.note n1 on n1.Account_AccountID = acc.AccountID
		inner join cre.deal d1 on d1.DealID = n1.DealID
		where e.StatusID = 1 
		and FeetobeStripped = 1
		and d1.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d1.dealname,d1.credealid) =  @ObjectValue
		and d1.IsDeleted<>1
		group by d1.DealId, d1.dealname,pafs.FeetobeStripped
		)tblFeeStripp on tblFeeStripp.dealid = d.dealid
		WHERE d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1
	END

	
	IF(@Intent = 'CapitalizedInterest')
    BEGIN
			select top 1 d.dealname as [DealName],
						(CASE WHEN df.purposeid=581 THEN 'had'ELSE 'hadn''t' END) as Status
			from  cre.Deal d
			left join cre.dealfunding df on df.Dealid = d.DealID and df.purposeid = 581
			where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.dealname,d.CREDealID) =  @ObjectValue
			and d.IsDeleted<>1
    END
	

	IF(@Intent = 'NextAmortPaymentDate')   
	BEGIN
		SELECT a.Deal,CONVERT(nvarchar,MIN(FirstScheduledAmortDate),101) as NextPaymentDate,SUM(AmortAmount) as AmortAmount
				FROM
					(
					 select   n.NoteID,d.DealName as Deal,te.Amount as AmortAmount,
								 convert(varchar,te.Date,101) as FirstScheduledAmortDate,
								 ROW_NUMBER() OVER(PARTITION BY n.NoteID,d.DealName ORDER BY n.NoteID,d.DealName,te.Date asc) as rownum
							from cre.deal d 
							left join cre.note n on n.DealID = d.DealID
							left join cre.DealFunding df on df.DealID = d.DealID
							left join cre.TransactionEntry te on te.AccountID = n.Account_AccountID
							where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
							and te.[Type]='ScheduledPrincipalPaid' and te.AnalysisID= @Analysisid
							and df.Applied=0
							and d.IsDeleted<>1
							and te.date>=getdate()
					)a
				WHERE a.rownum = 1
				group by a.Deal
	END
	
	IF(@Intent = 'NextCapExFundingDate')   
	BEGIN
		select top 1 
					df.Amount as [FundingAmount],
					convert(varchar,df.Date,101) as [FundingDate]
		from cre.deal d 
		inner join cre.dealfunding df on df.Dealid = d.Dealid
		left join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and l.Name = 'Capital Expenditure'
		and df.Applied=0
		and  d.IsDeleted<>1
		ORDER BY df.Date asc
	END
	
	IF(@Intent = 'CapitalizedInterestTotalFunding')   
	BEGIN
		SELECT Top 1 d.dealname as Deal,
					 SUM(df.Amount) as [Fundingtotal],
					 convert(varchar,getdate(),101) as [Today]
		from cre.deal d 
		inner join cre.dealfunding df on df.Dealid = d.Dealid
		left join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue -- IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and l.Name = 'Capitalized Interest'
		and df.Applied = 1
		and df.Date <= getdate()
		and d.IsDeleted<>1
		GROUP BY d.dealname
	END 

	IF(@Intent = 'FirstScheduledAmort')   
	BEGIN
	SELECT a.Deal,CONVERT(nvarchar,MIN(FirstScheduledAmortDate),101) as FirstScheduledAmortDate
		FROM
			(
			 select d.DealName as Deal,
						 convert(varchar,te.Date,101) as FirstScheduledAmortDate,
						 ROW_NUMBER() OVER(PARTITION BY n.NoteID,d.DealName ORDER BY n.NoteID,d.DealName,te.Date asc) as rownum
					from cre.deal d 
					left join cre.note n on n.DealID = d.DealID
					left join cre.DealFunding df on df.DealID = d.DealID
					left join cre.TransactionEntry te on te.AccountID = n.Account_AccountID
					where  d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
					and te.[Type]='ScheduledPrincipalPaid' and te.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'
					and df.Applied=0
					and d.IsDeleted<>1
					)a
					WHERE a.rownum = 1
					group by a.Deal
	END

	IF(@Intent ='TotalCommitmentDealName')
	BEGIN
		SELECT d.DealName, d.TotalCommitment as Amount from cre.deal d
		WHERE  d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.IsDeleted<>1
	END


	IF(@Intent ='PIKBalance')
	BEGIN
		Select DealName,SUM(Amount) as Amount
		FROM(
			Select d.DealName,n.noteid,n.crenoteid,
			(CASE WHEN SUM(tr.Amount) > 0 THEN SUM(tr.Amount) ELSE (SUM(tr.Amount) * -1) END) as Amount
			from cre.transactionEntry Tr
			inner join core.account ac on ac.AccountID = tr.AccountID
			inner join cre.note n on n.Account_AccountID = ac.AccountID
			inner join cre.deal d on d.DealID = n.DealID
			
			where tr.analysisID = @Analysisid and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')
			and tr.date <= CAST(getdate() as date)
			and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
			and ac.IsDeleted<>1
			and ac.AccountTypeID = 1
			group by n.noteid,n.crenoteid,d.DealName
			)a
		group by DealName
	END

	IF(@Intent = 'LoanAdvances')   
	BEGIN
		SELECT DealName,SUM(Cnt) as TotalCount ,SUM(Amount) as [Amount]
		from(
			SELECT  d.dealname as DealName, df.Amount, Date, count(d.dealname) as Cnt
			from cre.deal d 
			inner join cre.dealfunding df on df.Dealid = d.Dealid
			left join core.Lookup l on l.lookupid = df.purposeid
			where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
			and l.Name in('Capital Expenditure','TI/LC','Capitalized Interest','Force Funding')
			and df.Applied = 1
			and df.Date <= getdate()
			and d.IsDeleted<>1
			GROUP BY d.dealname,df.Amount,Date
			)a
		group by a.DealName
	END 

	IF(@Intent = 'Property')   
	BEGIN
		select PropertyName, l.name as PropertyType from CRE.Property p 
				left join CRE.Deal d on d.DealID = p.Deal_DealID
				left join core.lookup l on l.lookupid = p.PropertyType
				where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
				and d.IsDeleted<>1
	END
	
	IF(@Intent = 'CurrentBalanceDeal')
	BEGIN
			CREATE TABLE #tmpNte
			(NoteId NVARCHAR(800), CurrentBalance DECIMAL(20,8));
        INSERT INTO #tmpNte (NoteId, CurrentBalance)
			SELECT n.CRENoteID as NoteID, 
			   ISNULL(  
				(  
				 Select ISNULL(SUM(ISNULL(FS.Value,0)),0)  
				 from [CORE].FundingSchedule fs  
				 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
				 INNER JOIN  
				 (  
					Select  
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n1.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
					from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n1 ON n1.Account_AccountID = eve.AccountID and n1.noteid=n.noteid  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n1.Account_AccountID  
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
					and n1.dealid = d.dealid and acc.IsDeleted = 0  
					and eve.StatusID = 1
					GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID  
				   ) sEvent    
				 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID    
				 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
				 left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
				 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
				 where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0  
				 and fs.Date = Cast(getdate() AS DATE))   
				 +    
				 ISNULL((select SUM((ISNULL(EndingBalance,0)))  
				 from [CRE].[NotePeriodicCalc] np  
				 where np.AccountID = n.Account_AccountID and n.dealid = d.dealid and PeriodEndDate = CAST(getdate() - 1 as Date) and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'),0)     
				,0) CurrentBalance
 
				FROM CRE.Note n 
				inner join Core.Account a on n.Account_AccountID=a.AccountID  
				inner join cre.Deal d on d.dealid = n.dealid
				where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue
				and d.IsDeleted<>1

		SELECT NoteId, CurrentBalance FROM #tmpNte
		UNION 
		SELECT 'Total', SUM(CurrentBalance) FROM #tmpNte
		ORDER BY NoteID ASC

		DROP TABLE #tmpNte
	END

	IF(@Intent ='DealWithoutLIBORFloor')
	BEGIN
			SELECT d.CREDealID,d.DealName from cre.deal d
			where d.CREDealID not in (
										Select distinct d.CREDealID from [CORE].RateSpreadSchedule rs
										INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
										left join core.Account acc on acc.AccountID = e.AccountID
										left join cre.note n on n.Account_AccountID = acc.AccountID
										left join cre.deal d on d.DealID=n.DealID
										LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
										INNER JOIN (						
											Select 
											(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
											MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
											INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
											inner join cre.deal d on d.dealid = n.dealid
											INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
											where EventTypeID = 14
											and eve.StatusID = 1
											and acc.IsDeleted <>1
											GROUP BY n.Account_AccountID,EventTypeID
										) sEvent
										ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
										where e.StatusID = 1
										and LValueTypeID.name ='Index Floor'
										and d.IsDeleted <> 1
										)
			and d.IsDeleted<>1
	END

	IF(@Intent ='PayOffDeal')
	BEGIN
		SELECT DealName, [Date]
		FROM(
			SELECT d.DealName,Convert(varchar,ISNULL(MAX(n.ActualPayoffDate),funddate.Date),101) as [Date]
			from cre.Note n
			inner join Core.Account acc on n.Account_AccountID=acc.AccountID
			inner join cre.Deal d on d.dealid = n.dealid
			left join ( select df.DealID,df.Date from CRe.DealFunding df
						inner join cre.Deal dd on dd.dealid = df.dealid
						left join core.Lookup l on l.lookupid = df.purposeid
						where dd.dealname= @ObjectValue --IIF(@ObjectNature = 'name',dd.DealName,dd.credealid) =  @ObjectValue
						and l.Name = 'Full Payoff'
					  )funddate on funddate.DealID = d.DealID
			WHERE d.IsDeleted<>1 and acc.isDeleted<>1
			and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
			GROUP BY d.DealName,funddate.Date
			)a
		WHERE a.[Date] is not null
	END

	IF(@Intent ='DealWholeLoanSpread')
	BEGIN
	SELECT DealName, SUM(ValOriginalCommitment)/SUM(OriginalTotalCommitment) as DealWholeSpread 
	FROM
		(
		SELECT DealName,(Value*OriginalTotalCommitment)  as ValOriginalCommitment, OriginalTotalCommitment,CRENoteID
		FROM (
			Select sEvent.CRENoteID, rs.Value, sEvent.OriginalTotalCommitment,sEvent.DealName  from [CORE].RateSpreadSchedule rs
					INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
					LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
					INNER JOIN (						
						Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,n.CRENoteID,n.OriginalTotalCommitment,d.DealName,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						inner join cre.deal d on d.dealid = n.dealid
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = 14
						and eve.StatusID = 1
						and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
						and acc.IsDeleted <> 1
						GROUP BY n.Account_AccountID,EventTypeID,n.CRENoteID,n.OriginalTotalCommitment,d.DealName
					) sEvent
					ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
					where e.StatusID = 1
					and LValueTypeID.name = 'spread'
					and rs.Date <= getdate()
		)a
		group by a.Value,a.OriginalTotalCommitment,CRENoteID,DealName
	)b
	group by DealName
	END

	IF(@Intent ='DealLIBORFloor')
	BEGIN
		SELECT top 1 d.DealName,interestratefloorPCT as Dealliborfloor
		FROM UwNote un
		inner join cre.deal d on d.CREDealID = un.ControlId_F
		inner join cre.note n on n.CRENoteID = un.NoteID
		inner join core.Account acc on acc.AccountID=n.Account_AccountID
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and acc.IsDeleted <> 1
	END

	IF(@Intent ='NextPropertyRelease')
	BEGIN
		select top 1  d.DealName as [Deal],
					df.Amount as [Amount],
					convert(varchar,df.Date,101) as [Date]
		from cre.deal d 
		inner join cre.dealfunding df on df.Dealid = d.Dealid
		left join core.Lookup l on l.lookupid = df.purposeid
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and l.Name = 'Property Release'
		and df.Amount<0
		and df.Date > GETDATE()
		and d.IsDeleted <>1
		ORDER BY df.Date asc
	END
	IF(@Intent ='DealCapExAndTI/LCFund')
	BEGIN
		SELECT Deal,ISNULL([Capital Expenditure],0) as Amount1, ISNULL([TI/LC],0) as Amount2 
		FROM (
			  SELECT Deal,SUM(Amount) as Amount,Name 
			  from (
					select d.DealName as [Deal],df.date,l.Name,
						  ISNULL(df.Amount,0) as [Amount]
					from cre.deal d 
					inner join cre.dealfunding df on df.Dealid = d.Dealid
					inner join cre.note n on n.DealID =d.DealID
					inner join core.account acc on acc.AccountID = n.Account_AccountID
					left join core.Lookup l on l.lookupid = df.purposeid
					where  d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
					and l.Name in ('Capital Expenditure','TI/LC')
					and df.Date <= GETDATE()
					and d.IsDeleted <>1
					and acc.IsDeleted<>1
					group by dealname,df.date,df.Amount,l.Name
				 )a
			  group by Deal,Name
			)t
		PIVOT(SUM(Amount) FOR Name in ([Capital Expenditure],[TI/LC])) as tab
	END
	
	
IF(@Intent ='DealFutureFullyFunded')
	BEGIN
		SELECT ISNULL(a.NoteID,n.CRENoteID) as NoteID, ISNULL(a.[Note Name],ac.Name) as [NoteName], ISNULL(a.[Remaining Funding],0) as [RemainingFunding]
		FROM CRE.note n 
		left join(
				Select  
				 n.CRENoteID as NoteID
				,acc.Name as [Note Name]
				,SUM(ISNULL(fs.Value,0)) as [Remaining Funding]
				from [CORE].FundingSchedule fs
				left JOIN [CORE].[Event] e on e.EventID = fs.EventId
				left JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				left JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				left JOIN [CRE].[Deal] dd on dd.DealID = n.DealID
				left JOIN 
							(
								Select 
									(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID,
									MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
									from [CORE].[Event] eve
									INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
									INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
									INNER JOIN [CRE].[Deal] d on d.DealID = n.DealID
									where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
									and d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
									and acc.IsDeleted = 0
									and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
									GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
							) sEvent
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID 
				left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
				left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
				where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 
				and dd.IsDeleted<>1 
				and acc.IsDeleted<>1
				and fs.Date > getDate() 
				and fs.Value>0
				group by n.CRENoteID,acc.Name,n.lienposition,n.priority
				)a on a.NoteID = n.CRENoteID
		inner join core.account ac on ac.AccountID = n.Account_AccountID
		inner join cre.deal d on d.dealid = n.dealid
		WHERE d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and ac.IsDeleted<>1 and d.IsDeleted<>1
		order by  ISNULL(n.lienposition,99999), n.[priority],n.InitialFundingAmount desc,ac.name
	END

	IF(@Intent ='DealTotalRequiredEquity')
	BEGIN
		SELECT d.dealName as Deal,ISNULL(SUM(adjm.TotalRequiredEquity),0) as [TotalRequiredEquity] 
		from cre.NoteAdjustedCommitmentMaster adjm
		left join cre.deal d on d.DealID = adjm.DealID
		WHERE d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.isDeleted <> 1
		group by dealname
	END

	IF(@Intent ='DealInitialFundingAtClosing')
	BEGIN
		SELECT d.dealName as Deal,ISNULL(SUM(n.InitialFundingAmount),0)as InitialFundingAmount
		from cre.note n 
		left join cre.deal d on d.DealID = n.DealID
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
		and d.isDeleted <> 1
		and n.InitialFundingAmount>1
		group by dealname
	END

	IF(@Intent ='DealTerm')
	BEGIN
		SELECT  Deal,
			Convert(varchar,MAX(Maturity),101) as CurrentMaturity,
			DATEDIFF(month,MIN(ClosingDate),MAX(Maturity)) AS CurrentTerm,
			ISNULL(PaidOff,'True')as PaidOff
		FROM (
			   Select   d.DealName as Deal
						,CRENoteID as NoteID
						,a.Name as [Note Name]
						,falsepaidoff.PaidOff
						,(ISNULL(n.ActualPayoffDate,InitialMaturity.MaturityDate)) as Maturity
						,ClosingDate
						,n.ActualPayoffDate
						from cre.Note n
						inner join Core.Account a on n.Account_AccountID=a.AccountID
						inner join cre.Deal d on d.dealid = n.dealid
						left join(
							Select n.noteid,mat.MaturityDate  
							from [CORE].Maturity mat  
							INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
							inner join core.account acc on acc.accountid = e.accountid
							inner join cre.note n on n.account_accountid =acc.accountid 
							INNER JOIN (Select   
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
								MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
								inner join cre.Deal ddd on ddd.dealid = n.dealid
								INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID  
								where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  and eve.statusID = 1
								and ddd.dealname= @ObjectValue --IIF(@ObjectNature = 'name',ddd.DealName,ddd.credealid) =  @ObjectValue
								and accSub.IsDeleted<>1
								GROUP BY n.Account_AccountID,EventTypeID  
							) sEvent  
							ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.statusID = 1
						)InitialMaturity on InitialMaturity.noteid = n.noteid
						left join (SELECT distinct d.DealID
									,'False' as PaidOff
									from cre.note n
									left join cre.deal d on d.dealid=n.dealid
									inner join core.account acc on acc.AccountID = n.Account_AccountID
									where
									 d.IsDeleted<>1
									and acc.IsDeleted<>1
									and ActualPayoffDate is null
									)falsepaidoff on falsepaidoff.DealID = d.DealID
						where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
						and d.IsDeleted<>1
						and a.IsDeleted<>1
			)a
		group by Deal,PaidOff
	END
	IF(@Intent = 'DealFunds')
	BEGIN
			SELECT CRENoteID as NoteID,acc.Name as [NoteName], f.[FundName],n.TotalCommitment
			FROM CRE.Deal d 
			left join cre.note n on n.DealID=d.DealID
			left join core.account acc on acc.AccountID = n.Account_AccountID
			left join cre.fund f on f.FundID = n.FundID
			where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
			and d.IsDeleted<>1
			and acc.IsDeleted<>1
			order by ISNULL(n.lienposition,99999), n.[priority],n.InitialFundingAmount desc,acc.name
	END

	IF(@Intent = 'DealTotalExitFee')
	BEGIN
		SELECT Date,FeeName, SUM(Amount) as TotalExitFee
		FROM(
			SELECT a.Deal,t.Amount,Convert(varchar,t.Date,101)as Date,t.FeeName
			FROM CRE.TransactionEntry t
			inner join core.Account acc on acc.AccountID = t.AccountID
			inner join cre.note n on n.Account_AccountID = acc.AccountID
			left join	
			(
				SELECT n.Account_AccountID,n.NoteId,d.DealName as Deal 
				from cre.note n 
				inner join core.Account acc on acc.AccountID = n.Account_AccountID
				inner join cre.deal d on d.DealID = n.DealID
				where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue
				and acc.IsDeleted<>1
				and d.IsDeleted<>1
			)a on a.Account_AccountID = t.AccountID
			WHERE n.NoteID = a.NoteID
			and t.AnalysisID = @Analysisid
			and t.FeeName LIKE 'Exit Fee%'
			group by t.Date,t.FeeName,a.Deal,t.Amount
		)b
		group by Date,FeeName,Deal
		order by Date asc
	END

	

	IF(@Intent = 'DealFullRecourse')
	BEGIN
		SELECT d.dealname as Deal,
			   (CASE WHEN uw.Recourse='Yes' THEN 'True' ELSE 'False' END) as Recourse 
		from UwDeal uw
		left join cre.deal d on d.CREDealID = uw.ControlId
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue 
		and d.IsDeleted<>1
	END

	IF(@Intent = 'DealLastPaydownFunding')
	BEGIN
		SELECT top 1 d.DealName,convert(varchar,df.Date,101) as Date,df.Amount 
		from CRE.DealFunding df
		left join cre.deal d on d.DealID = df.DealID
		inner join core.lookup l on l.LookupID = df.PurposeID
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue 
		and d.IsDeleted<>1
		and l.Name='Paydown'
		and df.Applied=1
		and df.Date<=getdate()
		order by date desc
	END
	
	IF(@Intent = 'DealNextPrepayment')
	BEGIN
		SELECT top 1 d.DealName as Deal,convert(varchar,df.Date,101) as Date,SUM(ISNULL(df.Amount,0)) as Amount
		from CRE.DealFunding df
		left join cre.deal d on d.DealID = df.DealID
		where d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue 
		and d.IsDeleted<>1
		and df.Amount<0
		and df.Date >= getdate()
		group by d.DealName,df.Date
		order by df.Date asc
	END

	IF(@Intent = 'DealWholeLoanCoupon')
	BEGIN
		SELECT Deal,(allcouponendingbal/EndingBalance) as WholeLoanCoupon
		FROM(
			SELECT Deal,SUM(AllInCouponRate*EndingBalance) as allcouponendingbal, SUM(EndingBalance) as EndingBalance
			FROM(
				  SELECT Deal,ISNULL(AllInCouponRate,0) as AllInCouponRate ,ISNULL(EndingBalance,0) as EndingBalance,npc.PeriodEndDate,n.NoteID
				  ,ROW_NUMBER() Over (Partition by n.noteid Order by n.noteid,npc.PeriodEndDate desc) as rno
				  from cre.NotePeriodicCalc npc
				  Inner Join cre.note n on n.Account_AccountID = npc.AccountID
				  left join (
							 SELECT d.DealName as Deal,NoteId from CRE.Note n 
							 inner join core.account acc on acc.AccountID = n.Account_AccountID
							 inner join cre.deal d on d.dealid=n.dealid
							 where d.IsDeleted<>1
							 and acc.IsDeleted<>1
							 and  d.dealname= @ObjectValue --IIF(@ObjectNature = 'name',d.DealName,d.credealid) =  @ObjectValue 
							 )a on a.NoteID = n.NoteID
				  WHERE AnalysisID= @Analysisid
				  and month(npc.PeriodEndDate) = month(DATEADD(mm, -1, GETDATE()))
				  and npc.PeriodEndDate <= getdate()
				  and a.NoteID = n.NoteID
				)b
		  where b.rno=1
		  group by b.Deal,PeriodEndDate
		)c
	END
--END


--IF(@ObjectType = 'Note')
--BEGIN	
	--IF(@Intent = 'UnFundedNote')
	--BEGIN
--		 SELECT  b.Note,b.Deal,(n.TotalCommitment- b.Value) as TotalUnfundedBalance,convert(varchar,(b.Date),101) as LastPaydownDate
--		 from cre.note n 
--		 left join(
--				SELECT SUM(a.Value) as Value,a.Note,a.Deal,a.Date
--				FROM(
--					Select  n.CRENoteID as Note, d.DealName as Deal ,fs.Value,
--					Max(fs.Date) Over (Partition by d.DealName,n.crenoteid order by d.DealName,n.crenoteid,fs.Date desc) as Date	
--						from [CORE].FundingSchedule fs
--						LEFT JOIN [CORE].[Event] e on e.EventID = fs.EventId
--						LEFT JOIN(						
--							Select 
--							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
--							from [CORE].[Event] eve
--							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							where EventTypeID = 10					
--							and acc.IsDeleted = 0
--							and eve.StatusID = 1
--							GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
--						) sEvent
--						ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
--						left JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--						left JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--						left join cre.deal d on d.dealid = n.dealid
--						where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 and fs.applied = 1
--						and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
--						and fs.Value>0
--				)a
--				group by a.Note,a.Deal,a.Date
--	)b on b.Note = n.CRENoteID
--left join core.account acc on acc.AccountID = n.Account_AccountID
--WHERE n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue


--		Select top 1 acc.Name as Note, d.DealName as Deal , SUM( fs.value)  as Amount  ,
--		convert(varchar,MAX(fs.date),101) as [Date] 
--		from [CORE].FundingSchedule fs
--		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
--		INNER JOIN(						
--			Select 
--			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
--			from [CORE].[Event] eve
--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--			where EventTypeID = 10					
--			and acc.IsDeleted = 0
--			and eve.StatusID = 1
--			and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
--			GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
--		) sEvent
--		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		inner join cre.deal d on d.dealid = n.dealid
--		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 and fs.applied =0
--		and fs.Value>0
--		group by acc.Name,d.DealName
--END

	IF(@Intent = 'NoteCurrentMaturity')
	BEGIN
	SELECT n.CRENoteID as Note,
		   convert(varchar,f.Maturity,101) as  [CurrentMaturityDate],
		   f.MaturityType as [Type]
    from cre.note n
    inner join cre.deal d on d.dealid = n.dealid 
    inner join core.account acc on acc.AccountID = n.Account_AccountID
	left join (
				Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as Maturity,currMat.MaturityType as MaturityType
					from cre.note n1
					Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
					inner join cre.deal d on d.dealid = n1.dealid
					Left Join(
						Select noteid,MaturityType,MaturityDate,Approved
						from (
								Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
								ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
								from [CORE].Maturity mat  
								INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
								INNER JOIN   
								(          
									Select   
									(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
									MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
									INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
									INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
									where EventTypeID = 11 and eve.statusID = 1
									and  n.crenoteid = @ObjectValue 
									and acc.IsDeleted = 0  
									GROUP BY n.Account_AccountID,EventTypeID    
								) sEvent    
								ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.statusID = 1
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 
								Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
								Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
								where n.crenoteid = @ObjectValue
								and mat.MaturityDate > getdate()
								and lApproved.name = 'Y'
						)a where a.rno = 1
					)currMat on currMat.noteid = n1.noteid
			where acc1.IsDeleted <> 1
			and n1.crenoteid = @ObjectValue
			and d.IsDeleted <> 1
			) f on f.NoteID = n.NoteID
		where n.CRENoteID =  @ObjectValue
		and acc.IsDeleted <> 1
		and d.IsDeleted<>1

		--SELECT n.CRENoteID as Note,
		--convert(varchar,(case when n.ActualPayoffDate is not null then n.ActualPayoffDate  
		--when (select SelectedMaturityDate from core.Maturity where EventID=   
		--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
		--) >getdate() or (n.ExtendedMaturityScenario1 is null and n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null)   
		-- then (select SelectedMaturityDate from core.Maturity where EventID=   
		--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
		--) else   
		--case when n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else   
		--case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else   
		--case when n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario3 else  
		--n.FullyExtendedMaturityDate end 
		-- end end end ),101) as [CurrentMaturityDate] ,

		-- convert(varchar,(case when n.ActualPayoffDate is not null then 'ActualPayoffDate'
		--when (select SelectedMaturityDate from core.Maturity where EventID=   
		--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
		--) >getdate() or (n.ExtendedMaturityScenario1 is null and n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null)   
		-- then 'SelectedMaturityDate' else
		--case when n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then 'ExtendedMaturityScenario1' else   
		--case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then 'ExtendedMaturityScenario2' else   
		--case when n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then 'ExtendedMaturityScenario3' else  
		--'FullyExtendedMaturityDate' end --end   
		-- end end end ),101) as Type
		--FROM CRE.Note n 
		--inner join Core.Account a on n.Account_AccountID=a.AccountID  
		--inner join cre.Deal d on d.dealid = n.dealid
		--where n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',a.name,n.crenoteid) =  @ObjectValue
		--order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name
		
	END
	
	IF(@Intent = 'CurrentLibor')
	BEGIN
		Select top 1 n1.CRENoteID as Note,
					rs.value as IndexFloor
	    from [CORE].RateSpreadSchedule rs 
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
		inner join core.account acc1 on acc1.accountid = e.accountid
		inner join cre.note n1 on n1.account_accountid = acc1.accountid
		inner join cre.deal d1 on d1.dealid = n1.dealid
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
		INNER JOIN
					(		
						Select
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							inner join cre.deal d on d.dealid = n.dealid
							where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
							and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)					
							and acc.IsDeleted = 0
							and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
							GROUP BY n.Account_AccountID,EventTypeID

					) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		where e.StatusID = 1 and LValueTypeID.name = 'Index Floor'
		and n1.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc1.name,n1.crenoteid) =  @ObjectValue
		and rs.Date <= getdate()
		order by rs.Date desc 
	END

	IF(@Intent ='FirstScheduledAmort')
	BEGIN
		Select top 1
			acc.Name as [Note],
			convert(varchar,ls.[Date],101) as [FirstScheduledAmortDate]
		from [CORE].AmortSchedule ls
		INNER JOIN [CORE].[Event] e on e.EventID = ls.EventId
		INNER JOIN 
			(
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID,eve.StatusID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [Cre].[Deal] d on d.DealID = n.DealID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'AmortSchedule')
					and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		inner JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		inner JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		inner JOIN [CRE].[Deal] d ON d.DealID = n.DealID
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
		and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		order by ls.Date asc
	END

	IF(@Intent ='TotalCommitmentNoteId')
	BEGIN
		SELECT n.CRENoteID as NoteID,n.TotalCommitment as Amount from CRE.Note n
		inner join core.Account acc on acc.AccountID = n.Account_AccountID
		WHERE n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		and acc.IsDeleted<>1
	END

	IF(@Intent = 'NoteInterestResetFrequency')
	BEGIN
		SELECT n.CRENoteID as Note,cast(ISNULL(n.RateIndexResetFreq,0) as int) as ResetFrequency, convert(varchar,n.FirstRateIndexResetDate,101) as FirstRateIndexResetDate
		from CRE.Note n
		inner join core.Account acc on acc.AccountID = n.Account_AccountID
		WHERE n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		and acc.IsDeleted<>1
	END

	IF(@Intent = 'NoteInterestCalcRuleForPaydowns')
	BEGIN
		SELECT n.CRENoteID as Note,
			   l.name as InterestCalculationRuleForPaydowns
		from CRE.Note n
		inner join core.Account acc on acc.AccountID = n.Account_AccountID
		left join core.lookup l on l.lookupid=n.InterestCalculationRuleForPaydowns
		WHERE n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		and acc.IsDeleted<>1
	END

	IF(@Intent = 'NoteFirstPaymentDate')
	BEGIN
		SELECT  PaymentDay,Note,(CASE WHEN PaymentDate = 1 THEN '31' ELSE PaymentDate END) as PaymentDate,
			   AccrualFrequency,
			   convert(varchar,FirstPaymentDate,101) as FirstPaymentDate
		FROM
			(
				SELECT  FORMAT(cast (n.FirstPaymentDate as date), 'dddd') AS PaymentDay,
						n.CRENoteID as Note,
						n.AccrualFrequency,
						IIF(n.FirstPaymentDate = EOMONTH(n.FirstPaymentDate), 1,FORMAT (n.FirstPaymentDate, 'dd')) as PaymentDate,
						n.FirstPaymentDate 
				from CRE.Note n
				inner join core.Account acc on acc.AccountID = n.Account_AccountID
				WHERE n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
				and acc.IsDeleted<>1
			)a
	END

	IF(@Intent = 'NoteInterestRateCouponAndIndexCap')
	BEGIN
		SELECT Note, ISNULL([Coupon Cap],0) as [CouponCap] ,ISNULL([Index Cap],0) as [IndexCap]
		FROM (
			Select  n.CRENoteID as [Note],
			rs.Value,LValueTypeID.Name
			from [CORE].RateSpreadSchedule rs
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
			left join core.Account acc on acc.AccountID = e.AccountID
			left join cre.note n on n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
			where e.StatusID = 1
			and LValueTypeID.name in('Coupon Cap','Index Cap')
			and acc.IsDeleted <> 1
			and rs.Date = n.ClosingDate
			and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		)t
		PIVOT(SUM(Value) FOR Name in ([Coupon Cap],[Index Cap])) as tab
	END
	
	IF(@Intent ='NoteInitialFundingAtClosing')
	BEGIN
		SELECT n.CreNoteID as Note,n.InitialFundingAmount
		from cre.note n 
		left join core.account acc on acc.AccountID = n.Account_AccountID
		where n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		and acc.IsDeleted<>1
		and n.InitialFundingAmount>1
	END

	IF(@Intent ='NoteNextPrepayment')
	BEGIN
		SELECT top 1 n.CRENoteID as Note, convert(varchar,fs.Date,101) as Date,SUM(ISNULL(fs.Value,0)) as Amount
		from core.FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN 
			(
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted <>1
		and n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue
		and acc.IsDeleted<>1
		and fs.Value<0
		and fs.Date >= getdate()
		group by n.CRENoteID, fs.Date
		order by fs.Date asc
	END
--END

--IF(@ObjectType = 'Client')
--BEGIN
	IF(@Intent ='ClientSubDebtBalance')
	BEGIN
		IF OBJECT_ID('tempdb..[#tempSubClientTable]') IS NOT NULL                                         
		DROP TABLE #tempSubClientTable 

		CREATE Table #tempSubClientTable(NoteId uniqueidentifier)
		INSERT INTO #tempSubClientTable (NoteId)
		SELECT DISTINCT n.NoteId
		from cre.note n
		inner join core.Account acc on acc.AccountID = n.Account_AccountID
		inner join cre.client c on c.ClientID = n.ClientID
		where c.ClientName = @ObjectValue --'Delphi Fixed' --'Delphi Fixed' --'Acore Credit IV' --
		and acc.IsDeleted<>1
		and n.lienposition <> 353
		and n.priority <> 1

		---------------------------------------
		IF OBJECT_ID('tempdb..[#tempSubNPC]') IS NOT NULL                                         
		 DROP TABLE #tempSubNPC

		CREATE Table #tempSubNPC(NoteId uniqueidentifier,EndingBalance decimal(28,15),FirstCount int)

		INSERT INTO #tempSubNPC (NoteId,EndingBalance,FirstCount)

		SELECT DISTINCT npc.NoteId, EndingBalance,
		ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as FirstCount
		FROM cre.NotePeriodicCalc npc
		Inner Join cre.note n on n.Account_AccountID = npc.AccountID
		inner join #tempSubClientTable a on a.NoteID = n.NoteID 
		where npc.AnalysisID = @Analysisid
		and cast(PeriodEndDate as date) <= @todaydate
		and npc.[Month] is not null

		--=========================================
		SELECT Client,[SubDebtBalance],NoteCount
		FROM(
			SELECT @ObjectValue as Client,SUM(EndingBalance) as [SubDebtBalance], SUM(FirstCount) as NoteCount 
			From #tempSubNPC c
			WHERE c.FirstCount =1

		)a WHERE a.[SubDebtBalance] is not null

	--SELECT Client,[SubDebtBalance],NoteCount
	--	FROM(
	--		SELECT @ObjectValue as Client,SUM(EndingBalance) as [SubDebtBalance], SUM(FirstCount) as NoteCount FROM
	--		(
	--		SELECT DISTINCT npc.NoteId, EndingBalance 
	--		,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as FirstCount
	--		FROM cre.NotePeriodicCalc npc
	--		inner join 
	--				(
	--					SELECT  n.NoteId
	--					from cre.note n 
	--					inner join core.Account acc on acc.AccountID = n.Account_AccountID
	--					inner join cre.client c on c.ClientID = n.ClientID
	--					where c.ClientName = @ObjectValue   
	--					and acc.IsDeleted<>1
	--					and n.lienposition <> 353
	--					and n.priority <> 1
	--					--group by  n.NoteId,c.ClientName
	--				)a on a.NoteID = npc.NoteID
	--	where npc.AnalysisID = @Analysisid   --'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	--	and cast(PeriodEndDate as date) <= @todaydate
	--	and npc.[Month] is not null
	--	GROUP BY npc.NoteID, EndingBalance, PeriodEndDate
	--	) c
	--	WHERE c.FirstCount =1
	--	)a WHERE a.[SubDebtBalance] is not null

		--SELECT Client,[SubDebtBalance],NoteCount
		--FROM(
		--	SELECT @ObjectValue as Client,SUM(EndingBalance) as [SubDebtBalance], SUM(FirstCount) as NoteCount FROM
		--	(
		--	SELECT DISTINCT NoteId, EndingBalance 
		--	,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as FirstCount
		--	FROM cre.NotePeriodicCalc npc
		--	WHERE NoteID in 
		--	(
		--		SELECT  n.NoteId
		--		from cre.note n 
		--		inner join core.Account acc on acc.AccountID = n.Account_AccountID
		--		left join cre.client c on c.ClientID = n.ClientID
		--		where c.ClientName = @ObjectValue   --IIF(@ObjectNature ='name',c.ClientName,CAST(c.ClientID as nvarchar(256))) =  @ObjectValue
		--		and acc.IsDeleted<>1
		--		and c.ClientName not in ('All','None')
		--		and n.lienposition <> 353
		--		and n.priority <> 1
		--		group by  n.NoteId,c.ClientName
		
		--	)
		--and npc.AnalysisID = @Analysisid
		--and cast(PeriodEndDate as date) <= cast(getdate() as date)
		--and npc.[Month] is not null
		--GROUP BY NoteID, EndingBalance, PeriodEndDate
		--) c
		--WHERE c.FirstCount =1
		--)a WHERE a.[SubDebtBalance] is not null

		--CREATE Table #tempSubClientTable(NoteId uniqueidentifier,Client nvarchar(256), NoteCount int)
		--INSERT INTO #tempSubClientTable (NoteId,Client,NoteCount)
		--SELECT  n.NoteId,c.ClientName as Client, 
		--		ROW_NUMBER() Over (Partition by count(n.noteid) Order by n.noteid) as NoteCount
		--									from cre.note n 
		--									inner join core.Account acc on acc.AccountID = n.Account_AccountID
		--									left join cre.client c on c.ClientID = n.ClientID
		--									where c.ClientName = @ObjectValue --IIF(@ObjectNature ='name',c.ClientName,CAST(c.ClientID as nvarchar(256))) =  @ObjectValue
		--									and acc.IsDeleted<>1
		--									and c.ClientName not in ('All','None')
		--									and n.lienposition <> 353
		--									and n.priority <> 1
		--									group by  n.NoteId,c.ClientName
		
	
		--SELECT b.Client,SUM(b.EndingBalance) as [SubDebtBalance],max(t.NoteCount) as NoteCount
		--FROM  #tempSubClientTable t
		--left join (
		--			SELECT t.NoteId,ISNULL(EndingBalance,0) as EndingBalance
		--			,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as rno
		--			,Client
		--			from cre.NotePeriodicCalc npc
		--			left join #tempSubClientTable t on t.NoteID = npc.NoteID
		--			WHERE npc.AnalysisID = @Analysisid
		--			and cast(PeriodEndDate as date) <= cast(getdate() as date)
		--			and npc.[Month] is not null
		--			and t.NoteID = npc.NoteID
		--			)b on b.NoteId = t.NoteId and b.rno=1
	 --  group by b.Client
			
	 --  DROP TABLE #tempSubClientTable;
	END

	IF(@Intent ='ClientTotalBalance')
	BEGIN
		IF OBJECT_ID('tempdb..[#tempClientTable]') IS NOT NULL                                         
		DROP TABLE #tempClientTable 

		CREATE Table #tempClientTable(NoteId uniqueidentifier)
		INSERT INTO #tempClientTable (NoteId)
		SELECT DISTINCT n.NoteId
		from cre.note n
		inner join core.Account acc on acc.AccountID = n.Account_AccountID
		inner join cre.client c on c.ClientID = n.ClientID
		where c.ClientName = @ObjectValue  --'Delphi Financial' --'Delphi Fixed' --'Delphi Fixed' --'Acore Credit IV' --
		and acc.IsDeleted<>1

		---------------------------------------
		IF OBJECT_ID('tempdb..[#tempNPC]') IS NOT NULL                                         
		 DROP TABLE #tempNPC

		CREATE Table #tempNPC(NoteId uniqueidentifier,EndingBalance decimal(28,15),FirstCount int)

		INSERT INTO #tempNPC (NoteId,EndingBalance,FirstCount)

		SELECT DISTINCT npc.NoteId, EndingBalance,
		ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as FirstCount
		FROM cre.NotePeriodicCalc npc
		Inner Join cre.note n on n.account_AccountID = npc.AccountID
		inner join #tempClientTable a on a.NoteID = n.NoteID 
		where npc.AnalysisID = @Analysisid
		and cast(PeriodEndDate as date) <= @todaydate
		and npc.[Month] is not null

		--=========================================
		SELECT Client,Balance,NoteCount
		FROM(
			SELECT @ObjectValue as Client,SUM(EndingBalance) as [Balance], SUM(FirstCount) as NoteCount 
			From #tempNPC c
			WHERE c.FirstCount =1

		)a WHERE a.Balance is not null

		--SELECT Client,Balance,NoteCount
		--FROM(
		--	SELECT @ObjectValue as Client,SUM(EndingBalance) as [Balance], SUM(FirstCount) as NoteCount FROM
		--	(
		--		SELECT DISTINCT npc.NoteId, EndingBalance 
		--		,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as FirstCount
		--		FROM cre.NotePeriodicCalc npc
		--		inner join 
		--				 (
		--					SELECT DISTINCT n.NoteId 
		--					from cre.note n 
		--					inner join core.Account acc on acc.AccountID = n.Account_AccountID
		--					inner join cre.client c on c.ClientID = n.ClientID
		--					where c.ClientName = @ObjectValue   --'Delphi Fixed' --'Delphi Fixed' --'Acore Credit IV' --
		--					and acc.IsDeleted<>1
		--				)a on a.NoteID = npc.NoteID
		--	WHERE npc.AnalysisID = @Analysisid
		--	and cast(PeriodEndDate as date) <= @todaydate
		--	and npc.[Month] is not null
		--	GROUP BY npc.NoteID, EndingBalance, PeriodEndDate
		--) c
		--WHERE c.FirstCount =1
		--)a WHERE a.Balance is not null

		--SELECT Client,Balance,NoteCount
		--FROM(
		--	SELECT @ObjectValue as Client,SUM(EndingBalance) as [Balance], SUM(FirstCount) as NoteCount FROM
		--	(
		--		SELECT DISTINCT NoteId, EndingBalance 
		--		,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as FirstCount
		--		FROM cre.NotePeriodicCalc npc
		--		WHERE NoteID in 
		--		(
		--			SELECT DISTINCT n.NoteId 
		--			from cre.note n 
		--			inner join core.Account acc on acc.AccountID = n.Account_AccountID
		--			left join cre.client c on c.ClientID = n.ClientID
		--			where c.ClientName =  @ObjectValue   --'Delphi Fixed' --'Delphi Fixed' --'Acore Credit IV' --
		--			and acc.IsDeleted<>1
		--			and c.ClientID not in (3,6)
		--			group by  n.NoteId,c.ClientName
		
		--		)
		--	and npc.AnalysisID = @Analysisid
		--	and cast(PeriodEndDate as date) <= cast(getdate() as date)
		--	and npc.[Month] is not null
		--	GROUP BY NoteID, EndingBalance, PeriodEndDate
		--) c
		--WHERE c.FirstCount =1
		--)a WHERE a.Balance is not null
		
		--CREATE Table #tempClientTable(NoteId uniqueidentifier,Client nvarchar(256), NoteCount int)
		--INSERT INTO #tempClientTable (NoteId,Client,NoteCount)
		--SELECT  n.NoteId,c.ClientName as Client, 
		--		ROW_NUMBER() Over (Partition by count(n.noteid) Order by n.noteid) as NoteCount
		--									from cre.note n 
		--									inner join core.Account acc on acc.AccountID = n.Account_AccountID
		--									left join cre.client c on c.ClientID = n.ClientID
		--									where c.ClientName = @ObjectValue --IIF(@ObjectNature ='name',c.ClientName,CAST(c.ClientID as nvarchar(256))) =  @ObjectValue
		--									and acc.IsDeleted<>1
		--									and c.ClientName not in ('All','None')
		--									group by  n.NoteId,c.ClientName
		
	
		--SELECT b.Client,SUM(b.EndingBalance) as [Balance],max(t.NoteCount) as NoteCount
		--FROM  #tempClientTable t
		--left join (
		--			SELECT t.NoteId,ISNULL(EndingBalance,0) as EndingBalance
		--			,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as rno
		--			,Client
		--			from cre.NotePeriodicCalc npc
		--			left join #tempClientTable t on t.NoteID = npc.NoteID
		--			WHERE npc.AnalysisID = @Analysisid
		--			and cast(PeriodEndDate as date) <= cast(getdate() as date)
		--			and npc.[Month] is not null
		--			and t.NoteID = npc.NoteID
		--			)b on b.NoteId = t.NoteId and b.rno=1
	 --  group by b.Client
			
	 --  DROP TABLE #tempClientTable;
	END

	IF(@Intent ='DealsWithMultipleClients')
	BEGIN
		CREATE Table #tempMultipleClients(DealID uniqueidentifier)
		INSERT INTO #tempMultipleClients(DealID)
		select dealid from(
				SELECT n.dealid, count(n.ClientID) as cnt
				,ROW_NUMBER() OVER(Partition by DealID ORDER BY DealID) AS rowno
				from cre.note n 
				inner join core.Account acc on acc.AccountID = n.Account_AccountID
				where acc.IsDeleted<>1
				and n.ClientID not in (3,6)
				group by n.ClientID,n.dealid
				) a where a.rowno >1


		 SELECT DealName,c.ClientName,SUM(n.TotalCommitment) as TotalCommitment
		 FROM CRE.Deal d
		 inner join #tempMultipleClients t on t.DealID = d.DealID
		 left join cre.note n on n.DealID = t.DealID
		 left join cre.client c on c.ClientID=n.ClientID
		 where  c.ClientName is not null
		 and c.ClientName not in ('All','None')
		 group by DealName,c.ClientName
		 order by DealName

		Drop Table #tempMultipleClients;
	END
	
--END

-- INSERT INTO [HBOT].[APIAnalysisLog](StartTime,EndTime,IntentName) VALUES(@StartTime,getdate(),@Intent)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
