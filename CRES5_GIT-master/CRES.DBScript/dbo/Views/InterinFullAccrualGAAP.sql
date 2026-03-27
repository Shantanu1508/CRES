CREATE View [dbo].[InterinFullAccrualGAAP]
as

Select * from
(
Select 
CRENoteID
,ISNULL(NF.Date,'1999')Date
, Amount 
--, Day(FirstPaymentDate) PaymentDate
, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End as NextAccrualDate


, dateAdd(m,-1, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) PreviousAccrual
, Purpose
, dateAdd(m,-2, CAse when Day (NF.Date) < Day(FirstPaymentDate) THEN DATEADD (Day ,Day(FirstPaymentDate) ,EOMONTH(NF.Date,-1) )
Else DATEADD (Day ,Day(FirstPaymentDate) , EOMONTH(NF.Date,0) ) End) PrevioustoPreviousAccrual
from NoteFundingSchedule NF
Left Join Note N on NF.CRENoteID = N.NoteID
--Where Maturity_DateBI > GETDATE() 

Union

Select NoteID
,ISNULL(T.Date,'1999')Date
, Amount 

,ISNULL(T.Date,'1999')Date2

,ISNULL(T.Date,'1999')Date3
,'Balloon'
,ISNULL(T.Date,'1999')Date4



from TransactionEntry T
Where Type = 'Balloon' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and T.AccountTypeID = 1

)W


