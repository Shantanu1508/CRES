CREATE view dbo.NoteEntityAllocation
as 
select CRENoteID as NoteID,Isnull(EntityName,'None') EntityName, isnull(PctAllocation,1) as AllocationPct,c.[ClientName] as Client
from CRE.Note n 
left outer join CRE.NoteEntityAllocation ne on n.Noteid=ne.noteid
left outer join CRE.Entity e on ne.Entityid=e.entityid
left outer join CRE.Client c on c.clientid=e.clientid
