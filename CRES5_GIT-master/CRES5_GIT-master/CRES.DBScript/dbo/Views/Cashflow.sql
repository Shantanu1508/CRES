
Create VIEW [dbo].[Cashflow] (
	Noteid
	,PeriodEndDate
	,EndingBalance
	)
AS
SELECT Noteid
	,PeriodEndDate
	,EndingBalance
FROM dbo.[NotePeriodicCalc] AS uCashFlow
WHERE PeriodEndDate IN (
		SELECT MAX(PeriodEndDate) ReportDate -- To Get Report Date Data
		FROM dbo.[UwCashflow] AS uCashFlow  
		)
AND Scenario = 'Default'  

UNION ALL

SELECT Noteid
	,PeriodEndDate
	,EndingBalance
FROM dbo.[NotePeriodicCalc] AS uCashFlow
WHERE PeriodEndDate = EOMONTH(GETDATE(), - 1) -- To Get Data of Last day of Last month
AND Scenario = 'Default'
