-- View
CREATE View [dbo].[SumofScehduleprincipalUntilMinAutospreaddate]
AS
Select 
NF.DealName
, creNoteid
,Min(y.Date)MiniAutoAspreadStartDate
,SUM(x.Amount) Scheduleprincpal 
,ProjectedfullPayoff = Case when Crenoteid in (Select distinct Crenoteid from NoteFundingSchedule NF 
						Where Purpose = 'Full Payoff' and wireConfirm = 0) Then 'Projected Full Payoff' else 'No Projected Full Payoff' end

from NoteFundingSchedule NF
Cross Apply (Select Noteid, SUM(Amount)Amount from TransactionEntry T
				Where Type = 'Scheduledprincipalpaid' and Scenario = 'Default'
				--and Noteid = '8626'
				and T.NoteID= NF.CRENoteID 
				--and T.date<=NF.Date 
				and T.AccountTypeID = 1
				group by Noteid
				)x

Cross Apply (Select Noteid, Min(Date)Date from NoteFundingSchedule NF1
				
				where NF1.CRENoteID= NF.CRENoteID and  NF1.Wireconfirm = 0
				--and T.date<=NF.Date 
				group by NF1.CRENoteID 
				)y


where purpose in( 'Paydown', 'Full Payoff')
--and wireConfirm = 0
and NF.CRENoteid not in (Select Crenoteid from RepaymentnegativeBalAnalysisTable
						where ScheduledPrincipal is not NULL)
--and NF.Crenoteid not in (Select Distinct CREnoteid from
--						(Select  creNoteid
--						--, Min(Y.Date)MiniAutoAspreadStartDate 
--						from NoteFundingSchedule NF2
--						Cross Apply (Select* from TransactionEntry T
--						Where Type = 'Scheduledprincipalpaid' and Scenario = 'Default'
--						and T.NoteID= NF.CRENoteID and T.date>NF.Date )x
--						where purpose in( 'Paydown') and wireconfirm=0
--						group by NF2.creNoteid
--						)x
--		)
--and Dealname = 'Doubletree Myrtle Beach'
group by creNoteid,NF.Dealname