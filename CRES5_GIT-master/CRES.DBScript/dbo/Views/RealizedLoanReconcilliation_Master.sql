
CREATE View [dbo].[RealizedLoanReconcilliation_Master]
as

With RealizedLoanReconcilliation as
(
Select * from
(
--Fee
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

--,'Fees' as Gtype

from [dbo].[RealizedCashFlow_IG]  Ig    
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 
on  (IG.noteid+'_'+ IG.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),IG.Date, 110)  )  = (m61.noteid+'_'+ M61.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  ) 
 Where Ig.TransactionTypeBI  Like '%Fee%'
 
 Union
 --Interest
--select 
--ig.NoteID ExcelNoteid
--, ig.Date ExcelDate
--,ig.delaname DealName 
--,ig.Value Excelamount
--,ig.TransactionTypeBI ExcelType
--,M61.amount M61Amount
----,M61.Type M61Type
--, DATEPART(MM,ig.date)MOnth_date
--, DATEPART (yy,ig.Date)Year_Date
--, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
--from [dbo].[RealizedCashFlow_IG]  Ig    
--left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 
--on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.TransactionTypeBI and Month(ig.Date) = Month(m61.date) and Year (ig.Date) = Year(m61.date)
--where  ig.TransactionTypeBI like '%Interest%'

--=======================================================
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

--,'Interest' as Gtype

from [dbo].[RealizedCashFlow_IG]  Ig    
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.TransactionTypeBI and ig.Date = m61.date
left join(
	select 
	ig.NoteID ExcelNoteid
	, ig.Date ExcelDate
	,ig.delaname DealName 
	,ig.Value Excelamount
	,ig.TransactionTypeBI ExcelType
	,SUM(M61.amount) M61Amount
	--,M61.Type M61Type
	, DATEPART(MM,ig.date)MOnth_date
	, DATEPART (yy,ig.Date)Year_Date
	, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
	from [dbo].[RealizedCashFlow_IG]  Ig    
	left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 
	on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.TransactionTypeBI and Month(ig.Date) = Month(m61.date) and Year (ig.Date) = Year(m61.date)
	where  ig.TransactionTypeBI like '%Interest%'	
	--and ig.NoteID = '1344'
	group by ig.NoteID,ig.Date,ig.delaname,ig.Value,ig.TransactionTypeBI
) M61_New 
on IG.Noteid = M61_New.ExcelNoteid and IG.TransactionTypeBI = M61_New.ExcelType and ig.Date = M61_New.ExcelDate

where ig.TransactionTypeBI like '%Interest%'
--=======================================================

union
--No Balloon No Interest No fee
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

--,'Other' as Gtype

from [dbo].[RealizedCashFlow_IG]  Ig    
left Join [dbo].[RealizedCashFlow_TransactionEntry]  M61 
on ISNULL(M61.Noteid,'') = ISNULL( IG.noteid,'') and  IG.TransactionTypeBI = M61.TransactionTypeBI  and IG.Date = M61.Date
--on  (IG.noteid+'_'+ IG.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),IG.Date, 110)  )  = (m61.noteid+'_'+ M61.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  ) 
 Where Ig.TransactionTypeBI not Like '%Fee%'
 and Ig.TransactionTypeBI  not Like '%Interest%' 
 and ig.TransactionTypeBI <>'Balloon'
 
 union
 --Balloon
-- Select ig.NoteID ExcelNoteid
--, ig.Date ExcelDate
--,ig.delaname DealName 
--,ig.Value Excelamount
--,ig.TransactionTypeBI ExcelType
--,M61.amount M61Amount
----,M61.Type M61Type
--, DATEPART(MM,ig.date)MOnth_date
--, DATEPART (yy,ig.Date)Year_Date
--, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
-- from [RealizedCashFlow_IG] IG
--Left join RealizedLoanCashflowBalloon_M61 M61 on M61.Note_Type_Date = IG.Note_Type_Date
--Where Ig.TransactionTypeBI = 'Balloon'

Select ig.NoteID ExcelNoteid
, ig.Date ExcelDate
,ig.delaname DealName 
,ig.Value Excelamount
,ig.TransactionTypeBI ExcelType
,ISNULL(M61.amount,M61_New.M61Amount) M61Amount
--,M61.Type M61Type
, DATEPART(MM,ig.date)MOnth_date
, DATEPART (yy,ig.Date)Year_Date
, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
--,'Balloon' as Gtype
from [RealizedCashFlow_IG] IG
Left join RealizedLoanCashflowBalloon_M61 M61 on M61.Note_Type_Date = IG.Note_Type_Date
Left JOin(

	Select ig.NoteID ExcelNoteid
	, ig.Date ExcelDate
	,ig.delaname DealName 
	,ig.Value Excelamount
	,ig.TransactionTypeBI ExcelType
	,M61.amount M61Amount
	--,M61.Type M61Type
	, DATEPART(MM,ig.date)MOnth_date
	, DATEPART (yy,ig.Date)Year_Date
	, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
	from [RealizedCashFlow_IG] IG
	Left join RealizedLoanCashflowBalloon_M61 M61 on IG.Noteid = M61.Noteid and IG.TransactionTypeBI = m61.Type and Month(ig.Date) = Month(m61.date) and Year (ig.Date) = Year(m61.date)
	Where Ig.TransactionTypeBI = 'Balloon'
	
) M61_New 
on IG.Noteid = M61_New.ExcelNoteid and IG.TransactionTypeBI = M61_New.ExcelType and ig.Date = M61_New.ExcelDate

Where Ig.TransactionTypeBI = 'Balloon'



)x
)
Select * from RealizedLoanReconcilliation
