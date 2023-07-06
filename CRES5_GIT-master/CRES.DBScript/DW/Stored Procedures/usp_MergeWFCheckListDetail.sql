
CREATE PROCEDURE [DW].[usp_MergeWFCheckListDetail]
	@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

UPDATE [DW].BatchDetail
SET
BITableName = 'WFCheckListDetailBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WFCheckListDetailBI'


	--TRUNCATE TABLE [DW].[WFCheckListDetailBI]
	DELETE FROM  [DW].[WFCheckListDetailBI] WHERE TASKID in (SELECT DISTINCT TaskID FROM [DW].[L_WFCheckListDetailBI])
    

	INSERT INTO  [DW].[WFCheckListDetailBI]
			(  WFCheckListDetailID	
			  ,TaskId	
			  ,WFCheckListMasterID	
			  ,CheckListName	
			  ,CheckListStatus
			  ,CheckListStatusText	
			  ,Comment	
			  ,IsMandatory	
			  ,SortOrder	
			  ,WorkFlowType
			  ,CreatedBy	
			  ,CreatedDate	
			  ,UpdatedBy	
			  ,UpdatedDate)


		SELECT   WFCheckListDetailID	
				,TaskId	
				,WFCheckListMasterID	
				,CheckListName	
				,CheckListStatus
				,CheckListStatusText	
				,Comment	
				,IsMandatory	
				,SortOrder	
				,WorkFlowType
				,CreatedBy	
				,CreatedDate	
				,UpdatedBy	
				,UpdatedDate
		FROM [DW].[L_WFCheckListDetailBI]


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WFCheckListDetailBI'

Print(char(9) +'usp_MergeWFCheckListDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END