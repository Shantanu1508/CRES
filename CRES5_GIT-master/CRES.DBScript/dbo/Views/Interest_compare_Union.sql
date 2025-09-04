CREATE View [dbo].[Interest_compare_Union]
As
select * from
(

select 
ig.NoteID ExcelNoteid
,ig.Date ExcelDate
,d.dealname DealName 
,ig.Value Excelamount
,ig.TransactionTypeBI ExcelType
,Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
, dateBi= CONVERT (VARCHAR(10),ig.Date, 110)+'_'+'IG'
from [dbo].[RealizedCashFlow_IG]  Ig    
Left Join note n on n.noteid = ig.noteid
Left join deal d on d.dealkey = n.dealkey
where TransactionTypeBI = 'InterestPaid'
Union all
select 
M61.Noteid M61Noteid
,M61.Date M61Date
,M61.DealName M61DealName
,M61.Amount M61amount
,M61.Type M61Type
,Month_year = Convert(varchar, DATEPART(MM,m61.date)) + '_' + Convert(varchar, DATEPART (yy,m61.Date) )
, dateBi= CONVERT (VARCHAR(10),m61.Date, 110)+'_'+'M61'
from [dbo].TransactionEntry  M61    

where Type = 'InterestPaid' and Scenario = 'Default'
and M61.AccountTypeID =1
)X