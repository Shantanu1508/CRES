Create View CommitTablePrepayBaloon  
as  
Select N1.Noteid, SUM(Value)Value from [CRE].[NoteAdjustedCommitmentDetail] N  
Inner join Note N1 on N.Noteid = N1.Notekey  
where Type = 638  
Group by N1.Noteid