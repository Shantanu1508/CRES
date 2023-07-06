
CREATE PROCEDURE [dbo].[usp_DeleteExceptionByobjectID] 
 @ObjectID [uniqueidentifier], 
 @ObjectName nvarchar(256)
AS
BEGIN

SET NOCOUNT ON;


Delete from core.Exceptions  
 where ObjectID=@ObjectID and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME=@ObjectName )


END





