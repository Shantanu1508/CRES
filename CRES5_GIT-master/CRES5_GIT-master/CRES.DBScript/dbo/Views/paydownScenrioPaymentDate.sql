CREATE View [dbo].[paydownScenrioPaymentDate]
as
Select 
CRENoteID
,ISNULL(NF.Date,'1999')Date
, Amount 
, Day(FirstPaymentDate) PaymentDate
, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End as NextAccrualDate

--,		ISNULL(Case WHEN DATENAME(DW, Case WHEN isholidayBI = 1 THEN DATEADD(Day, -1, X.Date) else X.Date End) =  'Saturday' THen DateAdd(Day, -1, X.Date)
--					 When DATENAME(DW, CASe WHEN isholidayBI = 1 THEN DATEADD(Day, -1, X.Date) else X.Date ENd) =  'Sunday' THEN DateAdd (Day,-2, X.Date)
				
--					 End , X.Date)as HolidayAdjustedPaymentDate

, Purpose
from NoteFundingSchedule NF
Left Join Note N on NF.CRENoteID = N.NoteID
--Outer Apply( Select isholidayBI,

--				Case WHEN DATENAME(DW, CASe WHEN isholidayBI = 1 THEN DATEADD(Day, -1, C.Date) else c.Date ENd) =  'Saturday' THen DateAdd(Day, -1, C.Date)
--					 When DATENAME(DW, CASe WHEN isholidayBI = 1 THEN DATEADD(Day, -1, C.Date) else c.Date ENd) =  'Sunday' THEN DateAdd (Day,-2, C.Date)
--					 Else C.Date
--					 End as DaTe1


--					 , Date

--						  from CalendarBI C 
--			 Where CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
--				Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End = C.Date
--			)X


Where Maturity_DateBI > GETDATE() 

