
CREATE PROCEDURE [DW].[usp_ImportWFCheckListDetail]
@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	
INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_WFCheckListDetailBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


		Truncate table [DW].[L_WFCheckListDetailBI]

		INSERT INTO [DW].[L_WFCheckListDetailBI]
			( WFCheckListDetailID	
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

		SELECT * FROM
		(
			SELECT   wfchklstdetail.WFCheckListDetailID	
					,wfchklstdetail.TaskId	
					,wfchklstdetail.WFCheckListMasterID	
					,(CASE WHEN wfchklstdetail.WFCheckListMasterID= null THEN wfchklstdetail.CheckListName ELSE wfchklstmaster.CheckListName END) as CheckListName
					,wfchklstdetail.CheckListStatus	
					,l.Name as CheckListStatusText
					,wfchklstdetail.Comment	
					,wfchklstmaster.IsMandatory	
					,wfchklstmaster.SortOrder	
					,wfchklstmaster.WorkFlowType
					,wfchklstdetail.CreatedBy	
					,wfchklstdetail.CreatedDate	
					,wfchklstdetail.UpdatedBy	
					,wfchklstdetail.UpdatedDate	
			from cre.wfChecklistdetail wfchklstdetail
			LEFT JOIN  cre.wfChecklistmaster wfchklstmaster on wfchklstmaster.WFCheckListMasterID = wfchklstdetail.WFCheckListMasterID
			LEFT JOIN CORE.Lookup l ON l.LookupID = wfchklstdetail.CheckListStatus	
       )a
        WHERE a.TaskId in(
		 SELECT DISTINCT TaskID FROM 
		 (
			SELECT wfcld.TaskID, wfcld.CreatedDate, wfcld.UpdatedDate FROM CRE.WFChecklistDetail wfcld
			EXCEPT 
			SELECT dwtd.TaskID, dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].[WFChecklistDetailBI] dwtd
		 )b
	)



SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportWFCheckListDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


