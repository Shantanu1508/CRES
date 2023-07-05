-- Procedure
CREATE PROCEDURE [dbo].[usp_DeleteExceptionByobjectIDByFieldName] 
 @ObjectID [uniqueidentifier], 
 @ObjectName nvarchar(256),
  @FieldName [nvarchar](256) 
AS
BEGIN

SET NOCOUNT ON;


Delete from core.Exceptions  
 where ObjectID=@ObjectID and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME=@ObjectName ) and FieldName= @FieldName


END





