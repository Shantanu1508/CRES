
CREATE view [dbo].[RealizedloanCashflowRecon_Interest]
as
With Interest as
(
select * from
(
select Distinct
ig.NoteID ExcelNoteid
,ig.Date ExcelDate
,ig.delaname DealName 
,ig.Value Excelamount
,ig.TransactionTypeBI ExcelType
,ISNULL(M61.amount,M61_New.M61Amount) M61Amount
--,M61.Type M61Type
,DATEPART(MM,ig.date)MOnth_date
,DATEPART (yy,ig.Date)Year_Date
,Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date))
,M61date
from [dbo].[RealizedCashFlow_IG]  Ig    
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.TransactionTypeBI and ig.Date = m61.date
left join(
	select 
	ig.NoteID ExcelNoteid
	, ig.Date ExcelDate
	,ig.delaname DealName 
	,ig.Value Excelamount
	,ig.TransactionTypeBI ExcelType
	,M61.amount M61Amount
	--,M61.Type M61Type
	, DATEPART(MM,ig.date)MOnth_date
	, DATEPART (yy,ig.Date)Year_Date
	, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
	, M61.Date M61Date
	from [dbo].[RealizedCashFlow_IG]  Ig    
	left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 
	on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.TransactionTypeBI and Month(ig.Date) = Month(m61.date) and Year (ig.Date) = Year(m61.date)
	where  ig.TransactionTypeBI like '%Interest%'
	--and ig.NoteID = '1941'
) M61_New 
on IG.Noteid = M61_New.ExcelNoteid and IG.TransactionTypeBI = M61_New.ExcelType and ig.Date = M61_New.ExcelDate
where exceltype like '%Interest%'
)x
)
Select * from Interest
