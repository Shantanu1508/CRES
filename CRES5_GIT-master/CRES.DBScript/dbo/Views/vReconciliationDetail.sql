-- =============================================
-- Author:		Anurag Saxena
-- Create date: 05-19-2020
-- Description:	This view is used to get data for "ReconciliationDetail/ Pipeline Report"
-- Last Modified On: 01-21-2021
-- Last Modified By: Anurag Saxena
-- Description: Added M61 Commitment and M61 Total Adjusted Commitment amount
-- =============================================

CREATE VIEW [dbo].[vReconciliationDetail]
AS
SELECT [NoteId]
,Recon.[DealId]
,Recon.[DealName]
,[NoteName]
,[ServicersLoanNumber]
,[ServicerName]
,[BackshopFinancingSourceCode]
,[BackshopFinancingCodeSourceName]
,[M61FinancingCodeSourceName]
,[PaidOff/Active]
,[OrigLoanAmount]
,Recon.[TotalCommitment]
,[TotalCurrentAdjustedCommitment]
,[M61Commitment]
,recon.[M61AdjustedCommitment]
,recon.[PastFunding]
,[FutureFunding]
,[CurrentBalance]
,[EndingBalance]
,[CurCommitCurrBalRFFunding]
,[RemainingFutureFundingPropertyRelease]
,[RemainingFutureFundingPayoffs]
,[RemainingFutureFundingLoanAmortization]
,[RemainingFutureFundingDifference]
,[PercentofNote]
,[StatedMaturityDate]
,[FundingDate]
,[PeriodEndDate]
,[ActualPayoffDate]
,[BackshopCurrentInterestRate]
,[ServicerBalance]
,[ServicerInterestRate]
,[ServicerCurrentPaidToDate]
,[AllInCouponRate]
,[Status]
,ROUND(ISNULL([CurrentBalance], 0) - ISNULL([EndingBalance], 0), 2) BackshopM61CurrentAmountVariance
,ROUND(ISNULL([CurrentBalance], 0) - ISNULL([ServicerBalance], 0), 2) CurrentBalanceDiffServicerVsBackshop
,CumulativePIKFunding
,FuturePIKFunding
FROM [DW].[ReconciliationDetailBI] AS Recon
LEFT JOIN Deal d ON d.dealid = Recon.dealid






