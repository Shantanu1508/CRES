CREATE PROCEDURE [dbo].[usp_InsertWorkflowDetailForTaskId_ForDealFunding] 
	@tbltype_WorkflowDetail [tbltype_WorkflowDetail] READONLY
AS
BEGIN

SET NOCOUNT ON;      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   


-----------for temp-------------------------------------------------------------------------------------
-- DECLARE  @tbltype_WorkflowDetail [tbltype_WorkflowDetail] 

--INSERT INTO @tbltype_WorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
--Select TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID
--from dbo.tblWorkflowDetail_temp where TaskID <> ('D10D9672-B1C7-4E76-849D-3DB63B065F60')
------------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..[#tblWorkflowDetail]') IS NOT NULL
		DROP TABLE #tblWorkflowDetail

Create Table #tblWorkflowDetail(
	TaskID nvarchar(256),
	WFStatusPurposeMappingID int,
	TaskTypeID int,
	Comment  nvarchar(max),
	SubmitType int,
	CreatedBy nvarchar(256),
	AdditionalComments nvarchar(max) ,
	SpecialInstructions nvarchar(max) ,
	DelegatedUserID nvarchar(256) ,

	Is_CheckListDetail_Exists bit default (0),
	WorkflowType nvarchar(256) ,

	IsAdditionalComments_flag nvarchar(50)
)
Delete from #tblWorkflowDetail

INSERT INTO #tblWorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID,IsAdditionalComments_flag)  --,Is_CheckListDetail_Exists,WorkflowType
Select t.TaskID,t.WFStatusPurposeMappingID,t.TaskTypeID,t.Comment,t.SubmitType,t.CreatedBy,t.AdditionalComments,t.SpecialInstructions,t.DelegatedUserID,
(CASE WHEN wa.TaskID is null  THEN 'Insert_AdditionalComments' else 'Update_AdditionalComments' end) as IsAdditionalComments_flag

from @tbltype_WorkflowDetail t
left join CRE.WFTaskAdditionalDetail wa on wa.TaskID =t.TaskID


----------------------------------------------------------------------------
Update #tblWorkflowDetail set Is_CheckListDetail_Exists = 0

Update #tblWorkflowDetail set Is_CheckListDetail_Exists = 1 Where TaskID in (
	Select Distinct TaskId from [CRE].[WFCheckListDetail] 
	where TaskId in (Select TaskID from #tblWorkflowDetail where TaskTypeID=502)
	and TaskTypeID=502
)
----------------------------------------------------------------------------

