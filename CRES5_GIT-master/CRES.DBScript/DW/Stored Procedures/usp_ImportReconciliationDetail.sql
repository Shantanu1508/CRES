-- =============================================
-- Author: Anurag Saxena
-- Create date: 05-19-2020
-- Description: This stored procedure is used to load Report.ReconciliationDetail table for "ReconciliationDetail/ Pipeline Report"
-- Last Modified On: 02-24-2021
-- Last Modified By: Anurag Saxena
-- Description: Modified Active/Paid of logic
-- =============================================

CREATE PROCEDURE [DW].[usp_ImportReconciliationDetail]
AS
BEGIN
SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


TRUNCATE TABLE [DW].[ReconciliationDetailBI];


WITH vNoteTranchePercentageBI AS
(

SELECT crenoteId,SUM(PercentofNote) AS PercentofNote
FROM DW.NoteTranchePercentageBI
GROUP BY crenoteId
),
vAllPIK as
(
SELECT Noteid_F, SUM( FundingAmount ) as AllPIK from uwFunding
WHERE FundingPurposeCD_F = 'PIK Non-Commit Adj'
GROUP BY Noteid_F
)
INSERT INTO [DW].[ReconciliationDetailBI]
(
[NoteId],
[DealId],
[DealName],
[NoteName],
[ServicersLoanNumber] ,
[ServicerName] ,
[BackshopFinancingSourceCode] ,
[BackshopFinancingCodeSourceName] ,
[M61FinancingCodeSourceName] ,
[PaidOff/Active] ,
[OrigLoanAmount] ,
[TotalCommitment] ,
[TotalCurrentAdjustedCommitment] ,
[M61Commitment], -- Added on 01/21/21
[M61AdjustedCommitment],-- Added on 01/21/21
[PastFunding] ,
[FutureFunding] ,
[CurrentBalance] ,
[EndingBalance] ,
[CurCommitCurrBalRFFunding] ,
[RemainingFutureFundingPropertyRelease] ,
[RemainingFutureFundingPayoffs] ,
[RemainingFutureFundingLoanAmortization] ,
[RemainingFutureFundingDifference] ,
[PercentofNote] ,
[StatedMaturityDate] ,
[FundingDate] ,
[PeriodEndDate] ,
[ActualPayoffDate] ,
[LastUpdateDate] ,
[AllInCouponRate] ,
[CumulativePIKFunding] ,
[FuturePIKFunding]
)

SELECT
N.NoteID
,ControlId_F
,DealName
,NoteName
,Note.ServicerID as ServicersLoanNumber
,ServicerName
,N.FinancingSource AS FinancingSourceCode_BS
,FSM.FinancingSourceName As FinancingSource_BS
,Note.FinancingSource AS FinancingSource_M61
--,CASE
--WHEN note.ActualPayoffDate IS NULL 
--THEN 'Active'
--ELSE 'PaidOff'
--END AS [PaidOff Vs Active] 
,CASE
WHEN note.ActualPayoffDate IS NULL AND d.LoanStatusCd_F = 'funded' -- modified for removing notes which are not there in the M61 note view
THEN 'Active'
ELSE 'PaidOff'
END AS [PaidOff Vs Active] 
,OrigLoanAmount
,N.TotalCommitment -- Backshop total Commitment amount
,TotalCurrentAdjustedCommitment -- Backshop total Adjustment commitment amount
,isnull(Note.M61Commitment,0) as M61Commitment -- M61 Total Commitment Amount
,isnull(Note.M61AdjustedCommitment,0) as M61AdjustedCommitment -- M61 Total Adjustment commitment amount
,PastFunding
,FutureFunding
,CurrentBalance
,EndingBalance
--, CurrentBalance - EndingBalance AS Backshop_M61_Balance -- Only to verify Total Variance
--,ISNULL(TotalCurrentAdjustedCommitment - CurrentBalance - FutureFunding + PIK.AllPIK ,0) AS CurCommit_CurrBal_RFFunding_ALLPIK
-- Added for PikPrincipalPaid
,ISNULL(TotalCurrentAdjustedCommitment - CurrentBalance - FutureFunding + PIK.AllPIK - ISNULL(PIKPrincipalPaid,0),0) AS CurCommit_CurrBal_RFFunding_ALLPIK
,ISNULL(funding.[Remaining FFs for Property Release],0) AS [Remaining FFs for Property Release]
,ISNULL(funding.[Remaining FFs for Payoffs],0) AS [Remaining FFs for Payoffs]
,ISNULL(funding.[Remaining FFs for Loan Amortization],0) AS [Remaining FFs for Loan Amortization]
,
/*=========================Current Commited, Current Balance and Remaining Future Funding=============================================*/
ISNULL(funding.[Remaining FFs for Property Release],0)
+ ISNULL(funding.[Remaining FFs for Loan Amortization],0)
+ ISNULL(funding.[Remaining FFs for Payoffs],0)
+
(
ISNULL(TotalCurrentAdjustedCommitment ,0)
- ISNULL(CurrentBalance ,0)
- ISNULL(FutureFunding,0)
)
AS RemainingFutureFundingDiff
/*=========================Current Commited, Current Balance and Remaining Future Funding=============================================*/
,PercentofNote
,StatedMaturityDate
,FundingDate
,NP.PeriodEndDate
,note.ActualPayoffDate
,GETDATE() as [LastUpdateDate]
/*========================= M61 Interest Rate ============================*/
,NP.AllInCouponRate
,NP.CumulativePIKFunding
,NP.PIKFutureFunding as FuturePIKFunding

