
CREATE PROCEDURE [DW].[usp_MergeWFTaskDetail]
@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	
UPDATE [DW].BatchDetail
SET
BITableName = 'WFTaskDetailBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WFTaskDetailBI'


	DELETE FROM  [DW].[WFTaskDetailBI] 
	WHERE TASKID in (SELECT DISTINCT TaskID FROM [DW].[L_WFTaskDetailBI])
    

	INSERT INTO  [DW].[WFTaskDetailBI]
			( WFTaskDetailID
			 ,WFStatusPurposeMappingID
			 ,TaskID	
			 ,TaskTypeID
			 ,TaskTypeBI	
			 ,Comment	
			 ,SubmitType
			 ,SubmitTypeBI	
			 ,CreatedBy	
			 ,CreatedDate	
			 ,UpdatedBy	
			 ,UpdatedDate	
			 ,IsDeleted	
			 ,SpecialInstruction
			 ,AdditionalComment
			 ,WFGroupText
			 ,StatusName
			 ,StatusDisplayName
			 ,DealFundingDisplayName
			 ,WFUnderReviewDisplayName
			 ,WFFinalStatus)


		SELECT   WFTaskDetailID
				,WFStatusPurposeMappingID
				,TaskID	
				,TaskTypeID
				,TaskTypeBI	
				,Comment	
				,SubmitType	
				,SubmitTypeBI	
				,CreatedBy	
				,CreatedDate	
				,UpdatedBy	
				,UpdatedDate	
				,IsDeleted	
				,SpecialInstruction
				,AdditionalComment
				,WFGroupText
				,StatusName
				,StatusDisplayName
				,DealFundingDisplayName
				,WFUnderReviewDisplayName
				,WFFinalStatus
		FROM [DW].[L_WFTaskDetailBI]


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WFTaskDetailBI'

Print(char(9) +'usp_MergeWFTaskDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END