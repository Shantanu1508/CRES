CREATE View [dbo].[Paydown_PaymentDate]
As
Select
D.DealName
, Status
,Noteid
, Purpose
, Date
, Amount  
, NonHolidayPymtDate = Case when Day(NF.Date) <  8 Then DateADD (d, 8,Eomonth (NF.Date,-1))
	

		Else  DateAdd (Day,8,EOMONTH (Date, 0)) End

, FirstPaymentDate

from NoteFundingSchedule NF
Inner Join Note N On NF.CRENoteID =  N.NoteID
inner join Deal D on D.DealKey =  N.DealKey

where 
--Maturity_DateBI > getdate() 
Amount< 0 and Status <> 'Inactive' 
--and Date < Getdate()
--and Noteid = '11394'
