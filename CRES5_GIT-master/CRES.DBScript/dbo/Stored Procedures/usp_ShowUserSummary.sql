
CREATE PROCEDURE [dbo].[usp_ShowUserSummary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
     select (CASE When EXISTS (SELECT 1 WHERE deal.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
THEN (Select FirstName + ' ' + LastName from app.[user] where Userid = deal.UpdatedBy)
ELSE deal.UpdatedBy END) as UserName,count(deal.UpdatedDate)as [Count],'Deal' As [Type]
from CRE.Deal deal
where  deal.UpdatedDate >= cast(dateadd(day, -1, getdate()) as date)
GROUP BY  deal.UpdatedBy

union all

select (CASE When EXISTS (SELECT 1 WHERE note.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
THEN (Select FirstName + ' ' + LastName from app.[user] where Userid = note.UpdatedBy)
ELSE note.UpdatedBy END) as UserName,count(note.UpdatedDate) as [Count],'Note' as [Type]
from CRE.Note note
where  note.UpdatedDate >= cast(dateadd(day, -1, getdate()) as date)
GROUP BY  note.UpdatedBy



 
END


