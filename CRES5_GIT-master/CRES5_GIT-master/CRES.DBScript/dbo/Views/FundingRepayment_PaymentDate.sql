Create View [dbo].FundingRepayment_PaymentDate 
AS

Select 
CRENoteID
,NF.Date
, Amount 
, Day(FirstPaymentDate) PaymentDate
, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End as NextAccrualDate

,		ISNULL(Case WHEN DATENAME(DW, Case WHEN IsHoliday = 1 THEN DATEADD(Day, -1, X.Date) else X.Date End) =  'Saturday' THen DateAdd(Day, -1, X.Date)
					 When DATENAME(DW, CASe WHEN IsHoliday = 1 THEN DATEADD(Day, -1, X.Date) else X.Date ENd) =  'Sunday' THEN DateAdd (Day,-2, X.Date)
				
					 End , X.Date)as HolidayAdjustedPaymentDate


from NoteFundingSchedule NF
Left Join Note N on NF.CRENoteID = N.NoteID


Outer Apply( Select Isholiday,

				Case WHEN DATENAME(DW, CASe WHEN IsHoliday = 1 THEN DATEADD(Day, -1, C.Date) else c.Date ENd) =  'Staurday' THen DateAdd(Day, -1, C.Date)
					 When DATENAME(DW, CASe WHEN IsHoliday = 1 THEN DATEADD(Day, -1, C.Date) else c.Date ENd) =  'Sunday' THEN DateAdd (Day,-2, C.Date)
					 Else C.Date
					 End as DaTe1


					 , Date

						  from Calendar C 
			 Where CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
				Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End = C.Date
			)X


Where Maturity_DateBI > GETDATE()


--order by CRENoteID, X.Date



