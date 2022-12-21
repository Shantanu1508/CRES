-- Procedure
-- Procedure


CREATE PROCEDURE Get_AmortLessThanFinalProjection
as
Begin
Truncate table AmortLessThanFinalProjection
Insert into AmortLessThanFinalProjection

Select 
T.DealName
, NoteID
, SUM(Amount)PrincipalTransactionsExcludeScheduleAmort
, SUM(Scheduleprincpal )Scheduleprincpal
, SUM(Amount)+SUM(Scheduleprincpal )SchedulePrincipal_Plus_RestofPrincipalTransactions
,ProjectedfullPayoff
from Transactionentry T
Outer apply (Select DealName,  creNoteid, MiniAutoAspreadStartDate, Scheduleprincpal ,ProjectedfullPayoff
				from SumofScehduleprincipalUntilMinAutospreaddate s
			where T.noteid = s.crenoteid and T.date= s.MiniAutoAspreadStartDate
			)x
where Type in ('InitialFundingamount', 'FundingorRepayment', 'PKPrincipalFunding', 'PIKPrincipalPaid')
and Scenario = 'Default' and T.Date = x.MiniAutoAspreadStartDate
--and T.Dealname = 'Crossroads'
Group by NoteID, T.DealName,ProjectedfullPayoff

end