CREATE PROCEDURE [dbo].[usp_UpdateWorkflowStatusForAFunding]  
(
   @DealFundingID UNIQUEIDENTIFIER,
   @TaskTypeID int,
   @UserID nvarchar(256),
   @CheckListDetail tblType_CheckListDetail readonly
)
	
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @tWFTaskDetail TABLE (tWFTaskDetailID int)
    DECLARE @WFTaskDetailID int
    DECLARE @PurposeID int
    DECLARE @AdminUserID nvarchar(256)='B0E6697B-3534-4C09-BE0A-04473401AB93'
    DECLARE @Comment nvarchar(256)= 'Sent final notification via script'
    DECLARE @WorkFlowType nvarchar(100)

    IF (@UserID is not null and  @UserID<>'')
    BEGIN
      SET @AdminUserID=@UserID
    END
--==========================================================================================================================================
IF (@TaskTypeID=502)
BEGIN
IF EXISTS(Select Comment from cre.dealfunding where DealFundingID = @DealFundingID and  Comment is not null)
BEGIN
--Update cre.dealfunding set Comment = 'M61# manual' where dealfundingid = @DealFundingID
 select @PurposeID =PurposeID from cre.dealfunding where DealFundingID = @DealFundingID
 select @WorkFlowType= Value1 from core.Lookup where LookupID=@PurposeID

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
           ,[IsDeleted])
           OUTPUT inserted.WFTaskDetailID INTO @tWFTaskDetail(tWFTaskDetailID)
Select top 1 
wfd.[WFStatusPurposeMappingID]
,wfd.[TaskID]
,wfd.[TaskTypeID]
,wfd.[Comment]
,497 [SubmitType]
,case when (@UserID is not null and  @UserID<>'') then @UserID else wfd.[CreatedBy] end
,getDate()[CreatedDate]
,case when (@UserID is not null and  @UserID<>'') then @UserID else wfd.[UpdatedBy] end
,getDate()[UpdatedDate]
,wfd.[IsDeleted]
from [CRE].[WFTaskDetail] wfd
where wfd.taskid = @DealFundingID order by CreatedDate desc
select @WFTaskDetailID =tWFTaskDetailID from @tWFTaskDetail

if(@WorkFlowType = 'WF_UNDERREVIEW' and @PurposeID<>630)
BEGIN
SET @Comment = 'Auto Completed'
END
Update [CRE].[WFTaskDetail] set WFStatusPurposeMappingID = 5,Comment = @Comment where taskid = @DealFundingID and SubmitType = 497 and WFTaskDetailID=@WFTaskDetailID


Update CRE.WFTaskAdditionalDetail set SpecialInstruction = 'WARNING- Please do not reject or use notify button on this draw. This was auto completed directly by M61 via script.'
where taskid = @DealFundingID

--update checklist

IF EXISTS(Select WFCheckListDetailID from [CRE].[WFCheckListDetail] where TaskId = @DealFundingID and TaskTypeID=@TaskTypeID )
	BEGIN
	
		 -- --Delete 
		 --  DELETE FROM [CRE].[WFCheckListDetail] WHERE WFCheckListDetailID NOT IN
		 --  (
			--select  wc.WFCheckListDetailID FROM [CRE].[WFCheckListDetail] wc join @CheckListDetail d on wc.WFCheckListDetailID = d.WFCheckListDetailID
		 --  )
		 -- and TaskId =@DealFundingID and TaskTypeID=@TaskTypeID and WFCheckListMasterID is null

		---optimize
		DELETE FROM [CRE].[WFCheckListDetail] WHERE  TaskTypeID=@TaskTypeID and WFCheckListDetailID in (
			Select WFCheckListDetailID FROM [CRE].[WFCheckListDetail] WHERE WFCheckListDetailID NOT IN
			   (
				select  wc.WFCheckListDetailID FROM [CRE].[WFCheckListDetail] wc join @CheckListDetail d on wc.WFCheckListDetailID = d.WFCheckListDetailID
			   )
			  and TaskId =@DealFundingID and TaskTypeID=@TaskTypeID and WFCheckListMasterID is null
		)

	 UPDATE [CRE].[WFCheckListDetail]
		SET [CRE].[WFCheckListDetail].[CheckListStatus] = tblInCLD.CheckListStatus
		  ,[CRE].[WFCheckListDetail].[Comment] = tblInCLD.Comment
		  ,[CRE].[WFCheckListDetail].[UpdatedBy] = @AdminUserID
		  ,[CRE].[WFCheckListDetail].[UpdatedDate] = getdate()
		 from(
			Select
			WFCheckListDetailID,
			TaskId,
			WFCheckListMasterID,
			CheckListName,
			CheckListStatus,
			Comment
			from @CheckListDetail
		) as tblInCLD
		where  [CRE].[WFCheckListDetail].WFCheckListDetailID = tblInCLD.WFCheckListDetailID
		and [CRE].[WFCheckListDetail].TaskId = tblInCLD.TaskId and [CRE].[WFCheckListDetail].TaskTypeID=@TaskTypeID

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
			@DealFundingID,
			@TaskTypeID,
			WFCheckListMasterID,
			CheckListName,
			CheckListStatus,
			Comment,
			@AdminUserID,
			getdate(),
			@AdminUserID,
			getdate()
			from @CheckListDetail
			where WFCheckListDetailID is null and NULLIF(CheckListName,'') is not null
	END

