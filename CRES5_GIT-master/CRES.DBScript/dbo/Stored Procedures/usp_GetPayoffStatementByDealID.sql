
--		[dbo].[usp_GetPayoffStatementByDealID] '5dd8e0a2-a2a1-424b-8653-5e97ab046b50','06/06/2025'


CREATE PROCEDURE [dbo].[usp_GetPayoffStatementByDealID]
	@DealID nvarchar(255),
	@PayoffDate Date = NULL,
	@ActualPayoffDate Date = NULL

AS
BEGIN

	SET NOCOUNT ON;
	Declare @PaymentDate Date;

	IF @PayoffDate IS NULL
	BEGIN 
		Set @PayoffDate = GetDate();
	END
	
	SET @PaymentDate = (
			Select Top 1 tr.[Date] From cre.TransactionEntry  tr
			inner join cre.note n on n.account_accountid=tr.accountid 
			Where tr.[Date]>=@PayoffDate
			and n.DealID = @DealID
			ORDER BY [Date] ASC)

	
	IF @PaymentDate IS NULL
	BEGIN 
		Set @PaymentDate = @PayoffDate;
	END

	Declare @AnalysisID UNIQUEIDENTIFIER;
	SET @AnalysisID = (Select AnalysisID from core.Analysis where [Name] = 'Prepayment Default')

	--Master
	select TOP 1 crenoteid as SeniorNote, D.DealName, @PayoffDate as PayoffDate, NServ.Servicer, NBorrowName.BorrowerName,NBorrowAddress.BorrowerAddress, S.ServicerName, CL.ClientName as InvestorName, CAST(n.ServicerID as Decimal(28,0)) as ServicerID
	from cre.note n 
	Inner join cre.deal d on d.dealid = n.dealid
	Inner join core.account acc on acc.accountid = n.account_accountid
	LEFT JOIN CORE.LOOKUP LDebt ON LDebt.LookupID = n.DebtTypeID
	LEFT JOIN CRE.Servicer S ON S.ServicerID = n.ServicerNameID
	LEFT JOIN  [CRE].[Client] Cl ON CL.CLientID = n.CLientID
	OUTER APPLY (
		Select STRING_AGG(CAST(ServicerID as Decimal(28,0)), ', ') as Servicer from Cre.Note NSer 
		INNER JOIN CRE.Deal DSer ON DSer.DealID = NSer.DealID AND DSer.DealID = D.DealID
	) as NServ
	OUTER APPLY (
		SELECT STRING_AGG(Res.PrimaryBorrowerName, '|') as BorrowerName
		FROM (
		Select distinct Top 2 PrimaryBorrowerName 
		from (
				SELECT CONCAT(CASE WHEN isnull(B.FirstName, '') <> '' THEN CONCAT(B.FirstName, '- ') ELSE '' END, B.LastNameOrOrgName) as PrimaryBorrowerName    
				,row_number() over (partition by noteid_f order by BOH.OwnershipPct DESC, BorrowerOwnershipHierarchyId ASC) as sno
				FROM Cre.Note N1
				INNER JOIN tblborrowerownershiphierarchy BOH ON  CAST(BOH.NoteId_F as NVARCHAR(255))= N1.CRENoteID
				INNER JOIN tblborrower B ON B.BorrowerId = BOH.ParentBorrowerId_F
				WHERE BOH.ChildBorrowerId_F IS NULL
				and N1.DealID = D.DealID
			) Borrower WHERE Sno=1
		) Res
	) NBorrowName
	OUTER APPLY (
		SELECT STRING_AGG(Res.StreetName, '|') as BorrowerAddress
		FROM (
		Select distinct Top 2 StreetName 
		from (
				SELECT StreetName    
				,row_number() over (partition by noteid_f order by BOH.OwnershipPct DESC, BorrowerOwnershipHierarchyId ASC) as sno
				FROM Cre.Note N1
				INNER JOIN tblborrowerownershiphierarchy BOH ON  CAST(BOH.NoteId_F as NVARCHAR(255))= N1.CRENoteID
				INNER JOIN tblborrower B ON B.BorrowerId = BOH.ParentBorrowerId_F
				WHERE BOH.ChildBorrowerId_F IS NULL
				and N1.DealID = D.DealID
			) Borrower WHERE Sno=1
		) Res
	) NBorrowAddress
	WHERE acc.isdeleted <> 1
	AND lDebt.[Name] = 'Senior'
	and d.dealid = @DealID
	--AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
	ORDER BY CRENoteID

	--Principal Paydown
	select concat(acc.[Name] ,' (', CAST(n.ServicerID as Decimal(28,0)),')') as Name,NULL,NULL,NULL,NULL,NULL, di.EndingBalance as Amount
	from [CRE].[DailyInterestAccruals] di
	Inner join cre.note n on n.noteid = di.noteid
	Inner join core.account acc on acc.accountid = n.account_accountid
	Inner join cre.deal d on d.dealid = n.dealid
	where di.AnalysisID= @AnalysisID
	and acc.isdeleted <> 1
	and d.dealid = @DealID
	and date=DATEADD(D,-1,@PaymentDate)
	AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
	Order by n.crenoteid,di.date,di.EndingBalance;

	/*
	IF (@ActualPayoffDate IS NULL)
	BEGIN
		--Accrued Interest
		Select [Name],NULL,InterestRate,[From],Through,NULL,Amount From (
	
			Select concat(acc.[Name] ,' (', CAST(n.ServicerID as Decimal(28,0)),')') as Name,
			tr.Type,
			CAST(FORMAT(tr.AllInCouponRate*100,'0.000000') as nVarchar(255))+'%'  as InterestRate,
			FORMAT(DATEADD(D,1,t2.[Date]) , 'MM/dd/yyyy')  AS 'From' ,
			FORMAT(tr.[Date] , 'MM/dd/yyyy') AS 'Through',
			tr.Amount,tr.date,n.CRENoteID,
		
			ROW_NUMBER() OVER(PARTITION BY tr.accountID ORDER BY tr.Date desc) as Sno
			from cre.TransactionEntry tr
			inner join cre.note n on n.account_accountid=tr.accountid 
			Inner join core.account acc on acc.accountid = n.account_accountid
			inner join cre.deal d on d.dealid = n.dealid
			OUTER APPLY (
				SELECT TOP 1 t2.Date
				FROM cre.TransactionEntry t2
				WHERE t2.Date < tr.Date 
					and t2.Type=tr.Type
					AND t2.AccountId = tr.AccountId
					and t2.AnalysisID = tr.AnalysisID
				ORDER BY t2.Date DESC
			) t2
			where tr.AnalysisID =@AnalysisID
			and [type] in ('InterestPaid')
			and d.dealid = @DealID
			and tr.Date <= @PaymentDate

			UNION ALL
			
			Select NULL,NULL,'Interest Rate','From','Through',NULL,NULL,NULL,1
		) Res Where Sno=1
		Order By CRENoteID;
 
		--Accrued Interest Forward
		Select [Name],NULL,InterestRate,[From],Through,NULL,Amount From (
	
			Select concat(acc.[Name] ,' (', CAST(n.ServicerID as Decimal(28,0)),')') as Name,
			sum(di.dailyinterestaccrual) as Amount,
			CAST(FORMAT(AVG(di.AllInCouponRate)*100,'0.000000') as nVarchar(255))+'%'  as InterestRate,
			FORMAT(DATEADD(D,1,res.[Date]) , 'MM/dd/yyyy')  AS 'From' ,
			FORMAT(@PaymentDate , 'MM/dd/yyyy') AS 'Through',n.CRENoteID
			from [CRE].[DailyInterestAccruals] di
			Inner join cre.note n on n.noteid = di.noteid
			Inner join core.account acc on acc.accountid = n.account_accountid
			Inner join cre.deal d on d.dealid = n.dealid
			OUTER APPLY (
				Select CRENoteID,[Date] From (	
					Select tr.date,n.CRENoteID,
					ROW_NUMBER() OVER(PARTITION BY tr.accountID ORDER BY tr.Date desc) as Sno
					from cre.TransactionEntry tr
					inner join cre.note ni on ni.account_accountid=tr.accountid 
					Inner join core.account acc on acc.accountid = ni.account_accountid
					inner join cre.deal d on d.dealid = ni.dealid
					where tr.AnalysisID =@AnalysisID
					and [type] in ('InterestPaid')
					and ni.NoteID = n.NoteID
					and tr.Date <= @PaymentDate
				) Ret Where Sno=1
			) Res
			where di.AnalysisID= @AnalysisID
			and acc.isdeleted <> 1
			and d.dealid = @DealID
			and di.date<=@PaymentDate 
			and di.Date>res.Date
			GROUP BY di.NoteID,acc.[Name] ,n.ServicerID,res.[date],n.CRENoteID

			UNION ALL
			
			Select NULL,NULL,'Interest Rate','From','Through',NULL
		) final
		Order by CRENoteID
	END
ELSE
	BEGIN
	*/
	
	--Accrued Interest Previous
	
	IF NOT EXISTS (
		Select acc.[Name]
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		Inner join core.account acc on acc.accountid = n.account_accountid
		inner join cre.deal d on d.dealid = n.dealid
		where tr.AnalysisID =@AnalysisID
		and [type] in ('InterestPaid')
		and d.dealid = @DealID
		and tr.Date = @PayoffDate
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
	)
	BEGIN
		Select [Name],NULL,InterestRate,[From],Through,NULL,Amount From (
	
			Select concat(acc.[Name] ,' (', CAST(n.ServicerID as Decimal(28,0)),')') as Name,
			tr.Type,
			CAST(FORMAT(tr.AllInCouponRate*100,'0.000000') as nVarchar(255))+'%'  as InterestRate,
			FORMAT(t2.[Date] , 'MM/dd/yyyy')  AS 'From' ,
			--FORMAT(DATEADD(D,-1,tr.[Date]) , 'MM/dd/yyyy') AS 'Through',
			CASE When tr.[Date] IS NOT NULL THEN 
				FORMAT(CAST(CONCAT(Month(tr.[Date]),'/',Day(n.InitialInterestAccrualEndDate),'/',Year(tr.[date])) AS DATE), 'MM/dd/yyyy')
			ELSE
				NULL
			END AS 'Through',
			tr.Amount,tr.date,n.CRENoteID,
		
			ROW_NUMBER() OVER(PARTITION BY tr.accountID ORDER BY tr.Date desc) as Sno
			from cre.TransactionEntry tr
			inner join cre.note n on n.account_accountid=tr.accountid 
			Inner join core.account acc on acc.accountid = n.account_accountid
			inner join cre.deal d on d.dealid = n.dealid
			OUTER APPLY (
				SELECT TOP 1 t2.Date
				FROM cre.TransactionEntry t2
				WHERE t2.Date < tr.Date 
					and t2.Type=tr.Type
					AND t2.AccountId = tr.AccountId
					and t2.AnalysisID = tr.AnalysisID
				ORDER BY t2.Date DESC
			) t2
			where tr.AnalysisID =@AnalysisID
			and [type] in ('InterestPaid')
			and d.dealid = @DealID
			and tr.Date <= @PayoffDate
			AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)

			UNION ALL
		
			Select NULL,NULL,'Interest Rate','From','Through',NULL,NULL,NULL,1
		) Res Where Sno=1
		Order By CRENoteID;
	END
	ELSE
	BEGIN
		Select NULL,NULL,NULL,NULL,NULL,NULL,NULL AS Amount
	END

	--Accrued Interest
	IF @ActualPayoffDate IS NOT NULL-- AND @ActualPayoffDate = @PayoffDate
	BEGIN
		Select [Name],NULL,InterestRate,[From],Through,NULL,Amount From (
			Select concat(acc.[Name] ,' (', CAST(n.ServicerID as Decimal(28,0)),')') as Name,
			tr.Type,
			CAST(FORMAT(tr.AllInCouponRate*100,'0.000000') as nVarchar(255))+'%'  as InterestRate,
			--FORMAT(t2.[Date] , 'MM/dd/yyyy')  AS 'From' ,
			CASE When t2.[Date] IS NOT NULL THEN 
				FORMAT(CAST(CONCAT(Month(t2.[Date]),'/',(Day(n.InitialInterestAccrualEndDate)+1),'/',Year(t2.[date])) AS DATE), 'MM/dd/yyyy')
			ELSE
				NULL
			END AS 'From' ,
			--FORMAT(DATEADD(D,-1,tr.[Date]) , 'MM/dd/yyyy') AS 'Through',
			CASE WHEN @ActualPayoffDate = @PayoffDate 
			OR @ActualPayoffDate < CAST(CONCAT(Month(tr.[Date]),'/',Day(n.InitialInterestAccrualEndDate),'/',Year(tr.[date])) AS DATE) 
			OR CAST(CONCAT(Month(tr.[Date]),'/',Day(n.InitialInterestAccrualEndDate),'/',Year(tr.[date])) AS DATE) <= t2.[Date] THEN
				FORMAT(@ActualPayoffDate, 'MM/dd/yyyy')
			ELSE	--WHEN @PayoffDate <> @ActualPayoffDate AND CAST(CONCAT(Month(tr.[Date]),'/',Day(n.InitialInterestAccrualEndDate),'/',Year(tr.[date])) AS DATE)>t2.[Date] THEN 
				FORMAT(CAST(CONCAT(Month(tr.[Date]),'/',Day(n.InitialInterestAccrualEndDate),'/',Year(tr.[date])) AS DATE), 'MM/dd/yyyy')
			END AS 'Through',
			tr.Amount,tr.date,n.CRENoteID,
		
			ROW_NUMBER() OVER(PARTITION BY tr.accountID ORDER BY tr.Date asc) as Sno
			from cre.TransactionEntry tr
			inner join cre.note n on n.account_accountid=tr.accountid 
			Inner join core.account acc on acc.accountid = n.account_accountid
			inner join cre.deal d on d.dealid = n.dealid
			OUTER APPLY (
				SELECT TOP 1 t2.Date
				FROM cre.TransactionEntry t2
				WHERE t2.Date < tr.Date 
					and t2.Type=tr.Type
					AND t2.AccountId = tr.AccountId
					and t2.AnalysisID = tr.AnalysisID
				ORDER BY t2.Date DESC
			) t2
			where tr.AnalysisID =@AnalysisID
			and [type] in ('InterestPaid')
			and d.dealid = @DealID
			and tr.Date >= @PayoffDate
			AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)

			UNION ALL
			
			Select NULL,NULL,'Interest Rate','From','Through',NULL,NULL,NULL,1
		) Res Where Sno=1
		Order By CRENoteID;
	END
	ELSE
	BEGIN
		Select [Name],NULL,InterestRate,[From],Through,NULL,Amount From (
			Select [Name],InterestRate,[From],IIF(CAST([From] as Date) > CAST([Through] As Date),Format([Date], 'MM/dd/yyyy'),[Through]) as 'Through' ,Amount,crenoteid,Sno from (
			Select concat(acc.[Name] ,' (', CAST(n.ServicerID as Decimal(28,0)),')') as Name,
			tr.Type,
			CAST(FORMAT(tr.AllInCouponRate*100,'0.000000') as nVarchar(255))+'%'  as InterestRate,
			--FORMAT(t2.[Date] , 'MM/dd/yyyy')  AS 'From' ,
			CASE When t2.[Date] IS NOT NULL THEN 
				FORMAT(CAST(CONCAT(Month(t2.[Date]),'/',(Day(n.InitialInterestAccrualEndDate)+1),'/',Year(t2.[date])) AS DATE), 'MM/dd/yyyy')
			ELSE
				NULL
			END AS 'From' ,
			--FORMAT(DATEADD(D,-1,tr.[Date]) , 'MM/dd/yyyy') AS 'Through',
			CASE When tr.[Date] IS NOT NULL THEN 
				FORMAT(CAST(CONCAT(Month(tr.[Date]),'/',Day(n.InitialInterestAccrualEndDate),'/',Year(tr.[date])) AS DATE), 'MM/dd/yyyy')
			ELSE
				NULL
			END AS 'Through',
			tr.Amount,tr.date,n.CRENoteID,
		
			ROW_NUMBER() OVER(PARTITION BY tr.accountID ORDER BY tr.Date asc) as Sno
			from cre.TransactionEntry tr
			inner join cre.note n on n.account_accountid=tr.accountid 
			Inner join core.account acc on acc.accountid = n.account_accountid
			inner join cre.deal d on d.dealid = n.dealid
			OUTER APPLY (
				SELECT TOP 1 t2.Date
				FROM cre.TransactionEntry t2
				WHERE t2.Date < tr.Date 
					and t2.Type=tr.Type
					AND t2.AccountId = tr.AccountId
					and t2.AnalysisID = tr.AnalysisID
				ORDER BY t2.Date DESC
			) t2
			where tr.AnalysisID =@AnalysisID
			and [type] in ('InterestPaid')
			and d.dealid = @DealID
			and tr.Date >= @PayoffDate
			AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
			) FinalRes

			UNION ALL
			
			Select NULL,'Interest Rate','From','Through',NULL,NULL,1
		) Res Where Sno=1
		Order By CRENoteID;
	END
	--END

	--Exit Fee
	IF EXISTS(
		Select n.DealID , Sum(tr.Amount) as Amount
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		where tr.AnalysisID =@AnalysisID
		and n.dealid = @DealID
		and tr.Date >= @PayoffDate
		and Type='ExitFeeExcludedFromLevelYield'
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
		group by n.DealID
	)
	BEGIN
		Select NULL,NULL,NULL,'Percentage','BASED On',NULL,NULL as  Amount 
		UNION ALL
		Select NULL,NULL,NULL,Perc, 'Current Commitment',NULL,Resa.Amount From(
			Select DealID,CAST(FORMAT(Avg(Value)*100,'0.00') as nVarchar(255))+'%' Perc
			From (
				Select 
				d.DealID
				,isnull(pafs.Value,0) as Value
				,ROW_NUMBER() OVER (Partition By acc.AccountID ORDER By eve.EffectiveStartDate Desc) as Sno
				from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				INNER JOIN [CRE].[Deal] D on D.DealID = n.DealID
				LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
				where d.dealid = @DealID  and acc.IsDeleted = 0 and eve.StatusID = 1 AND LValueTypeID.FeeTypeNameText = 'Exit Fee'
				AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
			)Res Where Sno=1
			Group By DealID
		)OutRes
		INNER JOIN (
		Select n.DealID , Sum(tr.Amount) as Amount
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		where tr.AnalysisID =@AnalysisID
		and n.dealid = @DealID
		and tr.Date >= @PayoffDate
		and Type='ExitFeeExcludedFromLevelYield'
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
		group by n.DealID
		) as Resa ON OutRes.DealID = Resa.DealID
	END
	ELSE
	BEGIN
		Select NULL,NULL,NULL,'Percentage','BASED On',NULL,NULL as  Amount 
		UNION ALL
		Select NULL,NULL,NULL,NULL, 'Current Commitment',NULL,0 Amount
	END;

	--Unused Fee
	IF EXISTS(
		Select n.DealID , Sum(tr.Amount) as Amount
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		where tr.AnalysisID =@AnalysisID
		and n.dealid = @DealID
		and tr.Date >= @PayoffDate
		and Type='UnusedFeeExcludedFromLevelYield'
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
		group by n.DealID
	)
	BEGIN
		Select NULL,NULL,NULL,NULL,NULL,NULL,Sum(tr.Amount) as Amount
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		where tr.AnalysisID =@AnalysisID
		and n.dealid = @DealID
		and tr.Date >= @PayoffDate
		and Type='UnusedFeeExcludedFromLevelYield'
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
		group by n.DealID
	END
	ELSE
	BEGIN
		Select NULL,NULL,NULL,NULL,NULL,NULL,0 Amount
	END;

	--Origination Fee
	IF EXISTS(
		Select n.DealID , Sum(tr.Amount) as Amount
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		where tr.AnalysisID =@AnalysisID
		and n.dealid = @DealID
		and tr.Date >= @PayoffDate
		and Type='OriginationFeeExcludedFromLevelYield'
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
		group by n.DealID
	)
	BEGIN
		Select NULL,NULL,NULL,NULL,NULL,NULL,Sum(tr.Amount) as Amount
		from cre.TransactionEntry tr
		inner join cre.note n on n.account_accountid=tr.accountid 
		where tr.AnalysisID =@AnalysisID
		and n.dealid = @DealID
		and tr.Date >= @PayoffDate
		and Type='OriginationFeeExcludedFromLevelYield'
		AND N.FinancingSourceID NOT IN (Select FinancingSourceMasterID from cre.FinancingSourceMaster where isthirdparty = 1)
		group by n.DealID
	END
	ELSE
	BEGIN
		Select NULL,NULL,NULL,NULL,NULL,NULL,0 Amount
	END;

	--Prepayment Premium
	IF EXISTS(
		select    PrepayAdjAmt as Amount   
		 from [Core].[PrepayAdjustment]  PA
		 INNER JOIN [CORE].prepaySchedule ps      ON PA.PrepayScheduleID = ps.prepayScheduleiD
		 INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID      
		 INNER JOIN       
		 (      
		  Select d.dealid,ed.eventtypeid,ed.StatusID,MAX(EffectiveDate) as EffectiveDate from core.EventDeal ed      
		  inner join cre.deal d on d.dealid = ed.dealid      
		  where d.IsDeleted <> 1 and ed.StatusID = 1      
		  and ed.eventtypeid = 737      
		  and d.dealid = @Dealid      
		  group by d.dealid,ed.StatusID,ed.eventtypeid      
		 ) sEvent ON sEvent.Dealid = e.Dealid and e.EffectiveDate = sEvent.EffectiveDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = sEvent.StatusID      
		 left JOin core.Lookup lPrepaymentMethod on lPrepaymentMethod.lookupid = ps.PrepaymentMethod      
		 left JOin core.Lookup lSpreadCalcMethod on lSpreadCalcMethod.lookupid = ps.SpreadCalcMethod      
		 left JOin core.Lookup lBaseAmount on lBaseAmount.lookupid = ps.BaseAmountType     
		 where e.StatusID = 1  and e.dealid = @Dealid and PA.[Date] = @PayoffDate
	)
	BEGIN
		Select NULL,NULL,NULL,NULL,'Type',NULL,NULL as  Amount 
		UNION ALL
		Select NULL,NULL,NULL,NULL,'Minimum Multiple (Min. Spread)',NULL,PrepayAdjAmt as Amount   
		from [Core].[PrepayAdjustment]  PA
		INNER JOIN [CORE].prepaySchedule ps      ON PA.PrepayScheduleID = ps.prepayScheduleiD
		INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID      
		INNER JOIN       
		(      
			Select d.dealid,ed.eventtypeid,ed.StatusID,MAX(EffectiveDate) as EffectiveDate from core.EventDeal ed      
			inner join cre.deal d on d.dealid = ed.dealid      
			where d.IsDeleted <> 1 and ed.StatusID = 1      
			and ed.eventtypeid = 737      
			and d.dealid = @Dealid      
			group by d.dealid,ed.StatusID,ed.eventtypeid      
		) sEvent ON sEvent.Dealid = e.Dealid and e.EffectiveDate = sEvent.EffectiveDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = sEvent.StatusID      
		left JOin core.Lookup lPrepaymentMethod on lPrepaymentMethod.lookupid = ps.PrepaymentMethod      
		left JOin core.Lookup lSpreadCalcMethod on lSpreadCalcMethod.lookupid = ps.SpreadCalcMethod      
		left JOin core.Lookup lBaseAmount on lBaseAmount.lookupid = ps.BaseAmountType     
		where e.StatusID = 1  and e.dealid = @Dealid and PA.[Date] = @PayoffDate
	END
	ELSE 
	BEGIN
		IF EXISTS(
			Select NULL,NULL,NULL,NULL,'Minimum Multiple (Min. Spread)',NULL,PrepayPremium_RemainingSpread From
			[CRE].[DealPrepayProjection]  Where DealID=@DealID and PrepayDate = @PayoffDate
		)
		BEGIN
			Select NULL,NULL,NULL,NULL,'Type',NULL,NULL as  Amount 
			UNION ALL
			Select NULL,NULL,NULL,NULL,'Minimum Multiple (Min. Spread)',NULL,PrepayPremium_RemainingSpread From
			[CRE].[DealPrepayProjection]  Where DealID=@DealID and PrepayDate = @PayoffDate;
		END 
		ELSE 
		BEGIN
			Select NULL,NULL,NULL,NULL,'Type',NULL,NULL as  Amount 
			UNION ALL
			Select NULL,NULL,NULL,NULL,'Minimum Multiple (Min. Spread)',NULL,0		
		END
	END

	--Miscellaneous Fees	
	IF EXISTS(
		select FeeName,NULL,NULL,NULL,NULL,NULL,[Value] As Amount 
		from [CRE].[PayoffStatementFees]  
		where dealid=@DealID
	)
	BEGIN
		select FeeName,NULL,NULL,NULL,NULL,NULL,[Value] As Amount 
		from [CRE].[PayoffStatementFees]  
		where dealid=@DealID
	end
	ELSE
	BEGIN
		select NULL,NULL,NULL,NULL,NULL,NULL,0 As Amount
	END

	--Netting of Escrows/Reserves	
	select RAM.ReserveAccountName,NULL,NULL,NULL,NULL,NULL,RA.EstimatedReserveBalance As Amount 
	from cre.ReserveAccount RA INNER JOIN cre.ReserveAccountMaster RAM ON RA.ReserveAccountMasterID = RAM.ReserveAccountMasterID
	where RA.dealid=@DealID AND ISNULL(RA.EstimatedReserveBalance, 0) !=0
	Order by RAM.ReserveAccountName
END