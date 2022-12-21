
Create PROCEDURE [dbo].[usp_InsertUpdateExceptions] 
@TableTypeExceptions [TableTypeExceptions] READONLY,
 @CreatedBy [nvarchar](256) ,
 @UpdatedBy [nvarchar](256) 
AS
BEGIN	 
DECLARE @ObjectID UNIQUEIDENTIFIER, 
@existingId UNIQUEIDENTIFIER;
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
Delete from core.Exceptions where ObjectID=@ObjectID;

INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
 select 
 ObjectID 
 ,lObjectType.LookupID 
 ,FieldName
 ,Summary
 ,lActionLevel.LookupID 
 ,@CreatedBy
 ,GETDATE()
 ,@CreatedBy
 ,GETDATE()
from @TableTypeExceptions ex
left join core.Lookup lObjectType on ex.ObjectTypeText =lObjectType.Name 
left join core.Lookup lActionLevel on ex.ActionLevelText =lActionLevel.Name 


FETCH NEXT FROM CursorExceptions   
INTO @ObjectID

END  

END


