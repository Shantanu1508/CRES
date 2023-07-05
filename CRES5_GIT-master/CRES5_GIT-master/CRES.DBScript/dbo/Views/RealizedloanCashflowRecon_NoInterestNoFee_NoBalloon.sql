
CREATE view [dbo].[RealizedloanCashflowRecon_NoInterestNoFee_NoBalloon]
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
 Where Ig.TransactionTypeBI not Like '%Fee%'
 and Ig.TransactionTypeBI  not Like '%Interest%' 
and ig.TransactionTypeBI not Like '%Balloon%'

