

CREATE view [dbo].[Exception]
as 

select 
[ObjectID] as NoteKey,
[FieldName],
[summary],
[ActionLevelID] as ExceptionPriority,
[ActionLevelBI] as ExceptionPriorityBI,
E.[UpdatedDate] as ExceptionDate ,
CreNoteid

From [DW].[ExceptionsBI] E
Left Join cre.Note N on N.NoteId = E.[ObjectID]
where [ObjectTypeBI] = 'Note'




