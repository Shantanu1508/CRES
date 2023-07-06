-- View
Create View 
[dbo].MaxReportDate as
Select MAX(PeriodEndDate) PeriodEndDate from DW.UwCashflowBI
