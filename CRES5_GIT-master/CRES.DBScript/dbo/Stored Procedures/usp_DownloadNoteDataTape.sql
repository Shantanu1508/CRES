
--[dbo].[usp_DownloadNoteDataTape] 0

CREATE PROCEDURE [dbo].[usp_DownloadNoteDataTape] 
  @withoutSpread int
AS
BEGIN
SET NOCOUNT ON;


BEGIN  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	 

Declare @PrepayAndAdditionalFeeSchedule int = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')
Declare @RateSpreadSchedule int = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
Declare @StrippingSchedule int = (Select LookupID from CORE.[Lookup] where Name = 'StrippingSchedule')
Declare @Maturity int = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')

--Latest Maturity account wise
	Declare @MatutblMaxEffDateForEvent TABLE  (
	AccountID	UNIQUEIDENTIFIER,
	EffectiveStartDate	Date,
	[Date] Date,
	EventTypeID int

	)
	Insert into @MatutblMaxEffDateForEvent
	Select acc.AccountID,e.EffectiveStartDate,mat.MaturityDate,e.eventtypeID
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	INNER JOIN   
	(          
		Select   
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		where EventTypeID = 11  
		and acc.IsDeleted = 0  
		--and n.noteid = @NoteId
		and eve.StatusID = 1
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	where mat.MaturityType = 708 and mat.Approved = 3
	and e.StatusID = 1


	--Select e.AccountID,e.EffectiveStartDate,mat.SelectedMaturityDate,e.EventTypeID
	--from [CORE].Maturity mat
	--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--INNER JOIN 
	--			(
	--				Select 
	--					n.account_accountid as  AccountID ,
	--					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID , MAX(r.SelectedMaturityDate) [Date]
	--					from [CORE].[Event] eve
	--					INNER JOIN [CORE].Maturity r ON eve.EventID = r.EventId
	--					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	--					where EventTypeID = @Maturity and acc.IsDeleted=0
	--					GROUP BY n.Account_AccountID,EventTypeID

	--			) sEvent

	--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and mat.SelectedMaturityDate = sEvent.[Date]  
--==================================================================================


IF(@withoutSpread = 1)
BEGIN

	Select 
	D.CREDealId as [Deal ID],
	D.DealName as [Deal Name],
	N.CRENoteId as [Note ID],
	acc.Name as [Note Name],
	ISNULL(LEFT(CONVERT(VARCHAR, N.ActualPayoffDate, 101), 10) ,'') as ActualPayoffDate,
	--Settlement Tab
	ISNULL(LEFT(CONVERT(VARCHAR, n.ClosingDate, 101), 10) ,'') as [Closing Date],
	ISNULL(n.InitialFundingAmount,0) as [Initial Funding],
	ISNULL(n.Discount,0) as [Discount/ Premium],
	ISNULL(n.OriginationFee,0) as [Origination Fee],
	ISNULL(n.CapitalizedClosingCosts,0) as [Capitalized Costs],

	--Accounting Tab
	ISNULL(acc.PayFrequency,0) as [Pay Frequency],
	ISNULL(n.TotalCommitment,0) as [Total Commitment],
	ISNULL(LEFT(CONVERT(VARCHAR,(Select top 1  [Date] from @MatutblMaxEffDateForEvent where AccountID = acc.AccountID) , 101), 10) ,'') as [Initial Maturity],

	ISNULL(LEFT(CONVERT(VARCHAR, FullyExtendedMaturityDate, 101), 10) ,'') as [Fully Ext. Maturity],
	ISNULL(LEFT(CONVERT(VARCHAR, ExpectedMaturityDate, 101), 10) ,'') as [Expected Maturity],

	--ISNULL(LEFT(CONVERT(VARCHAR, ExtendedMaturityScenario1, 101), 10) ,'') as [Extended Maturity Scenario 1],
	--ISNULL(LEFT(CONVERT(VARCHAR, ExtendedMaturityScenario2, 101), 10) ,'') as [Extended Maturity Scenario 2],
	--ISNULL(LEFT(CONVERT(VARCHAR, ExtendedMaturityScenario3, 101), 10) ,'') as [Extended Maturity Scenario 3],

	ISNULL(LEFT(CONVERT(VARCHAR, tblExtendedMat.ExtendedMaturityScenario1, 101), 10) ,'') as [Extended Maturity Scenario 1],
	ISNULL(LEFT(CONVERT(VARCHAR, tblExtendedMat.ExtendedMaturityScenario2, 101), 10) ,'') as [Extended Maturity Scenario 2],
	ISNULL(LEFT(CONVERT(VARCHAR, tblExtendedMat.ExtendedMaturityScenario3, 101), 10) ,'') as [Extended Maturity Scenario 3],

	

	--Closing Tab
	ISNULL(LEFT(CONVERT(VARCHAR, InitialInterestAccrualEndDate, 101), 10) ,'') as [Initial Interest Acc. End Date],
	ISNULL(AccrualFrequency,0) as [Accrual Frequency],
	ISNULL(LEFT(CONVERT(VARCHAR, FirstPaymentDate, 101), 10) ,'') as [First Payment Date],
	ISNULL(LEFT(CONVERT(VARCHAR, InitialMonthEndPMTDateBiWeekly, 101), 10) ,'') as [Initial Month End Payment Date],
	ISNULL(PaymentDateBusinessDayLag,0) as [Payment Date Business Day Lag],
	ISNULL(DeterminationDateLeadDays,0) as [Determination Date Lead Days],
	ISNULL(IOTerm,0) as [IO Term],
	ISNULL(AmortTerm,0) as [Amort Term],
	ISNULL(MonthlyDSOverridewhenAmortizing,0) as [Monthly DS Override],
	ISNULL(LEFT(CONVERT(VARCHAR, FinalInterestAccrualEndDateOverride, 101), 10) ,'')  as [Final Interest Accrual End Date],
	ISNULL(DeterminationDateReferenceDayoftheMonth ,0) as [Determination Date Reference Day],
	ISNULL(RateIndexResetFreq,0) as [Rate Index Reset Freq Mths],
	ISNULL(LEFT(CONVERT(VARCHAR, FirstRateIndexResetDate, 101), 10) ,'')  as [First Rate Index Reset Date],
	ISNULL(lStubPaidinAdvanceYN.name,'')  as [Stub Paid In Advance], --Lookup
	ISNULL(lLoanPurchase.name,'') as [Loan Purchase],  --Lookup
	ISNULL(AmortIntCalcDayCount,0) as [Amort Int Calc Day Count],
	ISNULL(InitialIndexValueOverride,0) as [Intitial Index Value Override],
	ISNULL(lRoundingMethod.name,'')  as [Rounding Method], --Lookup
	ISNULL(IndexRoundingRule,0) as [Index Rounding Rule],
	ISNULL(StubIntOverride,0) as [Stub Interest Override],
	ISNULL(lIndex.name,'') as [Index Name]
	FROM CRE.DEAL d
	INNER JOIN CRE.NOTE n ON n.DEALID = d.DEALID
	INNER JOIN CORE.Account acc ON n.Account_Accountid = acc.Accountid
	left join Core.Lookup lStubPaidinAdvanceYN ON n.StubPaidinAdvanceYN=lStubPaidinAdvanceYN.LookupID 	
	left join Core.Lookup lLoanPurchase ON n.LoanPurchase=lLoanPurchase.LookupID
	left join Core.Lookup lRoundingMethod ON n.RoundingMethod=lRoundingMethod.LookupID
	left join Core.Lookup lIndex ON n.IndexNameID=lIndex.LookupID
	left join(
		Select noteid,ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10
		From(
			Select  n.noteid,
			'ExtendedMaturityScenario' + CAST(ROW_NUMBER() Over(Partition BY Noteid order by noteid,MaturityDate) as nvarchar(256))  as MaturityType
			,mat.MaturityDate			
			from [CORE].Maturity mat  
			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			INNER JOIN   
			(          
				Select   
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
				where EventTypeID = 11  
				and acc.IsDeleted = 0  		
				and eve.StatusID = 1		
				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
			where mat.MaturityType in (709) and e.StatusID = 1
			--and n.crenoteid = '2230'

		) AS SourceTable  
		PIVOT  
		(  
			MIN(MaturityDate)  
			FOR MaturityType IN (ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10)  
		) AS PivotTable

	)tblExtendedMat on tblExtendedMat.noteid = n.noteid
	WHERE ISNULL(acc.StatusID,1) = 1 and d.IsDeleted=0 and acc.IsDeleted=0
	ORDER BY d.creDealid,n.crenoteid

END
ELSE
BEGIN
		
		

		Declare @Main TABLE (
		[AccountId] UNIQUEIDENTIFIER,

		RSS_Date DATE,
		RSS_ValueTypeText nvarchar(MAX),
		RSS_Value decimal(28,12),
		RSS_IntCalcMethodText nvarchar(MAX),

		PAF_Date DATE,
		PAF_ValueTypeText nvarchar(MAX),
		PAF_Value decimal(28,12),
		PAF_IncludedLevelYield decimal(28,12),
		PAF_IncludedBasis decimal(28,12),

		SS_Date DATE,
		SS_ValueTypeText nvarchar(MAX),
		SS_Value decimal(28,12),
		SS_IncludedLevelYield decimal(28,12),
		SS_IncludedBasis decimal(28,12)
		)
		Insert into @Main
		------------------------
		Select 
		e.AccountID,
		rs.[Date] as RSS_Date,
		LValueTypeID.name as RSS_ValueTypeText,
		rs.value as RSS_Value ,
		LIntCalcMethodID.name as RSS_IntCalcMethodText ,
		null as PAF_Date ,
		null as PAF_ValueTypeText ,
		null as PAF_Value ,
		null as PAF_IncludedLevelYield ,
		null as PAF_IncludedBasis ,
		null as SS_Date ,
		null as SS_ValueTypeText ,
		null as SS_Value ,
		null as SS_IncludedLevelYield ,
		null as SS_IncludedBasis 
		from [CORE].RateSpreadSchedule rs
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
		LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
		INNER JOIN 
				(
					Select 
						n.account_accountid as  AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID , r.[Date] ,ValueTypeID
						from [CORE].[Event] eve
						INNER JOIN [CORE].RateSpreadSchedule r ON eve.EventID = r.EventId
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = @RateSpreadSchedule and eve.StatusID = 1 and acc.IsDeleted=0
						GROUP BY n.Account_AccountID,EventTypeID,ValueTypeID,r.[Date]

				) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and rs.[Date] = sEvent.[Date] and rs.ValueTypeID = sEvent.ValueTypeID


		---Prepay Cursor

		Declare @AccountID UNIQUEIDENTIFIER
		Declare @Date DATE
		Declare @ValueTypeText nvarchar(MAX)
		Declare @Value decimal(28,12)
		Declare @IncludedLevelYield decimal(28,12)
		Declare @IncludedBasis decimal(28,12)

		IF CURSOR_STATUS('global','CursorPrePay')>=-1
		BEGIN
		DEALLOCATE CursorPrePay
		END

		DECLARE CursorPrePay CURSOR 
		for
		(
		Select e.AccountID,rs.[StartDate],LValueTypeID.name as ValueTypeText,rs.[Value],rs.[IncludedLevelYield],rs.[IncludedBasis]
		from [CORE].PrepayAndAdditionalFeeSchedule rs
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
		INNER JOIN 
				(
					Select 
						n.account_accountid as  AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,r.[StartDate] [Date],ValueTypeID
						from [CORE].[Event] eve
						INNER JOIN [CORE].PrepayAndAdditionalFeeSchedule r ON eve.EventID = r.EventId
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = @PrepayAndAdditionalFeeSchedule and eve.StatusID = 1
						GROUP BY n.Account_AccountID,EventTypeID,ValueTypeID,r.[StartDate]

				) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and rs.[StartDate] = sEvent.[Date] and rs.ValueTypeID = sEvent.ValueTypeID
 
		)


		OPEN CursorPrePay 

		FETCH NEXT FROM CursorPrePay
		INTO @AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis

		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF EXISTS(Select * from @Main where AccountID = @AccountID and PAF_Date is null)
		BEGIN
			PRINT('Update');
			Update t
			SET t.PAF_Date = @Date,
			t.PAF_ValueTypeText = @ValueTypeText,
			t.PAF_Value =@Value,
			t.PAF_IncludedLevelYield =@IncludedLevelYield,
			t.PAF_IncludedBasis = @IncludedBasis
			FROM
			(Select TOP 1 * from @Main where AccountID = @AccountID and PAF_Date is null)t
		END
		ELSE
		BEGIN
			PRINT('INSERT');
			INSERT INTO @Main (AccountID,PAF_Date,PAF_ValueTypeText,PAF_Value,PAF_IncludedLevelYield,PAF_IncludedBasis)
			VALUES(@AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis)
		END
					 
		FETCH NEXT FROM CursorPrePay
		INTO @AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis
		END
		CLOSE CursorPrePay   
		DEALLOCATE CursorPrePay

		---Stripping Schedule Cursor

		IF CURSOR_STATUS('global','CursorStripSch')>=-1
		BEGIN
		DEALLOCATE CursorStripSch
		END

		DECLARE CursorStripSch CURSOR 
		for
		(
		Select e.AccountID,ss.[StartDate],LValueTypeID.name as ValueTypeText,ss.[Value],ss.[IncludedLevelYield],ss.[IncludedBasis]
		from [CORE].StrippingSchedule ss
		INNER JOIN [CORE].[Event] e on e.EventID = ss.EventId
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
		INNER JOIN 
				(
					Select 
						n.account_accountid as  AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID , r.[StartDate] [Date],ValueTypeID
						from [CORE].[Event] eve
						INNER JOIN [CORE].StrippingSchedule r ON eve.EventID = r.EventId
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = @StrippingSchedule and eve.StatusID = 1 and acc.IsDeleted=0
						GROUP BY n.Account_AccountID,EventTypeID,ValueTypeID,r.[StartDate]

				) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and ss.[StartDate] = sEvent.[Date]  and ss.ValueTypeID = sEvent.ValueTypeID
 
		)


		OPEN CursorStripSch 

		FETCH NEXT FROM CursorStripSch
		INTO @AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis

		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF EXISTS(Select * from @Main where AccountID = @AccountID and SS_Date is null)
		BEGIN
			PRINT('Update');
			Update t
			SET t.SS_Date = @Date,
			t.SS_ValueTypeText = @ValueTypeText,
			t.SS_Value =@Value,
			t.SS_IncludedLevelYield =@IncludedLevelYield,
			t.SS_IncludedBasis = @IncludedBasis
			FROM
			(Select TOP 1 * from @Main where AccountID = @AccountID and SS_Date is null)t
		END
		ELSE
		BEGIN
			PRINT('INSERT');
			INSERT INTO @Main (AccountID,SS_Date,SS_ValueTypeText,SS_Value,SS_IncludedLevelYield,SS_IncludedBasis)
			VALUES(@AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis)
		END
					 
		FETCH NEXT FROM CursorStripSch
		INTO @AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis
		END
		CLOSE CursorStripSch   
		DEALLOCATE CursorStripSch

		--==================================================================================
		Select 
	D.CREDealId as [Deal ID],
	D.DealName as [Deal Name],
	N.CRENoteId as [Note ID],
	acc.Name as [Note Name],
	ISNULL(LEFT(CONVERT(VARCHAR, N.ActualPayoffDate, 101), 10) ,'') as ActualPayoffDate,
	--Settlement Tab
	ISNULL(LEFT(CONVERT(VARCHAR, n.ClosingDate, 101), 10) ,'') as [Closing Date],
	ISNULL(n.InitialFundingAmount,0) as [Initial Funding],
	ISNULL(n.Discount,0) as [Discount/ Premium],
	ISNULL(n.OriginationFee,0) as [Origination Fee],
	ISNULL(n.CapitalizedClosingCosts,0) as [Capitalized Costs],

	--Accounting Tab
	ISNULL(acc.PayFrequency,0) as [Pay Frequency],
	ISNULL(n.TotalCommitment,0) as [Total Commitment],
	ISNULL(LEFT(CONVERT(VARCHAR,(Select top 1  [Date] from @MatutblMaxEffDateForEvent where AccountID = acc.AccountID) , 101), 10) ,'') as [Initial Maturity],

	ISNULL(LEFT(CONVERT(VARCHAR, FullyExtendedMaturityDate, 101), 10) ,'') as [Fully Ext. Maturity],
	ISNULL(LEFT(CONVERT(VARCHAR, ExpectedMaturityDate, 101), 10) ,'') as [Expected Maturity],
	--ISNULL(LEFT(CONVERT(VARCHAR, ExtendedMaturityScenario1, 101), 10) ,'') as [Extended Maturity Scenario 1],
	--ISNULL(LEFT(CONVERT(VARCHAR, ExtendedMaturityScenario2, 101), 10) ,'') as [Extended Maturity Scenario 2],
	--ISNULL(LEFT(CONVERT(VARCHAR, ExtendedMaturityScenario3, 101), 10) ,'') as [Extended Maturity Scenario 3],

	ISNULL(LEFT(CONVERT(VARCHAR, tblExtendedMat.ExtendedMaturityScenario1, 101), 10) ,'') as [Extended Maturity Scenario 1],
	ISNULL(LEFT(CONVERT(VARCHAR, tblExtendedMat.ExtendedMaturityScenario2, 101), 10) ,'') as [Extended Maturity Scenario 2],
	ISNULL(LEFT(CONVERT(VARCHAR, tblExtendedMat.ExtendedMaturityScenario3, 101), 10) ,'') as [Extended Maturity Scenario 3],

	--Closing Tab
	ISNULL(LEFT(CONVERT(VARCHAR, InitialInterestAccrualEndDate, 101), 10) ,'') as [Initial Interest Acc. End Date],
	ISNULL(AccrualFrequency,0) as [Accrual Frequency],
	ISNULL(LEFT(CONVERT(VARCHAR, FirstPaymentDate, 101), 10) ,'') as [First Payment Date],
	ISNULL(LEFT(CONVERT(VARCHAR, InitialMonthEndPMTDateBiWeekly, 101), 10) ,'') as [Initial Month End Payment Date],
	ISNULL(PaymentDateBusinessDayLag,0) as [Payment Date Business Day Lag],
	ISNULL(DeterminationDateLeadDays,0) as [Determination Date Lead Days],
	ISNULL(IOTerm,0) as [IO Term],
	ISNULL(AmortTerm,0) as [Amort Term],
	ISNULL(MonthlyDSOverridewhenAmortizing,0) as [Monthly DS Override],
	ISNULL(LEFT(CONVERT(VARCHAR, FinalInterestAccrualEndDateOverride, 101), 10) ,'')  as [Final Interest Accrual End Date],
	ISNULL(DeterminationDateReferenceDayoftheMonth ,0) as [Determination Date Reference Day],
	ISNULL(RateIndexResetFreq,0) as [Rate Index Reset Freq Mths],
	ISNULL(LEFT(CONVERT(VARCHAR, FirstRateIndexResetDate, 101), 10) ,'')  as [First Rate Index Reset Date],
	ISNULL(lStubPaidinAdvanceYN.name,'')  as [Stub Paid In Advance], --Lookup
	ISNULL(lLoanPurchase.name,'') as [Loan Purchase],  --Lookup
	ISNULL(AmortIntCalcDayCount,0) as [Amort Int Calc Day Count],
	ISNULL(InitialIndexValueOverride,0) as [Intitial Index Value Override],
	ISNULL(lRoundingMethod.name,'')  as [Rounding Method], --Lookup
	ISNULL(IndexRoundingRule,0) as [Index Rounding Rule],
	ISNULL(StubIntOverride,0) as [Stub Interest Override],
	ISNULL(lIndex.name,'') as [Index Name],

		--Rate Spread Schedule
		ISNULL(LEFT(CONVERT(VARCHAR, M.RSS_Date, 101), 10) ,'') as [Date (Spread)],
		ISNULL(M.RSS_ValueTypeText,'') as [Value Type (Spread)],
		ISNULL(M.RSS_value,0) as [Value (Spread)],
		ISNULL(M.RSS_IntCalcMethodText,'') as [Calc Method (Spread)],

		--Prepay and Addit. Fee Sched.
		ISNULL(LEFT(CONVERT(VARCHAR,M.PAF_Date, 101), 10) ,'') as [Start Date (Prepay)],
		ISNULL(M.PAF_ValueTypeText,'')  as [Value Type (Prepay)],
		ISNULL(M.PAF_value,0) as [Value (Prepay)],
		ISNULL(M.PAF_IncludedLevelYield,0) as [In Lvl Yield Calc (Prepay)],
		ISNULL(M.PAF_IncludedBasis,0) as [Include In Basis Calc (Prepay)],

		--Stripping Schedule
		ISNULL(LEFT(CONVERT(VARCHAR,M.SS_Date, 101), 10) ,'') as [Start Date (Stripping)],
		ISNULL(M.SS_ValueTypeText,'') as [Value Type (Stripping)],
		ISNULL(M.SS_value,0) as [Value (Stripping)],
		ISNULL(M.SS_IncludedLevelYield,0) as [In Lvl Yield Calc (Stripping)],
		ISNULL(M.SS_IncludedBasis,0) as [Include In Basis Calc (Stripping)]

		FROM CRE.DEAL d
		INNER JOIN CRE.NOTE n ON n.DEALID = d.DEALID
		INNER JOIN CORE.Account acc ON n.Account_Accountid = acc.Accountid
		left join Core.Lookup lStubPaidinAdvanceYN ON n.StubPaidinAdvanceYN=lStubPaidinAdvanceYN.LookupID 	
		left join Core.Lookup lLoanPurchase ON n.LoanPurchase=lLoanPurchase.LookupID
		left join Core.Lookup lRoundingMethod ON n.RoundingMethod=lRoundingMethod.LookupID
		left join Core.Lookup lIndex ON n.IndexNameID=lIndex.LookupID
		left join @Main M on M.AccountID = acc.Accountid 

		left join(
			Select noteid,ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10
			From(
				Select  n.noteid,
				'ExtendedMaturityScenario' + CAST(ROW_NUMBER() Over(Partition BY Noteid order by noteid,MaturityDate) as nvarchar(256))  as MaturityType
				,mat.MaturityDate			
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11  
					and acc.IsDeleted = 0  	
					and eve.StatusID = 1			
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where mat.MaturityType in (709) and e.StatusID = 1
				--and n.crenoteid = '2230'

			) AS SourceTable  
			PIVOT  
			(  
				MIN(MaturityDate)  
				FOR MaturityType IN (ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10)  
			) AS PivotTable

		)tblExtendedMat on tblExtendedMat.noteid = n.noteid

		

		WHERE ISNULL(acc.StatusID,1) = 1 
		ORDER BY d.creDealid,n.crenoteid
END
    

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
 END

END      


