
CREATE FUNCTION dbo.NoteDetailReport()
RETURNS  @Notedetail TABLE 
(
  [Deal ID]	nvarchar(max)  NULL,
 [Deal Name]	nvarchar(max)  NULL,
 [Note ID]	nvarchar(max)  NULL,
 [Note Name]	nvarchar(max)  NULL,
 [Closing Date]	Date  NULL,
 [Initial Funding]	decimal(28,12)  NULL,
 [Discount/ Premium]	decimal(28,12)  NULL,
 [Origination Fee]	decimal(28,12)  NULL,
 [Capitalized Costs]	decimal(28,12)  NULL,
 [Pay Frequency]	int  NULL,
 [Total Commitment]	decimal(28,12)  NULL,
 [Initial Maturity]	Date  NULL,
 [Fully Ext. Maturity]	Date  NULL,
 [Expected Maturity]	Date  NULL,
 [Extended Maturity Scenario 1]	Date  NULL,
 [Extended Maturity Scenario 2]	Date  NULL,
 [Extended Maturity Scenario 3]	Date  NULL,
 [Initial Interest Acc. End Date]	Date  NULL,
 [Accrual Frequency]	int  NULL,
 [First Payment Date]	Date  NULL,
 [Initial Month End Payment Date]	Date  NULL,
 [Payment Date Business Day Lag]	int  NULL,
 [Determination Date Lead Days]	int  NULL,
 [IO Term]	int  NULL,
 [Amort Term]	int  NULL,
 [Monthly DS Override]	decimal(28,12)  NULL,
 [Final Interest Accrual End Date]	Date  NULL,
 [Determination Date Reference Day]	int  NULL,
 [Rate Index Reset Freq Mths]	decimal(28,12)  NULL,
 [First Rate Index Reset Date]	Date  NULL,
 [Stub Paid In Advance]	nvarchar(max)  NULL,
 [Loan Purchase]	nvarchar(max)  NULL,
 [Amort Int Calc Day Count]	int  NULL,
 [Intitial Index Value Override]	decimal(28,12)  NULL,
 [Rounding Method]	nvarchar(max)  NULL,
 [Index Rounding Rule]	int  NULL,
 [Stub Interest Override]	decimal(28,12)  NULL,
 [Index Name]	nvarchar(max)  NULL,
 [RSS_Date]	Date  NULL,
 [RSS_ValueTypeText]	nvarchar(max)  NULL,
 [RSS_value]	decimal(28,12)  NULL,
 [RSS_IntCalcMethodText]	nvarchar(max)  NULL,
 [PAF_Date]	Date  NULL,
 [PAF_ValueTypeText]	nvarchar(max)  NULL,
 [PAF_value]	decimal(28,12)  NULL,
 [PAF_IncludedLevelYield]	decimal(28,12)  NULL,
 [PAF_IncludedBasis]	decimal(28,12)  NULL,
 [SS_Date]	Date  NULL,
 [SS_ValueTypeText]	nvarchar(max)  NULL,
 [SS_value]	decimal(28,12)  NULL,
 [SS_IncludedLevelYield]	decimal(28,12)  NULL,
 [SS_IncludedBasis]	decimal(28,12)  NULL

)
AS
BEGIN



  --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


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
Select  acc.Accountid,e.EffectiveStartDate,mat.maturityDate,e.EventTypeID
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
	
where mat.maturityType = 708 
and	mat.Approved = 3
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
--					where EventTypeID = @Maturity
--					GROUP BY n.Account_AccountID,EventTypeID

--			) sEvent

--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and mat.SelectedMaturityDate = sEvent.[Date]  



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
					where EventTypeID = @RateSpreadSchedule and eve.StatusID = 1
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
		--PRINT('Update');
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
		--PRINT('INSERT');
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
					where EventTypeID = @StrippingSchedule and eve.StatusID = 1
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
		--PRINT('Update');
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
		--PRINT('INSERT');
		INSERT INTO @Main (AccountID,SS_Date,SS_ValueTypeText,SS_Value,SS_IncludedLevelYield,SS_IncludedBasis)
		VALUES(@AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis)
	END
					 
