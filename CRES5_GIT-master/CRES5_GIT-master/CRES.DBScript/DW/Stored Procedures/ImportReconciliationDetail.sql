-- =============================================
-- Author:		Anurag Saxena
-- Create date: 05-19-2020
-- Description:	This stored procedure is used to load Report.ReconciliationDetail table for "ReconciliationDetail/ Pipeline Report"
-- Last Modified On: 05-29-2020
-- Last Modified By: Anurag Saxena
-- Description: Updated Active vs Paid of logic and added Deal in the query
-- =============================================
CREATE PROCEDURE [DW].[ImportReconciliationDetail]
AS
BEGIN
	
	SET NOCOUNT ON;

TRUNCATE TABLE  [DW].[ReconciliationDetailBI];	

    WITH  vNoteTranchePercentageBI AS
(

SELECT crenoteId,SUM(PercentofNote) AS PercentofNote 
FROM DW.NoteTranchePercentageBI 
GROUP BY crenoteId
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
	[LastUpdateDate] 
	)
SELECT  
 	N.NoteID
	,ControlId_F
	,D.DealName
	,NoteName
	,Note.Servicerid as ServicersLoanNumber
	,ServicerName
	,N.FinancingSource AS FinancingSourceCode_BS
	,FSM.FinancingSourceName As FinancingSource_BS
	,Note.FinancingSource AS FinancingSource_M61
	,CASE 
		WHEN note.ActualPayoffDate IS NULL AND DE.[Status] = 'Active' AND D.LoanStatusCd_F = 'Funded'
			THEN 'Active'
		ELSE 'PaidOff'
		END AS [PaidOff Vs Active]
	,OrigLoanAmount
	,N.TotalCommitment
	,TotalCurrentAdjustedCommitment
	,PastFunding
	,FutureFunding
	,CurrentBalance
	,EndingBalance
	,ISNULL(TotalCurrentAdjustedCommitment - CurrentBalance - FutureFunding,0) AS CurCommit_CurrBal_RFFunding
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
FROM [dbo].[vUwNoteTrRecon] N 
INNER JOIN uwDeal D ON D.ControlId = N.ControlId_F
INNER JOIN vNoteTranchePercentageBI NT ON NT.CrenOteid = N.noteid
INNER JOIN [dbo].[Deal] DE ON DE.DealID = N.ControlId_F
LEFT JOIN [dbo].[vCashflow] c ON C.Noteid = N.Noteid
LEFT JOIN [dbo].[vNotePeriodicCalc] NP ON NP.Noteid = Convert(VARCHAR(10), N.Noteid)
	AND C.Periodenddate = NP.Periodenddate
LEFT JOIN [dbo].[Note] Note ON Note.NoteID = Convert(VARCHAR(10), N.Noteid)
LEFT JOIN [CRE].[FinancingSourceMaster] FSM ON FSM.FinancingSourceCode =  N.FinancingSource
LEFT JOIN [dbo].[vFunding] funding ON funding.NoteId_f = Convert(VARCHAR(10), N.Noteid) 
 
	SET NOCOUNT OFF;
END
