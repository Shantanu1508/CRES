
Create View SourceDateDuedateCount
as
Select [Note ID], [Due Date], Count(*) DueDateCount from [dbo].[Sheet1$] S
group by[Note ID], [Due Date]
Having Count(*)>1