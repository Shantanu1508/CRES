CREATE View [dbo].[InterimDropDate]
as

Select * 
from
(
Select 
CRENoteID
,ISNULL(NF.Date,'1999')Date
, Amount 


--, Day(FirstPaymentDate) PaymentDate
, CAse when  DeterminationDateReferenceDayoftheMonth = Day(Firstpaymentdate) and Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
		when   DeterminationDateReferenceDayoftheMonth = Day(Firstpaymentdate) and Day (NF.Date) >= Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) 
		when DeterminationDateReferenceDayoftheMonth <> Day (Firstpaymentdate)  and Day(FirstPaymentDate) =8 and Day([InitialInterestAccrualEndDate]) = 7 and Day (NF.Date) >= Day(FirstPaymentDate)Then DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) 
		When DeterminationDateReferenceDayoftheMonth <> Day (Firstpaymentdate) and Day(NF.Date) <( Day(FirstPaymentDate)+ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  and Day(FirstPaymentDate) =8 and Day([InitialInterestAccrualEndDate]) = 7 then DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
		When DeterminationDateReferenceDayoftheMonth <> Day (Firstpaymentdate) and Day(NF.Date) <( Day(FirstPaymentDate)+ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  THEN DATEADD (Day ,(Day(FirstPaymentDate)+ ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  ,EOMONTH(NF.Date,-1) ) 
		When DeterminationDateReferenceDayoftheMonth <> Day (Firstpaymentdate) and Day(NF.Date) >=( Day(FirstPaymentDate)+ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth))  THEN DATEADD (Day ,Day(FirstPaymentDate)+ ABS(Day(FirstPaymentDate)-DeterminationDateReferenceDayoftheMonth)  ,EOMONTH(NF.Date,0) )
		
		End as NextAccrualDate



, dateAdd(m,-1, 
CAse 
--When Day(NF.Date) between 1 and 8
--THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-2) )
when Day (NF.Date) < Day([InitialInterestAccrualEndDate]) 
THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) PreviousAccrual


, Purpose
, dateAdd(m,-2, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) PrevioustoPreviousAccrual

, dateAdd(m,1, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) NexttoNextAccrual


from NoteFundingSchedule NF
Left Join Note N on NF.CRENoteID = N.NoteID

--Where Maturity_DateBI > GETDATE() 

Union All

Select NoteID
,ISNULL(T.Date,'1999')Date
, Amount 

,ISNULL(T.Date,'1999')Date2

,ISNULL(T.Date,'1999')Date3

,'Balloon'
,ISNULL(T.Date,'1999')Date4
,ISNULL(T.Date,'1999')Date5


from TransactionEntry T
Where Type = 'Balloon' 
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and T.AccountTypeID = 1

)W

Where
 Purpose <> 'Amortization'
--and Crenoteid = '7218'
--order by Date
