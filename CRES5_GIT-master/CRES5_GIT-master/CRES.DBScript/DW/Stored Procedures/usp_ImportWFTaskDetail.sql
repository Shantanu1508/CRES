
CREATE PROCEDURE [DW].[usp_ImportWFTaskDetail]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_WFTaskDetailBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


		Truncate table [DW].[L_WFTaskDetailBI]

		INSERT INTO [DW].[L_WFTaskDetailBI]
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

SELECT  WFTaskDetailID
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
	   ,(SELECT TOP 1 DealFundingDisplayName = (Case WHEN (select count(1) from cre.WFNotification where TaskID=a.TaskID and WFNotificationMasterID=2 and ActionType=577)>0 and sm.StatusName='Completed'  then 'Completed' when lPurposeType.Value1='WF_UNDERREVIEW' then sm.WFUnderReviewDisplayName  else sm.DealFundingDisplayName end) FROM [CRE].[WFTaskDetail] td 
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
		LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = a.PurposeTypeId and lPurposeType.ParentID = 50
		WHERE TaskId = a.TaskID
		ORDER BY WFTaskDetailID DESC ) as WFFinalStatus

 FROM(
		SELECT   td.WFTaskDetailID
		,td.WFStatusPurposeMappingID
		,td.TaskID	
		,td.TaskTypeID
		,ltask.Name as TaskTypeBI	
		,td.Comment	
		,td.SubmitType	
		,lsubmit.Name as SubmitTypeBI	
		,td.CreatedBy	
		,td.CreatedDate	
		,td.UpdatedBy	
		,td.UpdatedDate	
		,td.IsDeleted	
		,tadddetail.SpecialInstruction
		,tadddetail.AdditionalComment
		,wfgrptxt.[Value1] as WFGroupText
		,wfstatusmaster.StatusName
		,wfstatusmaster.StatusDisplayName
		,wfstatusmaster.DealFundingDisplayName
		,wfstatusmaster.WFUnderReviewDisplayName
		,wfstatuspurmap.PurposeTypeId 
		FROM CRE.WFTaskDetail td
		LEFT JOIN CORE.Lookup ltask on ltask.LookupID = td.TaskTypeID
		LEFT JOIN CORE.Lookup lsubmit on lsubmit.LookupID = td.SubmitType
		LEFT JOIN (
		Select TaskID,SpecialInstruction,AdditionalComment,TaskTypeID 
		from CRE.WFTaskAdditionalDetail
		where TaskTypeID is not null
		)tadddetail on tadddetail.TaskID = td.TaskID 
		LEFT JOIN CRE.WFStatusPurposeMapping wfstatuspurmap on wfstatuspurmap.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		LEFT JOIN CRE.WFStatusMaster wfstatusmaster on wfstatuspurmap.WFStatusMasterID = wfstatusmaster.WFStatusMasterID
		LEFT JOIN CORE.Lookup wfgrptxt on wfstatuspurmap.PurposeTypeId = wfgrptxt.LookupID

		UNION ALL			
		

		SELECT  tda.WFTaskDetailID
		,tda.WFStatusPurposeMappingID
		,tda.TaskID	
		,tda.TaskTypeID
		,ltask.Name as TaskTypeBI	
		,tda.Comment	
		,tda.SubmitType	
		,lsubmit.Name as SubmitTypeBI	
		,tda.CreatedBy	
		,tda.CreatedDate	
		,tda.UpdatedBy	
		,tda.UpdatedDate	
		,tda.IsDeleted	
		,tadddetail.SpecialInstruction
		,tadddetail.AdditionalComment
		,wfgrptxt.[Value1] as WFGroupText
		,wfstatusmaster.StatusName
		,wfstatusmaster.StatusDisplayName
		,wfstatusmaster.DealFundingDisplayName
		,wfstatusmaster.WFUnderReviewDisplayName
		,wfstatuspurmap.PurposeTypeId 
		FROM CRE.WFTaskDetailArchive tda
		LEFT JOIN CORE.Lookup ltask on ltask.LookupID = tda.TaskTypeID
		LEFT JOIN CORE.Lookup lsubmit on lsubmit.LookupID = tda.SubmitType
		LEFT JOIN (
			Select TaskID,SpecialInstruction,AdditionalComment,TaskTypeID 
			from CRE.WFTaskAdditionalDetail
			where TaskTypeID is not null
		)tadddetail on tadddetail.TaskID = tda.TaskID 
		LEFT JOIN CRE.WFStatusPurposeMapping wfstatuspurmap on wfstatuspurmap.WFStatusPurposeMappingID = tda.WFStatusPurposeMappingID
		LEFT JOIN CRE.WFStatusMaster wfstatusmaster on wfstatuspurmap.WFStatusMasterID = wfstatusmaster.WFStatusMasterID
		LEFT JOIN CORE.Lookup wfgrptxt on wfgrptxt.LookupID	= wfstatuspurmap.PurposeTypeId
)a
WHERE
a.TaskID in
   ( 
	SELECT DISTINCT TaskID FROM (SELECT tdn.TaskID, tdn.CreatedDate, tdn.UpdatedDate FROM CRE.WFTaskDetail tdn
    EXCEPT 
	SELECT dwtd.TaskID, dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].[WFTaskDetailBI] dwtd
   )b
   )




SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportWFTaskDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
