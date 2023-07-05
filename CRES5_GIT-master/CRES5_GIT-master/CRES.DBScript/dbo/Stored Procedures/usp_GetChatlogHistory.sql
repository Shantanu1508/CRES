--  [dbo].[usp_GetChatlogHistory]  '76226BCD-6051-402E-A2C4-ED8E52180B86',1,1
CREATE PROCEDURE [dbo].[usp_GetChatlogHistory] 
(
	@UserID UNIQUEIDENTIFIER,
	@PageIndex int,
	@PageSize int
)
AS
BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

 CREATE TABLE #tempbottable(
				chatlogid int,
				[status] nvarchar(256),
				Question nvarchar(max),
				CreatedBy  nvarchar(256) ,
				CreatedDate datetime,
				ParentId int,
				IntentName  nvarchar(256),
				SentBy  nvarchar(256)
				)


	Insert INTO #tempbottable (chatlogid,[status],Question,CreatedBy,CreatedDate,ParentId,IntentName,SentBy)
	SELECT top 100 chatlogid,[status],Question,CreatedBy,CreatedDate,ParentId,IntentName,SentBy 
	FROM [Hbot].[ChatLog]  
	where CreatedBy= @UserID
	and Question <>'Session end.'
	--and chatlogid not in(select chatlogid 
	--					 from(
	--							select chatlogid, ISNULL(ParentID,ChatlogID) as ParentID, sum(cnt) over(partition by parentid order by parentid) as finalcnt
	--							FROM(
	--								select chatlogid, ISNULL(ParentID,ChatlogID) as ParentID,status,ROW_NUMBER() over(partition by chatlogid order by parentid) as cnt
	--								from hbot.chatlog 
	--							    where ISNULL(ParentID,ChatlogID) in(select  distinct ISNULL(ParentID,ChatlogID) as ParentID 
	--																	from hbot.chatlog 
	--																	where createdby=@UserID
	--																	and status in(5) 
	--																	) 
	--								and createdby =@UserID
	--								)z
	--							group by chatlogid, parentid,cnt
	--							)t where finalcnt = 2
	--					)
	order by CreatedDate desc

	   

   SELECT  nullif(Status,'') as status,
   Question as Speech,
   SentBy as sentBy
   ,(SELECT [dbo].[ufn_GetTextByDate](CreatedDate,@UserID)) as DateText
   ,(SELECT [dbo].[ufn_GetTimeByTimeZone](CreatedDate,@UserID)) as DisplayDate
   ,stuff(right(Convert(nvarchar(256),[dbo].[ufn_GetTimeByTimeZone](CreatedDate,@UserID),109),15),7,7,' ') as DisplayTime
   ,ISNULL(ParentId,Chatlogid) as ParentId 
   ,chatlogid
   from #tempbottable  order by DisplayTime desc
  
  
    
	drop table  #tempbottable
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