--Update comments in CheckList
Update [CRE].[WFCheckListDetail] set Comment = 'Auto Completed' where TaskID = @DealFundingID and isnull(Comment,'')=''

    if(@WorkFlowType = 'WF_FUll')
    BEGIN
        --Prelim and Final notification
        INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData,TaskTypeID)
        VALUES(1,@DealFundingID,null,null,577,@AdminUserID,getdate(),@AdminUserID,getdate(),'Preliminary',null,502)	

        INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData,TaskTypeID)
        VALUES(2,@DealFundingID,null,null,577,@AdminUserID,getdate(),@AdminUserID,getdate(),'Final',null,502)				
    END
    else if(@WorkFlowType = 'WF_UNDERREVIEW' and @PurposeID = 630)
    BEGIN
        --Prelim and Final notification
        INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData,TaskTypeID)
        VALUES(6,@DealFundingID,null,null,577,@AdminUserID,getdate(),@AdminUserID,getdate(),'Final Without Approval',null,502)	
    END
END
ELSE
BEGIN
	Print('Please enter comment in draw first')
END
END
ELSE IF (@TaskTypeID=719)
BEGIN
IF EXISTS(Select Comment from cre.DealReserveSchedule where DealReserveScheduleGUID = @DealFundingID and  Comment is not null)
BEGIN
--Update cre.dealfunding set Comment = 'M61# manual' where dealfundingid = @DealFundingID
 select @PurposeID =PurposeID from cre.DealReserveSchedule where DealReserveScheduleGUID = @DealFundingID
 select @WorkFlowType= Value1 from core.Lookup where LookupID=@PurposeID

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
           ,[IsDeleted])
           OUTPUT inserted.WFTaskDetailID INTO @tWFTaskDetail(tWFTaskDetailID)
Select top 1 
wfd.[WFStatusPurposeMappingID]
,wfd.[TaskID]
,wfd.[TaskTypeID]
,wfd.[Comment]
,497 [SubmitType]
,case when (@UserID is not null and  @UserID<>'') then @UserID else wfd.[CreatedBy] end
,getDate()[CreatedDate]
,case when (@UserID is not null and  @UserID<>'') then @UserID else wfd.[UpdatedBy] end
,getDate()[UpdatedDate]
,wfd.[IsDeleted]
from [CRE].[WFTaskDetail] wfd
where wfd.taskid = @DealFundingID order by CreatedDate desc
select @WFTaskDetailID =tWFTaskDetailID from @tWFTaskDetail


SET @Comment = 'Auto Completed'
Update [CRE].[WFTaskDetail] set WFStatusPurposeMappingID = 5,Comment = @Comment where taskid = @DealFundingID and SubmitType = 497 and WFTaskDetailID=@WFTaskDetailID