FETCH NEXT FROM CursorStripSch
INTO @AccountID,@Date,@ValueTypeText,@Value,@IncludedLevelYield,@IncludedBasis
END
CLOSE CursorStripSch   
DEALLOCATE CursorStripSch

--==================================================================================
insert into @Notedetail

Select 
D.CREDealId as [Deal ID],
D.DealName as [Deal Name],
N.CRENoteId as [Note ID],
acc.Name as [Note Name],

--Settlement Tab
n.ClosingDate as [Closing Date],
n.InitialFundingAmount as [Initial Funding],
n.Discount as [Discount/ Premium],
n.OriginationFee as [Origination Fee],
n.CapitalizedClosingCosts as [Capitalized Costs],

--Accounting Tab
acc.PayFrequency as [Pay Frequency],
n.TotalCommitment as [Total Commitment],
(Select [Date] from @MatutblMaxEffDateForEvent where AccountID = acc.AccountID) as [Initial Maturity],

FullyExtendedMaturityDate as [Fully Ext. Maturity],
ExpectedMaturityDate as [Expected Maturity],

--ExtendedMaturityScenario1 as [Extended Maturity Scenario 1],
--ExtendedMaturityScenario2 as [Extended Maturity Scenario 2],
--ExtendedMaturityScenario3 as [Extended Maturity Scenario 3],

tblExtendedMat.ExtendedMaturityScenario1 as [Extended Maturity Scenario 1],
tblExtendedMat.ExtendedMaturityScenario2 as [Extended Maturity Scenario 2],
tblExtendedMat.ExtendedMaturityScenario3 as [Extended Maturity Scenario 3],


--Closing Tab
InitialInterestAccrualEndDate as [Initial Interest Acc. End Date],
AccrualFrequency as [Accrual Frequency],
FirstPaymentDate as [First Payment Date],
InitialMonthEndPMTDateBiWeekly as [Initial Month End Payment Date],
PaymentDateBusinessDayLag as [Payment Date Business Day Lag],
DeterminationDateLeadDays as [Determination Date Lead Days],
IOTerm as [IO Term],
AmortTerm as [Amort Term],
MonthlyDSOverridewhenAmortizing as [Monthly DS Override],
FinalInterestAccrualEndDateOverride as [Final Interest Accrual End Date],
DeterminationDateReferenceDayoftheMonth as [Determination Date Reference Day],
RateIndexResetFreq as [Rate Index Reset Freq Mths],
FirstRateIndexResetDate as [First Rate Index Reset Date],
lStubPaidinAdvanceYN.name  as [Stub Paid In Advance], --Lookup
lLoanPurchase.name as [Loan Purchase],  --Lookup
AmortIntCalcDayCount as [Amort Int Calc Day Count],
InitialIndexValueOverride as [Intitial Index Value Override],
lRoundingMethod.name  as [Rounding Method], --Lookup
IndexRoundingRule as [Index Rounding Rule],
StubIntOverride as [Stub Interest Override],
lIndex.name as [Index Name], --Lookup

--Rate Spread Schedule
M.RSS_Date,
M.RSS_ValueTypeText,
M.RSS_value,
M.RSS_IntCalcMethodText,

--Prepay and Addit. Fee Sched.
M.PAF_Date,
M.PAF_ValueTypeText,
M.PAF_value,
M.PAF_IncludedLevelYield,
M.PAF_IncludedBasis,

--Stripping Schedule
M.SS_Date,
M.SS_ValueTypeText,
M.SS_value,
M.SS_IncludedLevelYield,
M.SS_IncludedBasis

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
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
		where mat.MaturityType in (709)
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


  -- Set isolation level to original isolation level
  -- SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
 



	

return

END



