Create View [dbo].DropDate_NoActivityAfterDropdate_Interim
as

Select 
CRENoteID
,ISNULL(NF.Date,'1999')Date
, Amount 
--, Day(FirstPaymentDate) PaymentDate
, CAse when  DeterminationDateReferenceDayoftheMonth = Day(Firstpaymentdate) and Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
		when   DeterminationDateReferenceDayoftheMonth = Day(Firstpaymentdate) and Day (NF.Date) > Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) 
		When DeterminationDateReferenceDayoftheMonth <> Day (Firstpaymentdate) and Day(NF.Date) <( Day(FirstPaymentDate)+ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  THEN DATEADD (Day ,(Day(FirstPaymentDate)+ ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  ,EOMONTH(NF.Date,-1) ) 
		When DeterminationDateReferenceDayoftheMonth <> Day (Firstpaymentdate) and Day(NF.Date) >=( Day(FirstPaymentDate)+ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  THEN DATEADD (Day ,Day(FirstPaymentDate)+ ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth)  ,EOMONTH(NF.Date,0) )
		
		End as NextAccrualDate



, dateAdd(m,-1, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) PreviousAccrual
, Purpose
, dateAdd(m,-2, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) PrevioustoPreviousAccrual

, dateAdd(m,1, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) NexttoNextAccrual



from NoteFundingSchedule NF
Left Join Note N on NF.CRENoteID = N.NoteID