Update CRE.WFTaskAdditionalDetail set SpecialInstruction = 'WARNING- Please do not reject or use notify button on this draw. This was auto completed directly by M61 via script.'+isnull(SpecialInstruction,'')
where taskid = @DealFundingID

--update checklist

--IF EXISTS(Select WFCheckListDetailID from [CRE].[WFCheckListDetail] where TaskId = @DealFundingID and TaskTypeID=@TaskTypeID )
--	BEGIN
	
--		 -- --Delete 
--		 --  DELETE FROM [CRE].[WFCheckListDetail] WHERE WFCheckListDetailID NOT IN
--		 --  (
--			--select  wc.WFCheckListDetailID FROM [CRE].[WFCheckListDetail] wc join @CheckListDetail d on wc.WFCheckListDetailID = d.WFCheckListDetailID
--		 --  )
--		 -- and TaskId =@DealFundingID and TaskTypeID=@TaskTypeID and WFCheckListMasterID is null

--		---optimize
--		DELETE FROM [CRE].[WFCheckListDetail] WHERE  TaskTypeID=@TaskTypeID and WFCheckListDetailID in (
--			Select WFCheckListDetailID FROM [CRE].[WFCheckListDetail] WHERE WFCheckListDetailID NOT IN
--			   (
--				select  wc.WFCheckListDetailID FROM [CRE].[WFCheckListDetail] wc join @CheckListDetail d on wc.WFCheckListDetailID = d.WFCheckListDetailID
--			   )
--			  and TaskId =@DealFundingID and TaskTypeID=@TaskTypeID and WFCheckListMasterID is null
--		)

--	 UPDATE [CRE].[WFCheckListDetail]
--		SET [CRE].[WFCheckListDetail].[CheckListStatus] = tblInCLD.CheckListStatus
--		  ,[CRE].[WFCheckListDetail].[Comment] = tblInCLD.Comment
--		  ,[CRE].[WFCheckListDetail].[UpdatedBy] = @AdminUserID
--		  ,[CRE].[WFCheckListDetail].[UpdatedDate] = getdate()
--		 from(
--			Select
--			WFCheckListDetailID,
--			TaskId,
--			WFCheckListMasterID,
--			CheckListName,
--			CheckListStatus,
--			Comment
--			from @CheckListDetail
--		) as tblInCLD
--		where  [CRE].[WFCheckListDetail].WFCheckListDetailID = tblInCLD.WFCheckListDetailID
--		and [CRE].[WFCheckListDetail].TaskId = tblInCLD.TaskId and [CRE].[WFCheckListDetail].TaskTypeID=@TaskTypeID

--		INSERT INTO [CRE].[WFCheckListDetail]
--			   ([TaskId]
--			   ,[TaskTypeID]
--			   ,[WFCheckListMasterID]
--			   ,[CheckListName]
--			   ,[CheckListStatus]
--			   ,[Comment]
--			   ,[CreatedBy]
--			   ,[CreatedDate]
--			   ,[UpdatedBy]
--			   ,[UpdatedDate])
--		Select
--			@DealFundingID,
--			@TaskTypeID,
--			WFCheckListMasterID,
--			CheckListName,
--			CheckListStatus,
--			Comment,
--			@AdminUserID,
--			getdate(),
--			@AdminUserID,
--			getdate()
--			from @CheckListDetail
--			where WFCheckListDetailID is null and NULLIF(CheckListName,'') is not null
--	END

--Update comments in CheckList
Update [CRE].[WFCheckListDetail] set Comment = 'Auto Completed' where TaskID = @DealFundingID and isnull(Comment,'')='' and TaskTypeID=@TaskTypeID

    if(@WorkFlowType = 'WF_Reserve')
    BEGIN
        --Prelim and Final notification
        INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData,TaskTypeID)
        VALUES(4,@DealFundingID,null,null,577,@AdminUserID,getdate(),@AdminUserID,getdate(),'Preliminary',null,502)	

        INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData,TaskTypeID)
        VALUES(5,@DealFundingID,null,null,577,@AdminUserID,getdate(),@AdminUserID,getdate(),'Final',null,502)				
    END
END
ELSE
BEGIN
	Print('Please enter comment in draw first')
END
END

END