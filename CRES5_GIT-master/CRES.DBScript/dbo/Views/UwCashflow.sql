
CREATE VIEW [dbo].[UwCashflow] AS
SELECT 
DealID,
Noteid   ,
CurrentBalance,
PeriodEndDate
FROM [DW].[UwCashflowBI]

