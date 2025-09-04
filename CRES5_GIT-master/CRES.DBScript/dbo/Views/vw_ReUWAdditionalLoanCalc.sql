-- View
      
CREATE view dbo.vw_ReUWAdditionalLoanCalc as           
(select npc.CREDealID ,npc.DealName as [Deal Name] ,npc.NoteID as [Note ID],n.Name as [Note Name], npc.PeriodEndDate as [Period End Date],          
npc.EndingBalance as [Ending Balance],npc.AllInCouponRate as [Interest Rate],          
trinterest.[Interest Paid],npc.ScheduledPrincipal as [Scheduled Principal Paid],          
(trinterest.[Interest Paid] + npc.ScheduledPrincipal)*12 as [Annualized Debt Service],      
ISNULL(n.lienposition,99999) as lienposition,       
n.[Priority]  ,  
InitialFundingAmount ,
(select [Value]+'#/dealdetail/'+npc.CREDealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl
      
from noteperiodiccalc npc          
inner join Note n on npc.NoteKey=n.Notekey           
left join(          
 select np.NoteID, EOMONTH(np.Date) monthenddate ,SUM(amount) as [Interest Paid]          
 from TransactionEntry np 




 where np.Scenario='Default'          
 and type = 'Interestpaid'          

 group by np.NoteID, EOMONTH(np.Date)           
)trinterest on npc.noteid = trinterest.noteid and npc.PeriodEndDate=trinterest.monthenddate          
where npc.Scenario='Default'          
and not npc.NoteID LIKE '%[^0-9]%'          
--and n.NoteID='10000'          
and npc.[MONTH] is not null          
--order by  npc.CREDealID,npc.NoteID,npc.PeriodEndDate           
)        