Update #tblWorkflowDetail  set #tblWorkflowDetail.WorkflowType = z.WorkflowType
From(
	select df.DealFundingID as TaskID,l.Value1 as WorkflowType
	from cre.DealFunding df
	left join core.lookup l on l.lookupid = df.purposeid
	where DealFundingID in (Select TaskID from #tblWorkflowDetail where TaskTypeID=502)
)z
where #tblWorkflowDetail.TaskID = z.TaskID


--select * from #tblWorkflowDetail
--============================================================




Declare @tbllookup as table(lookupid int,[name] nvarchar(256),parentid int)

Delete from @tbllookup
INSERT INTO @tbllookup(lookupid,[name],parentid)
Select LookupID,[name],parentid from core.Lookup where ParentID = 77
	

Declare @lookupidSaveAsDraft int = (Select LookupID from @tbllookup where [name] = 'Save (Draft)' and ParentID = 77)
Declare @lookupidSave int = (Select LookupID from @tbllookup where [name] = 'Save' and ParentID = 77)
Declare @lookupidWFNotification int = (Select LookupID from @tbllookup where [name] = 'WFNotification' and ParentID = 77)


DECLARE @purposeID int,@WorkflowType nvarchar(100),@CREDealID nvarchar(256),@dealid UNIQUEIDENTIFIER,@DebtAmount decimal(18,2)
Declare @WFStatusName nvarchar(256)
Declare @L_SubmitType nvarchar(256)
Declare @WFNotificationMasterID int
Declare @MessageHTML nvarchar(max)
Declare @AdditionalText   nvarchar(256)
Declare @ScheduledDateTime Datetime
Declare @ActionType int
declare @IsReoDeal int=0


--IF(@lookupidSaveAsDraft = @SubmitType)
INSERT INTO [CRE].[WFTaskDetail]
([WFStatusPurposeMappingID]
,[TaskID]
,[TaskTypeID]
,[Comment]
,[SubmitType]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[DelegatedUserID])
Select WFStatusPurposeMappingID
,TaskID
,TaskTypeID
,Comment
,SubmitType
,CreatedBy
,getdate()
,CreatedBy
,getdate()
,DelegatedUserID 
from #tblWorkflowDetail
where TaskTypeID = 502 and SubmitType = @lookupidSaveAsDraft		
		
	

--IF (@lookupidSave != @SubmitType AND @lookupidSaveAsDraft != @SubmitType) 
INSERT INTO [CRE].[WFTaskDetail]
([WFStatusPurposeMappingID]
,[TaskID]
,[TaskTypeID]
,[Comment]
,[SubmitType]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[DelegatedUserID])
Select WFStatusPurposeMappingID
,TaskID
,TaskTypeID
,Comment
,SubmitType
,CreatedBy
,getdate()
,CreatedBy
,getdate()
,DelegatedUserID 
from #tblWorkflowDetail
where TaskTypeID = 502 and (SubmitType <> @lookupidSave	and SubmitType <> @lookupidSaveAsDraft)


------keep inserted WFTaskDetailID----------------------------------------------------------
Declare @tbl_WFTaskDetailID as table (TaskID uNIQUEIDENTIFIER,WFTaskDetailID int)

Delete from @tbl_WFTaskDetailID

INSERT INTO @tbl_WFTaskDetailID(TaskID,WFTaskDetailID)

select TaskID,max(WFTaskDetailID) as WFTaskDetailID FROM [CRE].[WFTaskDetail] 
where TaskID in (Select TaskID from #tblWorkflowDetail where TaskTypeID = 502 and (SubmitType <> @lookupidSave	and SubmitType <> @lookupidSaveAsDraft))
and TaskTypeID = 502 
group by TaskID
----------------------------------------------------------------

INSERT INTO CRE.WFTaskDetailArchive
([WFTaskDetailID]
,[WFStatusPurposeMappingID]
,[TaskID]
,[TaskTypeID]
,[Comment]
,[SubmitType]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[DelegatedUserID])
SELECT
WFTaskDetailID,
WFStatusPurposeMappingID,
TaskID,
TaskTypeID,
Comment,
SubmitType,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
DelegatedUserID
FROM [CRE].[WFTaskDetail] 
where TaskTypeID = 502  
and TaskID in (Select TaskID from #tblWorkflowDetail where TaskTypeID = 502 and (SubmitType <> @lookupidSave	and SubmitType <> @lookupidSaveAsDraft))
and WFTaskDetailID not in (	
	Select WFTaskDetailID from @tbl_WFTaskDetailID
)


Delete from cre.WFTaskDetail where  TaskTypeID=502 and WFTaskDetailID in (	
	Select WFTaskDetailID FROM [CRE].[WFTaskDetail] 
	where TaskID in (Select TaskID from #tblWorkflowDetail where TaskTypeID = 502 and (SubmitType <> @lookupidSave	and SubmitType <> @lookupidSaveAsDraft))
	and TaskTypeID=502  
	and WFTaskDetailID not in (	Select WFTaskDetailID from @tbl_WFTaskDetailID)
)



---INSERT INTO [CRE].[WFCheckListDetail]
INSERT INTO [CRE].[WFCheckListDetail]
([TaskId]
,[TaskTypeID]
,[WFCheckListMasterID]
,[CheckListName]
,[CheckListStatus]
,[Comment]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])

Select
a.TaskId,
a.TaskTypeID,
w.WFCheckListMasterID,
null as CheckListName,
null as CheckListStatus,
null as Comment,
a.CreatedBy,
getdate(),
a.CreatedBy,
getdate()
from cre.WFCheckListMaster w ,(Select TaskID,TaskTypeID,CreatedBy from #tblWorkflowDetail where Is_CheckListDetail_Exists = 0 and TaskTypeID = 502 and WorkflowType = 'WF_UNDERREVIEW')a
where  w.WorkFlowType = 'WF_UNDERREVIEW'

INSERT INTO [CRE].[WFCheckListDetail]
([TaskId]
,[TaskTypeID]
,[WFCheckListMasterID]
,[CheckListName]
,[CheckListStatus]
,[Comment]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])

Select
a.TaskId,
a.TaskTypeID,
w.WFCheckListMasterID,
null as CheckListName,
null as CheckListStatus,
null as Comment,
a.CreatedBy,
getdate(),
a.CreatedBy,
getdate()
from cre.WFCheckListMaster w ,(Select TaskID,TaskTypeID,CreatedBy from #tblWorkflowDetail where Is_CheckListDetail_Exists = 0 and TaskTypeID = 502 and WorkflowType = 'WF_FUll')a
where  w.WorkFlowType = 'WF_FUll'



Update cre.WFCheckListDetail  SET cre.WFCheckListDetail.CheckListStatus = a.CheckListStatus_new
From(
	Select WFCheckListDetailid
	,taskid
	,TaskTypeID
	,WFCheckListMasterID
	,CheckListStatus 
	,(CASE WHEN WFCheckListMasterID in (6,7,8,20) and ISNULL(CheckListStatus,550) = 550 THEN 616
		WHEN WFCheckListMasterID = 9 and ISNULL(CheckListStatus,550) = 550 THEN 499 
		WHEN WFCheckListMasterID = 21 and ISNULL(CheckListStatus,550) = 550 THEN 880 else CheckListStatus
		END
	)as CheckListStatus_new

	from cre.WFCheckListDetail 
	where taskid in (Select TaskID from #tblWorkflowDetail where TaskTypeID = 502) 
	and TaskTypeID=502
	and IsDeleted <> 1
	and (WFCheckListMasterID in (6,7,8,9,20,21) and CheckListStatus is null)
)a
Where cre.WFCheckListDetail.WFCheckListDetailid = a.WFCheckListDetailid
and cre.WFCheckListDetail.IsDeleted <> 1

----=============================================
INSERT INTO CRE.WFTaskAdditionalDetail([TaskID],[TaskTypeID],[SpecialInstruction],[AdditionalComment],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
select TaskID,TaskTypeID,SpecialInstructions,AdditionalComments,CreatedBy,getdate(),CreatedBy,getdate()
from #tblWorkflowDetail 
where IsAdditionalComments_flag = 'Insert_AdditionalComments'  
and TaskTypeID=502
and (SpecialInstructions is not null oR AdditionalComments  is not null)


UPDATE CRE.WFTaskAdditionalDetail
SET CRE.WFTaskAdditionalDetail.SpecialInstruction = a.SpecialInstructions,
CRE.WFTaskAdditionalDetail.AdditionalComment = a.AdditionalComments,
CRE.WFTaskAdditionalDetail.UpdatedBy = a.CreatedBy,
CRE.WFTaskAdditionalDetail.UpdatedDate = getdate()
From(
	select TaskID,TaskTypeID,SpecialInstructions,AdditionalComments,CreatedBy
	from #tblWorkflowDetail 
	where IsAdditionalComments_flag = 'Update_AdditionalComments'  
	and TaskTypeID=502
	and (SpecialInstructions is not null oR AdditionalComments  is not null)
)a
where CRE.WFTaskAdditionalDetail.TaskID = a.TaskID
and CRE.WFTaskAdditionalDetail.TaskTypeID=502
-----===================================================================

---SubmitType as approval
IF EXISTS(Select TaskID from #tblWorkflowDetail Where SubmitType <> @lookupidSave AND SubmitType <> @lookupidSaveAsDraft) 
BEGIN

	SET @CREDealID = (select top 1 d.CREDealID 
	from cre.DealFunding df
	inner join cre.deal d on d.dealid = df.dealid
	where df.DealFundingID in (Select top 1 TaskID from #tblWorkflowDetail))
	

	--updat phantom deal 	
	EXEC [dbo].[usp_CopyDealFundingFromLegalToPhantom] @CREDealID
END


----=========================================================================================
----Cursor----
 Declare @TaskID nvarchar(max)
 Declare @WFStatusPurposeMappingID int
 Declare @TaskTypeID int
 Declare @Comment  nvarchar(max) 
 Declare @SubmitType int
 Declare @CreatedBy nvarchar(256)
 Declare @AdditionalComments nvarchar(max)
 Declare @SpecialInstructions nvarchar(max) 
 Declare @DelegatedUserID nvarchar(max)


IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	Select TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID 
	from #tblWorkflowDetail
)
OPEN CursorDeal 
FETCH NEXT FROM CursorDeal
INTO  @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy,@AdditionalComments,@SpecialInstructions,@DelegatedUserID
WHILE @@FETCH_STATUS = 0
BEGIN

IF(@TaskTypeID=502)
BEGIN
	
	print('IF(@TaskTypeID=502)')
	
	--v--used for notification
	select @dealid = dealid ,
	@purposeID = PurposeID,
	@DebtAmount = Amount
	from cre.DealFunding where DealFundingID = @TaskID

	SELECT  @CREDealID =(select top 1 CREDealID from CRE.Deal where dealid = @dealid and isdeleted <> 1)	--used for phantom script
	SELECT @WorkflowType  = (Select top 1 Value1 from core.Lookup where LookupID = @purposeID)
	---===================================
		
	--Insert WF Preliminary notification
	print('Insert WF Preliminary notification')

	SET @WFStatusName = (select wsm.StatusName from CRE.WFStatusPurposeMapping wfsm inner join CRE.WFStatusMaster wsm on wfsm.WFStatusMasterID = wsm.WFStatusMasterID where WFStatusPurposeMappingID = @WFStatusPurposeMappingID)
	SET @L_SubmitType = (Select [name] from core.lookup  where ParentID=77 and lookupid = @SubmitType)


	IF(@L_SubmitType = 'Submit for Approver')
	BEGIN
		
		IF(@WFStatusName = 'Requested')
		BEGIN	
			
			IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification' and IsEnable = 1)
			BEGIN
				SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification')
				SET @MessageHTML = null
				SET @AdditionalText = null
				SET @ScheduledDateTime = null
				SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')

				EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null
			END
		END
		ELSE IF(@WFStatusName = 'Completed')
		BEGIN	
			IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Final Notification' and IsEnable = 1)
			BEGIN
				SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Final Notification')
				SET @MessageHTML = null
				SET @AdditionalText = null
				SET @ScheduledDateTime = null
				SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')

				EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null
			END
			IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Servicer Notification' and IsEnable = 1)
			BEGIN
				SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Servicer Notification')
				SET @MessageHTML = null
				SET @AdditionalText = null
				SET @ScheduledDateTime = null
				SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')

				EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null
			END
			--debt amount =0 than no need to send any notification
			--IF ((@WorkflowType='WF_UNDERREVIEW' or @DebtAmount= 0) and @purposeID<>630)-- wireconfirm workflow without sending any notification except full pay off
		
			IF (@WorkflowType='WF_UNDERREVIEW' or @DebtAmount= 0)-- wireconfirm workflow without sending any notification except full pay off
			BEGIN
				UPDATE CRE.DealFunding SET Applied=1,Issaved=1,UpdatedDate=Getdate(),UpdatedBy=@CreatedBy WHERE DealFundingID=@TaskID and  ISNULL(Applied,0) = 0
			
				--note level wireconfirm
					UPDATE [CORE].FundingSchedule SET Applied=1,IsSaved=1 WHERE FundingScheduleID in 
					(
							Select  fs.FundingScheduleID
							from [CORE].FundingSchedule fs
							INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
							INNER JOIN (					
							Select 
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
								MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
								from [CORE].[Event] eve
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
								where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
								and n.dealid = @dealid  and acc.IsDeleted = 0
								and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
							) sEvent
							ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

							left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
							left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
							where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
							and dealFundingId = @TaskID
				)
				--update updateddate of deal table so that it will update Applied flag of [DealFundingSchduleBI] table
				update cre.Deal set UpdatedDate=GETDATE() where DealID=@dealid

				--updat phantom deal on draw wireconfirmed 
				---Commented for optimization - Vishal
				EXEC [dbo].[usp_CopyDealFundingFromLegalToPhantom] @CREDealID
				EXEC [dbo].[usp_UpdateWireConfirmedForPhantomDeal] @CREDealID
			END
		

		END
	END


END


FETCH NEXT FROM CursorDeal
INTO  @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy,@AdditionalComments,@SpecialInstructions,@DelegatedUserID
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal

SET TRANSACTION ISOLATION LEVEL READ COMMITTED     
END




