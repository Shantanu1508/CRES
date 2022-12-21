
CREATE VIEW [dbo].[vCashflow]  
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
SELECT U.Noteid  
 ,U.PeriodEndDate  
 ,uCashFlow.CurrentBalance  
FROM dbo.[UwCashflow] AS uCashFlow  
JOIN UwCashflow U ON U.NoteId = uCashFlow.NoteId  
 AND U.PeriodEndDate = uCashFlow.PeriodEndDate  
  
-- Below code is used to get data for the last day of previous month from Backshop  
  
-- UNION ALL  
   
--SELECT uCashFlow.Noteid  
-- ,uCashFlow.PeriodEndDate  
-- ,uCashFlow.CurrentBalance  
--FROM dbo.[UwCashflow] AS uCashFlow  
--WHERE uCashFlow.PeriodEndDate = EOMONTH(GETDATE(), - 1)  
  