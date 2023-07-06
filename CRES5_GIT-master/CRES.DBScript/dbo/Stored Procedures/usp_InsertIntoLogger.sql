CREATE PROCEDURE [dbo].[usp_InsertIntoLogger]
(   
        @Severity nvarchar(50),
		@Module varchar(50), 
		@Message varchar(256) ,
		@Message_StackTrace varchar(max) ,
		@Priority varchar(50), 
		@ExceptionSource varchar(50), 
		@MethodName  varchar(100) ,
		@RequestText   varchar(max) ,
		@ObjectID   varchar(max) ,
		@CreatedBy varchar(256) 
	 
 )
AS  
BEGIN  
    SET NOCOUNT ON; 

  INSERT INTO [App].[Logger]
           (
		    [Severity]
           ,[Module]
           ,[Message]
           ,[Message_StackTrace]
           ,[Priority]
           ,[ExceptionSource]
           ,[MethodName]
           ,[RequestText]
           ,[ObjectID]
           ,[CreatedBy]
           ,[CreatedDate]
		   )
     VALUES
           (
		    @Severity
           ,@Module
           ,@Message
           ,@Message_StackTrace
           ,@Priority
           ,@ExceptionSource
           ,@MethodName
           ,@RequestText
           ,@ObjectID
           ,@CreatedBy
           ,GETDATE()
		   
		   )
END
