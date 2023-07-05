  
  
CREATE PROCEDURE [DW].[usp_MergeExceptionsBI]  
@BatchLogId int  
AS  
BEGIN  
  
SET NOCOUNT ON  
  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
  
UPDATE [DW].BatchDetail  
SET  
BITableName = 'ExceptionsBI',  
BIStartTime = GETDATE()  
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_ExceptionsBI'  
  
  
TRUNCATE TABLE  [DW].[ExceptionsBI]  
  
INSERT INTO [DW].[ExceptionsBI]  
 (  
  [ExceptionID],  
  [ObjectID],  
  [ObjectTypeID],  
  [ObjectTypeBI],  
  [FieldName],  
  [Summary],  
  [ActionLevelID],  
  [ActionLevelBI],  
  [CreatedBy],  
  [CreatedDate],  
  [UpdatedBy],  
  [UpdatedDate]  
 )  
 Select  
  [ExceptionID],  
  [ObjectID],  
  [ObjectTypeID],  
  LObjectTypeID.[Name] as [ObjectTypeBI],  
  [FieldName],  
  [Summary],  
  [ActionLevelID],  
  LActionLevelID.[Name] as [ActionLevelBI],  
  ex.[CreatedBy],  
  ex.[CreatedDate],  
  ex.[UpdatedBy],  
  ex.[UpdatedDate]  
 From CORE.Exceptions ex  
 left join Core.Lookup  LObjectTypeID ON ex.ObjectTypeID = LObjectTypeID .LookupID  
 left join Core.Lookup  LActionLevelID ON ex.ActionLevelID = LActionLevelID .LookupID  
 where ex.[ObjectID] not in (Select noteid from cre.note n inner join core.account acc on acc.accountid = n.account_accountid where acc.isdeleted = 1)

  
  
--IF EXISTS(Select * from [dw].[L_ExceptionsBI])  
--BEGIN  
  
--Delete from [DW].[ExceptionsBI] where ObjectID in (Select Distinct ObjectID from [DW].[L_ExceptionsBI])  
  
  
--INSERT INTO [DW].[ExceptionsBI]  
-- (  
--  [ExceptionID],  
--  [ObjectID],  
--  [ObjectTypeID],  
--  [ObjectTypeBI],  
--  [FieldName],  
--  [Summary],  
--  [ActionLevelID],  
--  [ActionLevelBI],  
--  [CreatedBy],  
--  [CreatedDate],  
--  [UpdatedBy],  
--  [UpdatedDate]  
-- )  
-- Select  
--  [ExceptionID],  
--  [ObjectID],  
--  [ObjectTypeID],  
--  [ObjectTypeBI],  
--  [FieldName],  
--  [Summary],  
--  [ActionLevelID],  
--  [ActionLevelBI],  
--  [CreatedBy],  
--  [CreatedDate],  
--  [UpdatedBy],  
--  [UpdatedDate]  
-- From DW.[L_ExceptionsBI]  
  
  
  
  
  
--END  
  
  
DECLARE @RowCount int  
SET @RowCount = @@ROWCOUNT  
  
UPDATE [DW].BatchDetail  
SET  
BIEndTime = GETDATE(),  
BIRecordCount = @RowCount  
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_ExceptionsBI'  
  
Print(char(9) +'usp_MergeExceptionsBI - ROWCOUNT = '+cast(@RowCount  as varchar(100)));  
  
----------------------------------------------  
TRUNCATE TABLE [dw].[L_ExceptionsBI]  
----------------------------------------------  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
  
END  
  