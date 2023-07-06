/*
Modified By :Anurag Saxena
Modified Date: 29-12-2020
Description: Added PikPrincipalPaid logic 
*/

CREATE VIEW [dbo].[vNotePeriodicCalc] (
Noteid
,PeriodEndDate
,EndingBalance
,AllInCouponRate
,CumulativePIKFunding
,FuturePIKFunding
,PIKPrincipalPaid
,PIKPrincipalFunding
,PIKPrincipalPaid_all
,PIKPrincipalFunding_all
,PIKFutureFunding
)
AS
with PIKPrincipalPaid as
(	
SELECT NoteID, CONVERT(nvarchar(6), [Date], 112) [MonthYear], sum(Amount) Amount from TransactionEntry 
WHERE [TYPE] in( 'PIKPrincipalPaid') and Scenario = 'Default'
GROUP BY [NoteId], CONVERT(nvarchar(6), [Date], 112)
),
PIKPrincipalFunding as
(	
SELECT NoteID, CONVERT(nvarchar(6), [Date], 112) [MonthYear], sum(Amount) Amount from TransactionEntry 
WHERE [TYPE] in( 'PIKPrincipalFunding') and Scenario = 'Default'
GROUP BY [NoteId], CONVERT(nvarchar(6), [Date], 112)
)
SELECT uCashFlow.Noteid
,PeriodEndDate
,EndingBalance
--,Rate.AllInCouponRate
,CASE
WHEN (
Rate.[AllInCouponRate] IS NULL
OR Rate.[AllInCouponRate] = 0
)
THEN (Rate.[AdditionalPIKSpreadfromPIKTable] + Rate.AllInPikRate)
ELSE Rate.[AllInCouponRate] end AllInCouponRate
--,PPIK.CumulativePIKFunding
,(PPIK.CumulativePIKFunding - isnull(PIKPrincipalPaid,0)) as CumulativePIKFunding
,FPIK.FuturePIKFunding
,isnull(PIKPrincipalPaid,0) as PIKPrincipalPaid
,isnull(PIKPrincipalFunding,0) as PIKPrincipalFunding
,isnull(PIKPrincipalPaid_all,0) as PIKPrincipalPaid_all
,isnull(PIKPrincipalFunding_all,0) as PIKPrincipalFunding_all
,(-isnull(PIKPrincipalFunding_all,0) + isnull(PIKPrincipalFunding,0) -isnull(PIKPrincipalPaid_all,0) + isnull(PIKPrincipalPaid,0)) AS PIKFutureFunding 
-- Calculated based on the formula given by Iris
FROM [dbo].[NotePeriodicCalc_PipeLineRecon] AS uCashFlow --[dbo].[NotePeriodicCalc]
OUTER APPLY ( -- Added for PIKPrincipalPaid_all
SELECT NoteID, SUM( Amount ) as PIKPrincipalPaid_all from PIKPrincipalPaid ppp_all
WHERE ppp_all.Noteid = uCashFlow.NoteID
GROUP BY NoteID
) ppp_all
OUTER APPLY ( -- Added for PIKPrincipalFunding_all
SELECT NoteID, SUM( Amount ) as PIKPrincipalFunding_all from PIKPrincipalFunding ppf_all
WHERE ppf_all.Noteid = uCashFlow.NoteID
GROUP BY NoteID
) ppf_all
OUTER APPLY ( -- Added for pikPrincipalPaid
SELECT NoteID, SUM( Amount ) as PIKPrincipalPaid from PIKPrincipalPaid ppp
WHERE ppp.Noteid = uCashFlow.NoteID
and ppp.[MonthYear] <= CONVERT(nvarchar(6), uCashFlow.PeriodEndDate, 112)
GROUP BY NoteID
) ppp
OUTER APPLY ( -- Added for PIKPrincipalFunding
SELECT NoteID, SUM( Amount ) as PIKPrincipalFunding from PIKPrincipalFunding ppf
WHERE ppf.Noteid = uCashFlow.NoteID
and ppf.[MonthYear] <= CONVERT(nvarchar(6), uCashFlow.PeriodEndDate, 112)
GROUP BY NoteID
) ppf
LEFT JOIN [CRE].[PeriodicInterestRateUsed] AS Rate
ON Rate.NoteID = uCashFlow.NoteKey and Rate.[Date] = uCashFlow.[PeriodEndDate]
OUTER APPLY (
SELECT Noteid_F, SUM( FundingAmount ) as CumulativePIKFunding from uwFunding PPIK
WHERE PPIK.FundingPurposeCD_F = 'PIK Non-Commit Adj' and PPIK.Noteid_F = uCashFlow.NoteID
and PPIK.FundingDate <= uCashFlow.PeriodEndDate
GROUP BY Noteid_F
) PPIK
OUTER APPLY (
SELECT Noteid_F, SUM( FundingAmount ) as FuturePIKFunding from uwFunding FPIK
WHERE FPIK.FundingPurposeCD_F = 'PIK Non-Commit Adj' and FPIK.Noteid_F = uCashFlow.NoteID
and FPIK.FundingDate > uCashFlow.PeriodEndDate
GROUP BY Noteid_F
)FPIK
WHERE PeriodEndDate IN (
SELECT MAX(PeriodEndDate) ReportDate -- To Get Report Date Data
FROM dbo.[UwCashflow] AS uCashFlow
)
AND Scenario = 'Default'
AND Rate.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

-- Below code is used to get data for the last day of previous month from M61

--UNION ALL

--SELECT Noteid
-- ,PeriodEndDate
-- ,EndingBalance
--FROM dbo.[NotePeriodicCalc] AS uCashFlow
--WHERE PeriodEndDate = EOMONTH(GETDATE(), - 1)
--AND Scenario = 'Default'


--GO
GO

