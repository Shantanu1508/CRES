
CREATE PROCEDURE [dbo].[usp_GetTaskByTaskID] -- '002eb61c-e1ba-477b-a3f1-ab6c16fc63f3'
    @TaskID nvarchar(256)
    
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
     
	 select
	   [TaskID]
      ,[TaskAutoID]
      ,[Priority]
	   ,p.name as PriorityText
      ,[TaskType]
	  ,t.Name as TaskTypeText
      ,[Status]
	  ,s.Name as StatusText
      ,[Summary]
      ,[Description]
      ,[CategoryTag]
      ,[SubCategoryTag]
      ,[StartDate]
      ,[DeadlineDate]
      ,[AssignedTo]
	  ,us.FirstName +' ' +us.LastName as AssignedToText
      ,[EstimatedCompletionDate]
      ,[ActualCompletionDate]
      ,[Tag1]
      ,[Tag2]
      ,[Tag3]
      ,c.FirstName +' ' +c.LastName as [CreatedBy]
      ,task.[CreatedDate]
      ,u.FirstName +' ' +u.LastName as [UpdatedBy]
      ,task.[UpdatedDate]
      ,[ParentTaskID]
  FROM [App].[Task] task
  left join Core.Lookup p on task.Priority = p.LookupID
  left join Core.Lookup s on task.Status = s.LookupID
  left join Core.Lookup t on task.TaskType = t.LookupID
  left join app.[User] us on task.AssignedTo = us.UserID
  left join app.[User] c on task.CreatedBy = c.UserID
  left join app.[User] u on task.UpdatedBy = u.UserID
  where task.TaskID=@TaskID
  	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    
END      


