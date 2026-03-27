-- Procedure

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


Declare @tbltaskid as Table(TaskID UNIQUEIDENTIFIER)

INSERT INTO @tbltaskid(TaskID)
SELECT DISTINCT TaskID 
FROM 
(
SELECT tdn.TaskID, tdn.CreatedDate, tdn.UpdatedDate FROM CRE.WFTaskDetail tdn where IsDeleted <> 1
EXCEPT 
SELECT dwtd.TaskID, dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].[WFTaskDetailBI] dwtd where IsDeleted <> 1
)b


Truncate table [DW].[L_WFTaskDetailBI]


IF EXISTS(Select TaskID from @tbltaskid)
BEGIN
		
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
			 ,WFFinalStatus
			 ,Username
			,WFStatusMasterID
			,FundingDate
			,PurposeID
			,PurposeText
			,Amount)

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
	   ,(SELECT TOP 1 DealFundingDisplayName = (Case WHEN (select count(1) from cre.WFNotification where TaskID=a.TaskID and WFNotificationMasterID=2 and ActionType=577)>0 and sm.StatusName='Completed'  then 'Completed' when lPurposeType.Value1='WF_UNDERREVIEW' then sm.WFUnderReviewDisplayName  else sm.DealFundingDisplayName end) 
	   FROM [CRE].[WFTaskDetail] td 
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
		LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = a.PurposeTypeId and lPurposeType.ParentID = 50
		WHERE TaskId = a.TaskID
		ORDER BY WFTaskDetailID DESC ) as WFFinalStatus

		,Username
		,WFStatusMasterID
		,FundingDate
		,PurposeID
		,PurposeText
		,Amount

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

		,(u.FirstName +' '+ u.LastName) as Username
		,wfstatusmaster.WFStatusMasterID
		,df.date as FundingDate
		,df.PurposeID
		,lPurposeID.name as PurposeText
		,df.Amount
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

		left join app.[user] u on u.UserID = ISNULL(NULLIF(td.CreatedBy  ,''),'00000000-0000-0000-0000-000000000000') 
		left join cre.DealFunding df on df.DealFundingID = td.TaskID 
		inner join cre.deal d on d.dealid = df.dealid
		LEFT JOIN CORE.Lookup lPurposeID on lPurposeID.lookupid = df.PurposeID
		---where td.taskid in (Select dealfundingid from cre.dealfunding where dealid in (Select DealID from [DW].[L_DealBI]) )
		where td.IsDeleted <> 1 
		and d.isdeleted <> 1
		and td.taskid in (Select TaskID from @tbltaskid)
		

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

		,(u.FirstName +' '+ u.LastName) as Username
		,wfstatusmaster.WFStatusMasterID
		,df.date as FundingDate
		,df.PurposeID
		,lPurposeID.name as PurposeText
		,df.Amount

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
		left join app.[user] u on u.UserID = ISNULL(NULLIF(tda.CreatedBy  ,''),'00000000-0000-0000-0000-000000000000') 
		left join cre.DealFunding df on df.DealFundingID = tda.TaskID 
		inner join cre.deal d on d.dealid = df.dealid
		LEFT JOIN CORE.Lookup lPurposeID on lPurposeID.lookupid = df.PurposeID
		where tda.IsDeleted <> 1 
		and  d.IsDeleted <> 1 
		and tda.taskid in (Select TaskID from @tbltaskid)
)a

--WHERE
--a.TaskID in
--   ( 
--	SELECT DISTINCT TaskID FROM (SELECT tdn.TaskID, tdn.CreatedDate, tdn.UpdatedDate FROM CRE.WFTaskDetail tdn
--    EXCEPT 
--	SELECT dwtd.TaskID, dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].[WFTaskDetailBI] dwtd
--   )b
--   )




END

SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportWFTaskDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
GO

