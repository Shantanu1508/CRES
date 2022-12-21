
--[dbo].usp_GetTaskCommentsByTaskId '4fe83916-c7cc-4647-8c47-0b5270ac1a68' ,'','All'  
CREATE procedure [dbo].[usp_GetTaskCommentsByTaskId](  
@UerID UNIQUEIDENTIFIER,  
@Taskid nvarchar(256),  
@currentTime nvarchar(50),  
@CommentType nvarchar(50))  
  
as  
--declare @CommentType nvarchar(50)  
if(@CommentType='All')  
Begin  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
Begin SELECT * FROM   
(select comment.TaskCommentsID  
   ,comment.TaskID  
           ,comment.Comments  
           ,comment.CreatedBy  
           ,comment.CreatedDate  
           ,comment.UpdatedBy  
           ,comment.UpdatedDate   
    ,us.FirstName + ' ' + us.LastName as AssignedToText  
     ,LEFT(us.FirstName, 1) + LEFT(us.LastName , 1)  as CommentedByFirstLetter  
     ,CASE when (cast(comment.[UpdatedDate] as date)< cast(GETDate() as date)) Then   format(comment.UpdatedDate,'MM/dd/yy hh:mm tt')   
   else  
   dbo.ufn_GetUserNotificationTime(@currentTime,comment.CreatedDate)---  format(un.UpdatedDate,'hh:mm tt')   
   end 'Modified'  
   ,'avatorcircle dbcontenticon ' + userex.Color UColor   
 --,(select 'avatorcircle dbcontenticon ' + Color from [APP].[UserEx]  where userid=comment.[UpdatedBy] ) UColor  
   --, ' commented on '  +CAST(task.TaskAutoID  AS varchar(50)) + ' ' + task.Summary 'TaskSummary'  
   , ' commented on ' as 'TaskSummary'  
 ,'' ActivityMessage  
 ,'' as activitycolor  
 ,'' as activityuserfirstletter    
 from [App].[TaskComments] comment  
 inner JOin [App].[Task] task on comment.TaskID=task.TaskID  
 left join Core.Lookup p on task.Priority = p.LookupID  
    left join app.[User] us on comment.UpdatedBy = us.UserID  
 left join Core.Lookup t on task.TaskType = t.LookupID  
 left join APP.UserEx userex on userex.UserID=comment.UpdatedBy  
 where comment.taskid=@Taskid  
  UNION  
  select  '00000000-0000-0000-0000-000000000000' AS  'TaskCommentsID'  
   , ACT.TaskID  
           ,'' AS Comments  
           ,ACT.CreatedBy  
           ,ACT.CreatedDate  
           ,ACT.UpdatedBy  
           ,ACT.UpdatedDate   
     ,us.FirstName + ' ' + us.LastName as AssignedToText  
   --  ,(select [FirstName] + ' ' + LastName from App.[User] where UserId = ACT.[UpdatedBy]) as AssignedToText  
     ,'' AS CommentedByFirstLetter  
     ,'' AS  Modified    
     ,'' AS UColor  
     , '' AS TaskSummary    
     , aCT.Displaymessage + ' - '   + format(ACT.UpdatedDate,'MM/dd/yy hh:mm tt') as 'ActivityMessage'  
     ,(select 'avatorcircle dbcontenticon ' + Color from [APP].[UserEx]  where userid=act.[UpdatedBy] ) activitycolor  
    ,LEFT(us.FirstName, 1) + LEFT(us.LastName , 1)  as CommentedByFirstLetter      
     FROM [App].[TaskActivity] ACT  
     left join App.[User] us on us.UserID = ACT.updatedby  
      left join APP.UserEx userex on userex.UserID=ACT.UpdatedBy  
     where ACT.TaskID=@Taskid  
     ) ad order by ad.UpdatedDate  
 END  
  
  
if(@CommentType='Comment')  
BEGIN  
 select comment.TaskCommentsID  
   ,comment.TaskID  
           ,comment.Comments  
           ,comment.CreatedBy  
           ,comment.CreatedDate  
           ,comment.UpdatedBy  
           ,comment.UpdatedDate   
    ,us.FirstName + ' ' + us.LastName as AssignedToText  
     ,LEFT(us.FirstName, 1) + LEFT(us.LastName , 1)  as CommentedByFirstLetter  
     ,CASE when (cast(comment.[UpdatedDate] as date)< cast(GETDate() as date)) Then   format(comment.UpdatedDate,'MM/dd/yy hh:mm tt')   
   else  
   dbo.ufn_GetUserNotificationTime(@currentTime,comment.CreatedDate)---  format(un.UpdatedDate,'hh:mm tt')   
   end 'Modified'  
 ,(select 'avatorcircle dbcontenticon ' + Color from [APP].[UserEx] ue  where ue.userid=comment.[UpdatedBy] ) UColor  
--, ' commented on '  +CAST(task.TaskAutoID  AS varchar(50)) + ' ' + task.Summary 'TaskSummary'  
 , ' commented on ' as 'TaskSummary'  
 ,'' ActivityMessage  
 ,'' as activitycolor  
 ,'' as activityuserfirstletter   
 from [App].[TaskComments] comment  
 inner JOin [App].[Task] task on comment.TaskID=task.TaskID  
 left join Core.Lookup p on task.Priority = p.LookupID  
   left join app.[User] us on comment.UpdatedBy = us.UserID  
 left join Core.Lookup t on task.TaskType = t.LookupID  
 where comment.taskid=@Taskid  
 Order By comment.UpdatedDate  
  
END  
  
  
if(@CommentType='Activity')  
BEGIN  
select    
    ACT.TaskID            
           ,ACT.CreatedBy  
           ,ACT.CreatedDate  
           ,ACT.UpdatedBy  
           ,ACT.UpdatedDate   
     ,(select [FirstName] + ' ' + LastName from App.[User] where UserId = ACT.[UpdatedBy]) as AssignedToText      
     , aCT.Displaymessage + ' - '   + format(ACT.UpdatedDate,'MM/dd/yy hh:mm tt') as 'ActivityMessage'  
     ,(select 'avatorcircle dbcontenticon ' + Color from [APP].[UserEx] ue  where ue.userid=act.[UpdatedBy] ) activitycolor  
    ,LEFT(us.FirstName, 1) + LEFT(us.LastName , 1)  as CommentedByFirstLetter      
     FROM [App].[TaskActivity] ACT  
     left join App.[User] us on us.UserID = ACT.updatedby  
     where ACT.TaskID=@Taskid  
END  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
