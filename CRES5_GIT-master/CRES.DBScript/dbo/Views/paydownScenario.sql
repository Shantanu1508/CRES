CREATE View [dbo].[paydownScenario]
as
Select * from
(

Select 
CRENoteID
, date Repaymentdate
, NextAccrualDate
,   isweekend
, isholidaybi
, date1  as PaymentDate
, Amount
from [paydownScenrioPaymentDate] p
left join Note N1 on P.CRENoteID =  N1.NoteID
outer apply (Select isholidayBi, isholiday, isweekend, 
					date1 = Case when isholidayBI = 0 and IsWeekend = 0 then c.date 
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Saturday' Then DateAdd(Day, -1, c.Date)
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Sunday' Then DateAdd(Day, -2, c.Date)
					When isholidayBI = 1 and IsWeekend = 0 and DateName(Dw,DateAdd(Day, -1, c.Date)) = 'Sunday' Then DateAdd(Day, -3, c.Date)
						end 
				from CalendarBI C
			 where P.NextAccrualDate =  C.Date  
			 )X
			

union

Select 
n.Noteid
,T.Date
,''
,   isweekend
, isholidaybi

,date2 = Case when isholidayBI = 0 and IsWeekend = 0 then C1.date 
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, C1.Date)= 'Saturday' Then DateAdd(Day, -1, C1.Date)
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, c1.Date)= 'Sunday' Then DateAdd(Day, -2, C1.Date)
					When isholidayBI = 1 and IsWeekend = 0 and DateName(Dw,DateAdd(Day, -1, C1.Date)) = 'Sunday' Then DateAdd(Day, -3, C1.Date)
						end  
	,Amount*-1					
				from Note N
			 inner Join CalendarBI C1 on N.FullyExtendedMaturityDate = C1.date
			 Left Join Transactionentry T on T.NoteID =  N.NoteID and T.AccountTypeID = 1

			 where Type = 'Balloon'
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and T.AccountTypeID = 1

			 )A
			


