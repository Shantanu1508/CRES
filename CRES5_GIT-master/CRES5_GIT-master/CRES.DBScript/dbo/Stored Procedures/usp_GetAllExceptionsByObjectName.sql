
CREATE PROCEDURE [dbo].[usp_GetAllExceptionsByObjectName] 
  @ObjectName nvarchar(256),
  @PgeIndex INT,
  @PageSize INT,
  @TotalCount INT OUTPUT 
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  --set @TotalCount =(select distinct COUNT(ObjectID) FROM CORE.Exceptions where ActionLevelID = 293 and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='Note' ));
  set @TotalCount =(select distinct COUNT(ObjectID) FROM CORE.Exceptions where (ActionLevelID = 293 or ActionLevelID=294) and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='Note' ));

/*
select 
 distinct 
 exc.[ObjectID] as ObjectID
,n.CRENoteID as CRENoteID
,count(exc.[ObjectID]) as CountException
 ,ac.Name as Name
--,exc.[ObjectTypeID] as ObjectTypeID
--,exc.FieldName as FieldName
--,exc.[Summary] as Summary
--,lActionLevel.Name ActionLevelText
--,exc.[CreatedBy] as CreatedBy
--,exc.[CreatedDate] as CreatedDate
--,exc.[UpdatedBy] as UpdatedBy
,exc.[UpdatedDate] as UpdatedDate
from core.Exceptions exc
Inner join cre.Note n on n.noteID=exc.ObjectID
INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID
where ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME=@ObjectName ) and ac.IsDeleted=0 and exc.ActionLevelID = 293
group by exc.[ObjectID],
n.CRENoteID,exc.[UpdatedDate],ac.Name
ORDER BY exc.UpdatedDate DESC
*/


select distinct 
exc.[ObjectID] as ObjectID
,n.CRENoteID as CRENoteID
 ,ac.Name as Name
 ,exc.[Summary] as Summary
,lActionLevel.Name ActionLevelText
 ,(select max([UpdatedDate]) from core.Exceptions where ObjectID=exc.ObjectID) as UpdatedDate
 ,d.DealName
 ,d.DealID
 ,d.CREDealID
from  core.Exceptions exc 
Inner join cre.Note n on n.noteID=exc.ObjectID
left join cre.Deal d on d.DealID = n.DealID
INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID
where ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='note' ) 
and ac.IsDeleted=0 
and (exc.ActionLevelID = 293 or exc.ActionLevelID=294)
and ac.statusid <> 2
--where ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='note' ) and ac.IsDeleted=0 and (exc.ActionLevelID = 293 )
--) tbl order by UpdatedDate desc
ORDER BY ActionLevelText,UpdatedDate DESC

OFFSET (@PgeIndex - 1)*@PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END










