CREATE PROCEDURE [dbo].[usp_InsertErrorLogFromDB] --'ExportFutureFunding','error string','C35AB502-1C33-4428-9CAD-8F53E7B53E6F','C35AB502-1C33-4428-9CAD-8F53E7B53E6F'  
(     
        @Module varchar(50),   
        @Message_StackTrace varchar(max) ,   
   @ObjectID   varchar(max) ,  
  @MethodName  varchar(100),   
  @CreatedBy varchar(256)   
    
 )  
AS    
BEGIN    
    SET NOCOUNT ON;   
  
  INSERT INTO [App].[Logger]  
           (  
      [Severity]  
           ,[Module]           
           ,[Message_StackTrace]  
           ,[Priority]  
           ,[ExceptionSource]         
           ,[ObjectID]  
     ,MethodName  
           ,[CreatedBy]  
           ,[CreatedDate]  
     )  
     VALUES  
           (  
      'Error'  
           ,@Module            
           ,@Message_StackTrace  
           ,'High'  
           ,'DataBase'             
           ,@ObjectID  
     ,@MethodName  
           ,@CreatedBy  
           ,GETDATE()  
       
     )  
END