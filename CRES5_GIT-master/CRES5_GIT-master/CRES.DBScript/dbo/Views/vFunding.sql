--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--DROP VIEW IF EXISTS [dbo].[vFunding] 
--GO
CREATE VIEW [dbo].[vFunding]
AS
WITH UwCashflow (
	NoteId
	,PeriodEndDate
	)
AS (
	SELECT Noteid
		,MAX(PeriodEndDate) PeriodEndDate
	FROM dbo.[UwCashflow] AS uCashFlow
	GROUP BY Noteid
	)
SELECT  
Noteid_F
,SUM(CASE 
		WHEN (
				[FundingPurposeCD_F] = 'Property Release'
				AND [FundingPurposeCD_F] IS NOT NULL
				)
			AND [FundingDate] > PeriodEndDate
			THEN [FundingAmount]
		ELSE 0
		END )AS [Remaining FFs for Property Release]
	,SUM(CASE 
		WHEN (
				[FundingPurposeCD_F] = 'Payoff/Paydown'
				AND [FundingPurposeCD_F] IS NOT NULL
				)
			AND [FundingDate] > PeriodEndDate
			THEN [FundingAmount]
		ELSE 0
		END )AS [Remaining FFs for Payoffs]
	,SUM(CASE 
		WHEN (
				[FundingPurposeCD_F] = 'Loan Amortization'
				AND [FundingPurposeCD_F] IS NOT NULL
				)
			AND [FundingDate] > PeriodEndDate
			THEN [FundingAmount]
		ELSE 0
		END ) AS [Remaining FFs for Loan Amortization]
FROM [UwFunding] uf 
JOIN UwCashflow uc ON uf.Noteid_F = uc.NoteId 
GROUP BY Noteid_F
