CREATE view [dbo].[RealizedLoanCashflowRecon_Balloon]
as
Select ig.NoteID ExcelNoteid
, ig.Date ExcelDate
,ig.delaname DealName 
,ig.Value Excelamount
,ig.TransactionTypeBI ExcelType
,M61.amount M61Amount
,M61.Type M61Type
, DATEPART(MM,ig.date)MOnth_date
, DATEPART (yy,ig.Date)Year_Date
,IG.NoteID_Date_Scenario
,IG.Note_Type_Date
, Month_year = Convert(varchar, DATEPART(MM,ig.date)) + '_' + Convert(varchar, DATEPART (yy,ig.Date) )
 from [RealizedCashFlow_IG] IG
Left join RealizedLoanCashflowBalloon_M61 M61 on M61.Note_Type_Date = IG.Note_Type_Date
Where Ig.TransactionTypeBI = 'Balloon'


