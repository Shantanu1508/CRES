CREATE PROCEDURE [DW].[usp_ImportInterimDropDate]
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int

--===================================================
	
Truncate table DW.[InterimDropDateBI]

INSERT INTO DW.[InterimDropDateBI](CRENoteID,Date,Amount,NextAccrualDate,PreviousAccrual,Purpose,PrevioustoPreviousAccrual,NexttoNextAccrual)

Select CRENoteID,
Date,
Amount,
NextAccrualDate,
PreviousAccrual,
Purpose,
PrevioustoPreviousAccrual,
NexttoNextAccrual  
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

Select n.CRENoteID
,ISNULL(T.Date,'1999')Date
, Amount 

,ISNULL(T.Date,'1999')Date2

,ISNULL(T.Date,'1999')Date3

,'Balloon'
,ISNULL(T.Date,'1999')Date4
,ISNULL(T.Date,'1999')Date5


from TransactionEntry T
Inner join core.account acc on acc.accountid = T.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid
Where Type = 'Balloon' and acc.AccountTypeID = 1
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'



)W  
Where  Purpose <> 'Amortization'  
--===================================================
	

SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportInterimDropDate - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
