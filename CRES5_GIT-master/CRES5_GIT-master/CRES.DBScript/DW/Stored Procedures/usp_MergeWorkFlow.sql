

CREATE PROCEDURE [DW].[usp_MergeWorkFlow]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'WorkFlowBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WorkFlowBI'



Truncate table [DW].[WorkFlowBI]

INSERT INTO [DW].[WorkFlowBI]
           ([dealid]
           ,[dealfundingid]
           ,[CREDealID]
           ,[DealName]
           ,[Deadline]
           ,[Fundingdate]
           ,[Amount]
           ,[StatusName]
           ,[Username]
           ,[wf_isAllow]
           ,[UpdatedDate]
           ,[WorkFlowComment]
           ,[PurposeIDText]
           ,[Applied]
           ,[dealfunComment]
           ,[DrawFundingID]
           ,[WFTaskDetailID]
           ,[TaskID]
           ,[TaskTypeID]
           ,[SubmitType]
           ,[WFStatusPurposeMappingID]
           ,[PurposeTypeId]
           ,[OrderIndex]
           ,[WFStatusMasterID]
           ,[TaskTypeIDText]
           ,[SubmitTypeText]
           ,[PurposeID]
		   ,GeneratedBy
		,GeneratedByBI)

Select dealid,dealfundingid,CREDealID,DealName,Deadline,Fundingdate,Amount,StatusName,Username,wf_isAllow,UpdatedDate,WorkFlowComment,PurposeIDText,Applied,dealfunComment,DrawFundingID,WFTaskDetailID,TaskID,TaskTypeID,SubmitType,WFStatusPurposeMappingID,PurposeTypeId,OrderIndex,WFStatusMasterID,TaskTypeIDText,SubmitTypeText,PurposeID,GeneratedBy,GeneratedByBI
from(  
	Select 
	d.dealid,
	df.dealfundingid,
	d.CREDealID, 
	d.DealName,  
	df.DeadlineDate as Deadline,  
	df.Date as Fundingdate,  
	df.Amount,  
	sm.StatusName,  
	u.FirstName +' '+ u.LastName as Username,  
	1 as wf_isAllow,  
	--[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](td.TaskID,@UserID) as wf_isAllow,  
	--[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserIDAndStatus](td.TaskID,@UserID, sm.StatusName) as wf_isAllow,   
	td.UpdatedDate  ,
	td.Comment as WorkFlowComment,
	lPurposeID.Name as PurposeIDText,  
	df.Applied,  
	df.Comment as dealfunComment,  
	df.DrawFundingID,
	td.WFTaskDetailID,  
	td.TaskID,  
	td.TaskTypeID,  
	td.SubmitType,     
	td.WFStatusPurposeMappingID,  
	mapp.PurposeTypeId,  
	mapp.OrderIndex,  
	mapp.WFStatusMasterID,  
	lTaskTypeID.name as TaskTypeIDText,  
	lSubmitType.name as SubmitTypeText, 
	df.PurposeID ,

	df.GeneratedBy,
	Lgb.name as GeneratedByBI

	from cre.WFTaskDetail td  
	--LEFT JOIN cre.WFTaskDetailArchive tda ON tda.WFTaskDetailID =td.WFTaskDetailID 
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID  
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID  
	left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27  
	left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77  
   
	left join cre.DealFunding df on df.DealFundingID = td.TaskID  
	left join cre.Deal d on d.DealID = df.DealID  
	left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 50  
	left join app.[user] u on u.UserID = ISNULL(NULLIF(td.UpdatedBy  ,''),'00000000-0000-0000-0000-000000000000') 
	left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = df.GeneratedBy 

	  --Where td.WFTaskDetailID in (Select MAX(WFTaskDetailID) from cre.WFTaskDetail group by TaskID)  
	-- ORDER by td.TaskID DESC  
UNION
	Select   
	d.dealid,
	df.dealfundingid,
	d.CREDealID, 
	d.DealName,  
	df.DeadlineDate as Deadline,  
	df.Date as Fundingdate,  
	df.Amount,  
	sm.StatusName,  
	u.FirstName +' '+ u.LastName as Username,  
	1 as wf_isAllow,  
	--[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](td.TaskID,@UserID) as wf_isAllow,  
	--[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserIDAndStatus](td.TaskID,@UserID, sm.StatusName) as wf_isAllow,   
	td.UpdatedDate  ,
	td.Comment as WorkFlowComment,
	lPurposeID.Name as PurposeIDText,  
	df.Applied,  
	df.Comment as dealfunComment,  
	df.DrawFundingID,
	td.WFTaskDetailID,  
	td.TaskID,  
	td.TaskTypeID,  
	td.SubmitType,     
	td.WFStatusPurposeMappingID,  
	mapp.PurposeTypeId,  
	mapp.OrderIndex,  
	mapp.WFStatusMasterID,  
	lTaskTypeID.name as TaskTypeIDText,  
	lSubmitType.name as SubmitTypeText, 
	df.PurposeID ,

	df.GeneratedBy,
	Lgb.name as GeneratedByBI

	from cre.WFTaskDetailArchive td  
	--LEFT JOIN cre.WFTaskDetailArchive tda ON tda.WFTaskDetailID =td.WFTaskDetailID 
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID  
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID  
	left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27  
	left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77  
   
	left join cre.DealFunding df on df.DealFundingID = td.TaskID  
	left join cre.Deal d on d.DealID = df.DealID  
	left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 50  
	left join app.[user] u on u.UserID = ISNULL(NULLIF(td.UpdatedBy  ,''),'00000000-0000-0000-0000-000000000000') 
	left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = df.GeneratedBy 

	--Where td.WFTaskDetailID in (Select MAX(WFTaskDetailID) from cre.WFTaskDetail group by TaskID) 
)a  
where a.wf_isAllow = 1  and a.credealid is not null




DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WorkFlowBI'

Print(char(9) +'usp_MergeWorkFlow - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

