--exec [dbo].[usp_GetRecentAskedQuestionByUserID]  '324f479b-aaa5-461a-b8a4-54ef9d405a5f' 


CREATE PROCEDURE [dbo].[usp_GetRecentAskedQuestionByUserID]  --'324f479b-aaa5-461a-b8a4-54ef9d405a5f' 
(
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON;

Select top 5 ChatLogID,Status,ParentId,IntentName,Question,SentBy,CreatedDate
From(
	Select * ,ROW_NUMBER() over(Partition by a.parentid order by a.ChatLogID,a.CreatedDate desc) rno
	from(
		Select Distinct ChatLogID,Status,
		ISNULL(cl.ParentId,ChatLogID) as  ParentId,ISNULL(cl.IntentName,tblIntents.IntentName) as IntentName,Question,SentBy ,CreatedDate
		from hbot.chatlog cl

		left join(
			Select ISNULL(ParentId,ChatLogID) as  ParentId,IntentName
			from hbot.chatlog 
			where CreatedBy = @UserID
			and IntentName is not null
			and Question not like 'Session end%'
		)tblIntents on tblIntents.ParentId = cl.ChatLogID

		where CreatedBy = @UserID
		and Question not like 'Session end%'
		and SentBy = 'user'
	)a
)z
where z.rno = 1
order by z.CreatedDate desc


END
