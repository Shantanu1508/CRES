-- View
Create View  [dbo].uwCashflowCurrPreviousMonthend
As
Select * from(
Select Noteid
, Max(Periodenddate)Periodenddate
, SUM(CurrentBalance)CurrentBalance 

from [dbo].[UwCashflow][DW]
Group by Noteid
  
 Union all

  Select Noteid
, MAX(Eomonth(Periodenddate,-1))Periodenddate
, SUM(CurrentBalance)CurrentBalance 

from [dbo].[UwCashflow][DW]

Group by Noteid

  )X

