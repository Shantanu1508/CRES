
CREATE PROCEDURE [dbo].[usp_GetExceptionsByObjectID] --'cac89d40-3994-46a2-8d8f-3bdfd6003592','Note'
 @ObjectID [uniqueidentifier], 
 @ObjectName nvarchar(256)
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select ac.Name
,n.CRENoteID
,exc.[ObjectID]
,exc.[ObjectTypeID]
,exc.FieldName
,exc.[Summary]
,lActionLevel.Name ActionLevelText
,exc.[CreatedBy]
,exc.[CreatedDate]
,exc.[UpdatedBy]
,exc.[UpdatedDate]
from core.Exceptions exc
Inner join cre.Note n on n.noteID=exc.ObjectID
 INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID 
 where ObjectID=@ObjectID and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME=@ObjectName ) and ac.isdeleted=0

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END





