
CREATE procedure [dbo].[AddupdateTaskComments](	
	@TaskCommentsID uniqueidentifier,
	@TaskID uniqueidentifier ,
	@Comments nvarchar(max) ,
	@CreatedBy nvarchar(256) ,	
	@UpdatedBy nvarchar(256) ,
	@NewTaskCommentsID nvarchar(256) OUTPUT
		)    
     
AS    
BEGIN 

DECLARE @tTask TABLE (TaskCommentsID UNIQUEIDENTIFIER)

DECLARE @insertedTaskCommentsID uniqueidentifier;

INSERT INTO [App].[TaskComments]
           ([TaskID]
           ,[Comments]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	OUTPUT inserted.TaskCommentsID INTO @tTask(TaskCommentsID)
     VALUES(@TaskID,@Comments,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE())


	  SELECT @NewTaskCommentsID = TaskCommentsID FROM @tTask;

end
