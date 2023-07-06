
CREATE View [dbo].[RealizedLoanReconcilliation]  
as  
  
With RealizedLoanReconcilliation as  
(  
Select * from  
(  
select   
ig.NoteID ExcelNoteid  
, ig.Date ExcelDate  
,ig.delaname DealName   
,ig.Value Excelamount  
,ig.TransactionTypeBI ExcelType  
,M61.amount M61Amount  
,M61.TransactionTypeBI M61Type  
, DATEPART(MM,ig.date)MOnth_date  
, DATEPART (yy,ig.Date)Year_Date  
, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )  
  
from [dbo].[RealizedCashFlow_IG]  Ig      
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61   
on  (IG.noteid+'_'+ IG.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),IG.Date, 110)  )  = (m61.noteid+'_'+ M61.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  )   
 Where Ig.TransactionTypeBI  Like '%Fee%'  
 Union  
  
select   
ig.NoteID ExcelNoteid  
, ig.Date ExcelDate  
,ig.delaname DealName   
,ig.Value Excelamount  
,ig.TransactionTypeBI ExcelType  
,M61.amount M61Amount  
,M61.TransactionTypeBI M61Type  
, DATEPART(MM,ig.date)MOnth_date  
, DATEPART (yy,ig.Date)Year_Date  
, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )  
from [dbo].[RealizedCashFlow_IG]  Ig      
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61   
on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.TransactionTypeBI and Month(ig.Date) = Month(m61.date)  
and Year (ig.Date) = Year(m61.date)  
where m61.TransactionTypeBI Like '%Interest%' and ig.TransactionTypeBI like '%Interest%'  
  
  
union  
select   
ig.NoteID ExcelNoteid  
, ig.Date ExcelDate  
,ig.delaname DealName   
,ig.Value Excelamount  
,ig.TransactionTypeBI ExcelType  
,M61.amount M61Amount  
,M61.TransactionTypeBI M61Type  
, DATEPART(MM,ig.date)MOnth_date  
, DATEPART (yy,ig.Date)Year_Date  
, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )  
  
from [dbo].[RealizedCashFlow_IG]  Ig      
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61   
on  (IG.noteid+'_'+ IG.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),IG.Date, 110)  )  = (m61.noteid+'_'+ M61.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  )   
 Where Ig.TransactionTypeBI not Like '%Fee%'  
 and Ig.TransactionTypeBI  not Like '%Interest%' and  M61.TransactionTypeBI not Like '%Fee%'  
 and m61.TransactionTypeBI  not Like '%Interest%'   
 union  
 Select ig.NoteID ExcelNoteid  
, ig.Date ExcelDate  
,ig.delaname DealName   
,ig.Value Excelamount  
,ig.TransactionTypeBI ExcelType  
,M61.amount M61Amount  
,M61.Type M61Type  
, DATEPART(MM,ig.date)MOnth_date  
, DATEPART (yy,ig.Date)Year_Date  
, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )  
 from [RealizedCashFlow_IG] IG  
Left join RealizedLoanCashflowBalloon_M61 M61 on M61.Note_Type_Date = IG.Note_Type_Date  
Where Ig.TransactionTypeBI = 'Balloon'  
  
)x  
)  
Select * from RealizedLoanReconcilliation