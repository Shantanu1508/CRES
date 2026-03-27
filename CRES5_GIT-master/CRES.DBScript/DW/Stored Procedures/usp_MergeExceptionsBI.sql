  
  
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
  
IF EXISTS(Select top 1 Objectid from [DW].[L_ExceptionsBI])
BEGIN


Delete from  [DW].[ExceptionsBI]  where objectid in (Select Objectid from [DW].[L_ExceptionsBI])
  
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
  [ObjectTypeBI],  
  [FieldName],  
  [Summary],  
  [ActionLevelID],  
  [ActionLevelBI],  
  [CreatedBy],  
  [CreatedDate],  
  [UpdatedBy],  
  [UpdatedDate] 
  from [DW].[L_ExceptionsBI]
  
 END 

  
  
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
  