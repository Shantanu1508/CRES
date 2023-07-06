-- Procedure

Create PROCEDURE [dbo].[usp_InsertExceptionsByFieldName] 
 @TableTypeExceptions [TableTypeExceptions] READONLY,
 @FieldName [nvarchar](256) ,
 @UserName [nvarchar](256) 
 
AS
BEGIN

 DECLARE @UserID nvarchar(256);
DECLARE @ObjectID UNIQUEIDENTIFIER, 
 @existingId UNIQUEIDENTIFIER;
 
 

 

 SEt @UserID = (Select top 1 UserID from App.[User] where [login] = @UserName)

IF CURSOR_STATUS('global','CursorExceptions')>=-1    
BEGIN    
DEALLOCATE CursorExceptions    
END    
 
DECLARE CursorExceptions CURSOR     
FOR    
(    
	Select DISTINCT ObjectID from @TableTypeExceptions ex
)
OPEN CursorExceptions     
FETCH NEXT FROM CursorExceptions    
INTO @ObjectID
WHILE @@FETCH_STATUS = 0    
BEGIN 

Delete from core.Exceptions where ObjectID=@ObjectID and FieldName = @FieldName

INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
 select 
 ObjectID 
 ,lObjectType.LookupID 
 ,FieldName
 ,Summary
 ,lActionLevel.LookupID 
 ,@UserID
 ,GETDATE()
 ,@UserID
 ,GETDATE()
from @TableTypeExceptions ex
left join core.Lookup lObjectType on ex.ObjectTypeText =lObjectType.Name 
left join core.Lookup lActionLevel on ex.ActionLevelText =lActionLevel.Name 


FETCH NEXT FROM CursorExceptions   
INTO @ObjectID

END  

END