--,NP.PIKFutureFunding -- new
--,NP.PIKPrincipalFunding
--,NP.PIKPrincipalFunding_all
--,NP.PIKPrincipalPaid
--,NP.PIKPrincipalPaid_all
FROM [dbo].[vUwNoteTrRecon] N
INNER JOIN uwDeal D ON D.ControlId = ControlId_F
INNER JOIN vNoteTranchePercentageBI NT ON NT.CrenOteid = N.noteid
LEFT JOIN [dbo].[vCashflow] c ON C.Noteid = N.Noteid
LEFT JOIN [dbo].[vNotePeriodicCalc] NP ON NP.Noteid = Convert(VARCHAR(10), N.Noteid)
AND C.Periodenddate = NP.Periodenddate
LEFT JOIN [dbo].[Note] Note ON Note.NoteID = Convert(VARCHAR(10), N.Noteid)
LEFT JOIN [CRE].[FinancingSourceMaster] FSM ON FSM.FinancingSourceCode = N.FinancingSource
LEFT JOIN [dbo].[vFunding] funding ON funding.NoteId_f = Convert(VARCHAR(10), N.Noteid)
LEFT JOIN vAllPIK PIK ON PIK.Noteid_F = N.NoteID

------------------ Servicer : Berkadia Data Update ---------------
UPDATE RDI
SET
RDI.ServicerBalance = BKD.Principal_Balance
,RDI.[ServicerInterestRate] = BKD.[Interest_Rate]
,RDI.[ServicerCurrentPaidToDate] = CASE WHEN (CB.isholidayBI = 1 OR CB.IsWeekend = 1)
THEN DATEADD(Day, -1, DATEADD(Month, -1, BKD.[Next_Pmt_Due_Dt]))
ELSE DATEADD(Month, -1, BKD.[Next_Pmt_Due_Dt]) END
FROM [DW].[ReconciliationDetailBI] RDI
INNER JOIN [dbo].[BerkadiaDataTap] BKD ON BKD.NoteId = RDI.NoteId
INNER JOIN [dbo].[Calendar] CB ON CB.[Date] = DATEADD(Month, -1, BKD.[Next_Pmt_Due_Dt])

-------------- Servicer : Wells Data Update ---------------
;with ServicerWells As
(
SELECT NoteId
,MAx(TransactionDate) as TransactionDate -- Get most recent transaction date
FROM WellsDataTap WDT
--WHERE NoteID = 10216
GROUP BY NoteID
)
,WellsData AS (
SELECT wd.NoteId, wd.TransactionDate, MAX(Entry_no) as Entry_no FROM [dbo].[WellsDataTap] WD -- get maxium Entry No for most recent Transaction date
JOIN ServicerWells SW ON SW.NoteId = WD.NoteId and SW.TransactionDate = WD.TransactionDate
group by wd.NoteId, wd.TransactionDate
)
UPDATE RDI
SET
RDI.ServicerBalance = WDT.[Balance_After_Funding_Transacton]
,RDI.[ServicerInterestRate] = WDT.Current_All_In_Interest_Rate
,RDI.[ServicerCurrentPaidToDate] = WDT.Current_Interest_Paid_To_Date
FROM [DW].[ReconciliationDetailBI] RDI
INNER JOIN WellsData WD ON WD.NoteId = RDI.noteid
INNER JOIN WellsDataTap WDT ON WDT.noteid = WD.NoteId and WD.Entry_no = WDT.Entry_No and WD.TransactionDate = WDT.TransactionDate

Print('usp_ImportReconciliationDetail');



SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END