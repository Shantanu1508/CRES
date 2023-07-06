-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================   
CREATE PROCEDURE [dbo].[usp_AddUpdateTask] 
(   
		@TaskID  nvarchar(256), 		 
		@Priority int,
		@TaskType int,
		@Status int,
		@Summary  nvarchar(max), 
		@Description nvarchar(max), 
		@CategoryTag  nvarchar(256), 
		@SubCategoryTag nvarchar(256),
		@StartDate  datetime,
		@DeadlineDate  datetime,
		@AssignedTo nvarchar(256),
		@EstimatedCompletionDate  datetime,
		@ActualCompletionDate  datetime,
		@Tag1 nvarchar(256),
		@Tag2 nvarchar(256),
		@Tag3 nvarchar(256),
		@UpdatedBy nvarchar(256),
		@NewTaskID nvarchar(256) OUTPUT
)    
     
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    

Declare @NotificationID UNIQUEIDENTIFIER;


IF (@TaskID='00000000-0000-0000-0000-000000000000' and(@AssignedTo is null or @AssignedTo='' ))
BEGIN
	set @AssignedTo = (select UserId  from app.TaskDefaultConfig where TaskTypeID=@TaskType)	 	
END 

	update App.Task   
	set [Priority]	 = 	@Priority	 ,
	TaskType	 = 	@TaskType	 ,
	[Status]	 = 	@Status	 ,
	Summary	 = 	@Summary	 ,
	[Description]	 = 	@Description	 ,
	CategoryTag	 = 	@CategoryTag	 ,
	SubCategoryTag	 = 	@SubCategoryTag	 ,
	StartDate	 = 	@StartDate	 ,
	DeadlineDate	 = 	@DeadlineDate	 ,
	AssignedTo	 = 	@AssignedTo	 ,
	EstimatedCompletionDate	 = 	@EstimatedCompletionDate	 ,
	ActualCompletionDate	 = 	@ActualCompletionDate	 ,
	Tag1	 = 	@Tag1	 ,
	Tag2	 = 	@Tag2	 ,
	Tag3	 = 	@Tag3	 ,
	UpdatedBy	 = 	@UpdatedBy	 ,
	UpdatedDate	 = 	getdate()	 	    
	where TaskID=@TaskID   

IF @@ROWCOUNT =0   
   begin
   DECLARE @ttask TABLE (tNewtaskId UNIQUEIDENTIFIER)
    Insert into App.Task
    (    
	     
[Priority],
TaskType,
[Status],
Summary,
[Description],
CategoryTag,
SubCategoryTag,
StartDate,
DeadlineDate,
AssignedTo, 
EstimatedCompletionDate,
ActualCompletionDate,
Tag1,
Tag2,
Tag3,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate
  
    )      
   OUTPUT inserted.TaskID INTO @ttask(tNewtaskId)    
    values    
    (    
 
			@Priority	 ,
			@TaskType	 ,
			@Status	 ,
			@Summary	 ,
			@Description	 ,
			@CategoryTag	 ,
			@SubCategoryTag	 ,
			@StartDate	 ,
			@DeadlineDate	 ,
			@AssignedTo	 ,
			@EstimatedCompletionDate	 ,
			@ActualCompletionDate	 ,
			@Tag1	 ,
			@Tag2	 ,
			@Tag3	 ,
			@UpdatedBy ,    
			getdate(),    
			@UpdatedBy,    
			getdate()    
     )    
	  


	 


	 SELECT @NewTaskID = tNewtaskId FROM @ttask;
	 Exec [dbo].[usp_InsertUserNotification]  @UpdatedBy,'AddTask',@NewTaskID

	 IF NOT EXISTS(Select UserID from App.TaskSubscribedUser where UserID = @AssignedTo and TaskID = @NewTaskID)
	 BEGIN
		Insert into App.TaskSubscribedUser([TaskID],[UserId],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)      
		values(@NewTaskID,@AssignedTo,@UpdatedBy ,getdate(),@UpdatedBy,getdate())    
	 END


  END
  ELSE
  BEGIN

		

		Exec [dbo].[usp_InsertUserNotification]  @UpdatedBy,'EditTask',@TaskID

		IF NOT EXISTS(Select UserID from App.TaskSubscribedUser where UserID = @AssignedTo and TaskID = @TaskID)
		BEGIN
			Insert into App.TaskSubscribedUser([TaskID],[UserId],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)      
			values(@TaskID,@AssignedTo,@UpdatedBy ,getdate(),@UpdatedBy,getdate())    
		END
			
  END
END 

 
