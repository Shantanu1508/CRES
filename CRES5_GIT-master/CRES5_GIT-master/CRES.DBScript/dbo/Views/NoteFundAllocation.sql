create view dbo.NoteFundAllocation
as 
select CRENoteID as NoteID,Isnull(FundName,'None') Fund, isnull(PctAllocation,1) as AllocationPct,c.[ClientName] as Client
from CRE.Note n 
left outer join CRE.NoteFundAllocation ne on n.Noteid=ne.noteid
left outer join CRE.Fund e on ne.Fundid=e.Fundid
left outer join CRE.Client c on n.clientid=e.clientid
