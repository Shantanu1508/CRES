    
-- View    
CREATE view dbo.Payoffdate    
as    
Select     
Dealname  ,n1.notekey  
,n1.Noteid, N1.ActualPayoffdate    
,n1.Fullyextendedmaturitydate     
,PayoffDate= ISNULL(ISNULL(n1.ActualPayoffDate,x.Date),FullyExtendedMaturitydate)    
    
from Note N1    
 Inner join deal d on d.dealkey = n1.dealkey    
outer apply    
(Select N.Noteid, NS.Date from NoteFundingSchedule NS    
 inner  join Note n on n.noteid = ns.CRENoteID    
    
 Where Purpose  = 'Full Payoff'    
 and Date < ISNULL(ActualPayoffdate, FullyExtendedMaturityDate)    and Date <= getdate()
 and n1.noteid = n.noteid    
 )X