
CREATE view [dbo].[RealizedloanCashflowRecon]  
as  
  
select   
ig.NoteID ExcelNoteid  
, ig.Date ExcelDate  
,ig.delaname DealName   
,ig.Value Excelamount  
,ig.TransactionTypeBI ExcelType  
,M61.amount M61Amount  
,M61.TransactionTypeBI M61Type  
  
  
from [dbo].[RealizedCashFlow_IG]  Ig      
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61   
on  (IG.noteid+'_'+ IG.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),IG.Date, 110)  )  = (m61.noteid+'_'+ M61.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  )   
   
  
 --Select * from  [dbo].[RealizedCashFlow_IG]  
 ----Where Noteid = 'Phtm Line A' and Valuetype = 'Interestpaid'  
  
 --select distinct type from Transactionentry  
  
 --Select top 10 ( m61.noteid+'_'+ m61.Type  + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  ) Note_Type_Date from [dbo].[RealizedCashFlow_TransactionEntry]  M61
