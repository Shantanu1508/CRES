  
  
CREATE PROCEDURE [dbo].[usp_InsertWorkflowDetailForTaskId]   
 @TaskID nvarchar(max),  
 @WFStatusPurposeMappingID int,  
 @TaskTypeID int,  
 @Comment  nvarchar(max) = null,  
 @SubmitType int,  
 @CreatedBy nvarchar(256),  
 @AdditionalComments nvarchar(max) = null,  
 @SpecialInstructions nvarchar(max) = null,  
 @DelegatedUserID nvarchar(max) = null,  
 @CheckListDetail tblType_CheckListDetail readonly  
  
AS  
BEGIN  
  
SET NOCOUNT ON;        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
  
 Declare @tbllookup as table(lookupid int,[name] nvarchar(256),parentid int)  
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
 declare @IsReoDeal int=0,@SkipWorkflowNotification bit=0
 declare @SkipWorkflowNotificationComment nvarchar(max) = null
  
IF(@TaskTypeID=502)  
 BEGIN  
  
 --SELECT @purposeID =(select PurposeID from CRE.dealfunding where DealfundingID=@TaskID)  
 --SELECT @WorkflowType  = (Select Value1 from core.Lookup where LookupID = @purposeID)  
 --SELECT  @CREDealID =(select d.CREDealID from CRE.DealFunding df join CRE.Deal d on df.DealID=d.DealID WHERE df.DealFundingID=@TaskID)  
 --SELECT  @dealid = (select dealid from cre.DealFunding where DealFundingID = @TaskID)  
 --select @DebtAmount = Amount from CRE.dealfunding where DealfundingID=@TaskID  
  
  --start  
   
  
 select @dealid = dealid ,  
 @purposeID = PurposeID,  
 @DebtAmount = Amount  
 from cre.DealFunding where DealFundingID = @TaskID  
  
 SELECT  @CREDealID =CREDealID from CRE.Deal where dealid = @dealid 
 SELECT @WorkflowType  = (Select Value1 from core.Lookup where LookupID = @purposeID)  
 IF EXISTS( SELECT 1 from @CheckListDetail where CheckListStatus=881 and  taskid = @TaskID)
 BEGIN
    SET @SkipWorkflowNotification=1
 END
  
IF(@lookupidSave = @SubmitType)  
BEGIN  
  
   
 IF NOT EXISTS  
 (  
 select 1 FROM   
 (  
   select top 1 WFTaskDetailID,TaskId,comment,updatedby from [CRE].[WFTaskDetailArchive] where TaskId = @TaskID and TaskTypeID=@TaskTypeID and [SubmitType] = @SubmitType order by updateddate desc  
 ) tbl  
 where tbl.Comment=(case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end) and tbl.UpdatedBy=@CreatedBy  
 )  
 BEGIN  
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
  ,[UpdatedDate])  
  SELECT  
  (SELECT MAX(WFTaskDetailID) from cre.WFTaskDetail where taskid=@TaskID and TaskTypeID=@TaskTypeID ),  
  @WFStatusPurposeMappingID,  
  @TaskID,  
  @TaskTypeID,  
  (case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end),  
  @SubmitType,  
  @CreatedBy,  
  getdate(),  
  @CreatedBy,  
  getdate()  
 END  
END  
ELSE IF(@lookupidSaveAsDraft = @SubmitType)  
BEGIN  
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
 VALUES  
 (  
 @WFStatusPurposeMappingID,  
 @TaskID,  
 @TaskTypeID,  
 (case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end),  
 @SubmitType,  
 @CreatedBy,  
 getdate(),  
 @CreatedBy,  
 getdate(),  
 @DelegatedUserID  
 )  
END  
ELSE IF(@lookupidWFNotification = @SubmitType)  
BEGIN  
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
 VALUES  
 (  
 @WFStatusPurposeMappingID,  
 @TaskID,  
 @TaskTypeID,  
 @Comment,  
 @lookupidSaveAsDraft,  
 @CreatedBy,  
 getdate(),  
 @CreatedBy,  
 getdate(),  
 @DelegatedUserID  
 )  
END  
ELSE IF (@lookupidSave != @SubmitType AND @lookupidSaveAsDraft != @SubmitType)   
BEGIN  
  
 
 
 
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
 VALUES  
 (  
 @WFStatusPurposeMappingID,  
 @TaskID,  
 @TaskTypeID,  
 @Comment,  
 @SubmitType,  
 @CreatedBy,  
 getdate(),  
 @CreatedBy,  
 getdate(),  
 @DelegatedUserID  
 )  
 -- transfer all rows in CRE.WFTaskDetailArchive  table except the latest  
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
 FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID  and   
 WFTaskDetailID <> (select max(WFTaskDetailID) FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID )  
  
    
 --delete archived rows from WFTaskDetail table  
 DELETE FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID  and   
 WFTaskDetailID <> (select max(WFTaskDetailID) FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID )  
  
  --activity log for disbaled prelim and final
  SET @WFStatusName = (select wsm.StatusName from CRE.WFStatusPurposeMapping wfsm inner join CRE.WFStatusMaster wsm on wfsm.WFStatusMasterID = wsm.WFStatusMasterID where WFStatusPurposeMappingID = @WFStatusPurposeMappingID)
 
 IF (@SkipWorkflowNotification=1 and (@WFStatusName='Under Review' or @WFStatusName='Completed'))
 BEGIN
      
     IF @WFStatusName='Under Review'
            Set @SkipWorkflowNotificationComment= 'No preliminary notification was sent because it was disabled.'
     ELSE IF @WFStatusName='Completed'
            Set @SkipWorkflowNotificationComment= 'No final notification was sent because it was disabled.'
     
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
             VALUES  
             (  
             @WFStatusPurposeMappingID,  
             @TaskID,  
             @TaskTypeID,  
             @SkipWorkflowNotificationComment,  
             497,  
             @CreatedBy,  
             getdate(),  
             @CreatedBy,  
             getdate(),  
             @DelegatedUserID  
             )
 
 END
  
 ----Export WF Status to Backshop (When Status Changed)  
 --Declare @L_StatusName nvarchar(256);  
 --SET @L_StatusName = (Select top 1 wm.StatusName from cre.WFStatusPurposeMapping wsm   
 --inner join cre.WFStatusMaster wm on wm.WFStatusMasterID = wsm.WFStatusMasterID  
 --where wsm.WFStatusPurposeMappingID = @WFStatusPurposeMappingID)  
  
 --Update core.fundingschedule set WF_CurrentStatus = @L_StatusName where dealfundingid = @TaskID  
  
 --Declare @L_DealId UNIQUEIDENTIFIER = (Select top 1 DealID from CRE.DealFunding df where DealFundingID = @TaskID)  
 --Exec [dbo].[usp_ExportFutureFundingToBackshopByDealID] @L_DealId  
    
 --updat phantom deal   
 ---Commented for optimization - Vishal  
 EXEC [dbo].[usp_CopyDealFundingFromLegalToPhantom] @CREDealID  
  
END  
  
  
  if (isnull(@Comment,'')!='Canceled final notification')
  BEGIN
--INsert Update checklist detail  
IF EXISTS(Select WFCheckListDetailID from [CRE].[WFCheckListDetail] where TaskId = @TaskID and TaskTypeID=@TaskTypeID )  
BEGIN  
   
   --Delete   
    DELETE FROM [CRE].[WFCheckListDetail] WHERE WFCheckListDetailID NOT IN  
    (  
  select  wc.WFCheckListDetailID FROM [CRE].[WFCheckListDetail] wc join @CheckListDetail d on wc.WFCheckListDetailID = d.WFCheckListDetailID  
    )  
   and TaskId =@TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID is null  
   
 UPDATE [CRE].[WFCheckListDetail]  
 SET [CRE].[WFCheckListDetail].[CheckListStatus] = tblInCLD.CheckListStatus  
      ,[CRE].[WFCheckListDetail].[Comment] = tblInCLD.Comment  
      ,[CRE].[WFCheckListDetail].[UpdatedBy] = @CreatedBy  
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
  @TaskID,  
  @TaskTypeID,  
  WFCheckListMasterID,  
  CheckListName,  
  CheckListStatus,  
  Comment,  
  @CreatedBy,  
  getdate(),  
  @CreatedBy,  
  getdate()  
  from @CheckListDetail  
  where WFCheckListDetailID is null and NULLIF(CheckListName,'') is not null  
END  
ELSE  
BEGIN  
    
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
  @TaskId,  
  @TaskTypeID,  
  WFCheckListMasterID,  
  null as CheckListName,  
  null as CheckListStatus,  
  null as Comment,  
  @CreatedBy,  
  getdate(),  
  @CreatedBy,  
  getdate()  
  from cre.WFCheckListMaster WHERE WorkFlowType=@WorkflowType  
END  
  
  
---================================================================  
Declare @L_tblCheckListDetail as table  
(  
taskid UNIQUEIDENTIFIER,  
TaskTypeID int,  
WFCheckListMasterID int,  
CheckListStatus int  
)  
INSERT INTO @L_tblCheckListDetail (taskid,TaskTypeID,WFCheckListMasterID,CheckListStatus)  
Select taskid,TaskTypeID,WFCheckListMasterID,CheckListStatus from cre.WFCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID  
  
--Update ckeck list as 'NO' for   
IF EXISTS(Select taskid from @L_tblCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=6 and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=6 and ISNULL(CheckListStatus,550) = 550  
END  
  
--Update ckeck list as 'NO' for Formal Request Received  
IF EXISTS(Select taskid from @L_tblCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=7  and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=7 and ISNULL(CheckListStatus,550) = 550  
END  
  
--Update ckeck list as 'NO' for Receipt of Funds Confirmed  
IF EXISTS(Select taskid from @L_tblCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=8  and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=8 and ISNULL(CheckListStatus,550) = 550  
END  
  
--Update ckeck list as 'YES' for Draw Fee Applicable  
IF EXISTS(Select taskid from @L_tblCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=9  and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=499 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=9 and ISNULL(CheckListStatus,550) = 550  
END  

--Update ckeck list as 'No' for Checked Note Allocations in M61  
IF EXISTS(Select taskid from @L_tblCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=20  and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=20 and ISNULL(CheckListStatus,550) = 550  
END  

--Update ckeck list as 'Lender' for the checklist item 'Financing Source' in M61  
IF EXISTS(Select taskid from @L_tblCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=21  and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=880 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=21 and ISNULL(CheckListStatus,550) = 550  
END  
  
---===========================================================  
END  
  
  
  
  
  
--Insert WF Preliminary notification  
  
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
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
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
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
  END  
  IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Servicer Notification' and IsEnable = 1)  
  BEGIN  
   SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Servicer Notification')  
   SET @MessageHTML = null  
   SET @AdditionalText = null  
   SET @ScheduledDateTime = null  
   SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')  
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
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
  
  ELSE IF (@SkipWorkflowNotification=1 and  @WorkflowType<>'WF_UNDERREVIEW')-- wireconfirm workflow without sending any notification except full pay off  
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
  
  
IF(@L_SubmitType = 'Reject')  
BEGIN  
 IF(@WFStatusName = 'Projected')  
 BEGIN   
  IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification' and IsEnable = 1)  
  BEGIN    
    
   SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification')  
   SET @MessageHTML = null  
   SET @AdditionalText = null  
   SET @ScheduledDateTime = null  
   SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')  
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
  END  
 END  
  
 --delete final and servicer notification if any and not yet sent  
   DELETE FROM cre.WFNotification WHERE  WFNotificationMasterID in (2,3) and ActionType<>577 and TaskID=@TaskID
   --update special instruction and other fileds in case of reject as well
   IF NOT EXISTS (SELECT TaskID FROM CRE.WFTaskAdditionalDetail WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID )  
    BEGIN  
   
       INSERT INTO CRE.WFTaskAdditionalDetail  
           ([TaskID]  
           ,[TaskTypeID]  
           ,[SpecialInstruction]  
           ,[AdditionalComment]  
           ,[CreatedBy]  
           ,[CreatedDate]  
           ,[UpdatedBy]  
           ,[UpdatedDate])  
        VALUES  
        (  
         @TaskID,  
         @TaskTypeID,  
         @SpecialInstructions,  
         @AdditionalComments,  
         @CreatedBy,  
         getdate(),  
         @CreatedBy,  
         getdate()  
       )  
  
  END  
  ELSE  
    BEGIN  
  
      UPDATE CRE.WFTaskAdditionalDetail  
       SET SpecialInstruction = @SpecialInstructions,  
         AdditionalComment = @AdditionalComments,  
         UpdatedBy = @CreatedBy,  
         UpdatedDate = getdate()  
       WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID  
  
    END  
   
   --
END  
  
IF(@L_SubmitType != 'Reject')  
BEGIN  
  
  IF NOT EXISTS (SELECT TaskID FROM CRE.WFTaskAdditionalDetail WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID )  
  BEGIN  
   
   INSERT INTO CRE.WFTaskAdditionalDetail  
       ([TaskID]  
       ,[TaskTypeID]  
       ,[SpecialInstruction]  
       ,[AdditionalComment]  
       ,[CreatedBy]  
       ,[CreatedDate]  
       ,[UpdatedBy]  
       ,[UpdatedDate])  
    VALUES  
    (  
     @TaskID,  
     @TaskTypeID,  
     @SpecialInstructions,  
     @AdditionalComments,  
     @CreatedBy,  
     getdate(),  
     @CreatedBy,  
     getdate()  
   )  
  
  END  
  ELSE  
  BEGIN  
  
  UPDATE CRE.WFTaskAdditionalDetail  
   SET SpecialInstruction = @SpecialInstructions,  
     AdditionalComment = @AdditionalComments,  
     UpdatedBy = @CreatedBy,  
     UpdatedDate = getdate()  
   WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID  
  
  END  
END  
  --end  
 END  
ELSE IF(@TaskTypeID=719)  
BEGIN  
  --start  
   
 SELECT @purposeID =(select PurposeID from CRE.DealReserveSchedule where DealReserveScheduleGUID=@TaskID)  
 SELECT @WorkflowType  = (Select Value1 from core.Lookup where LookupID = @purposeID)  
 SELECT  @CREDealID =d.CREDealID,@IsReoDeal = isnull(IsReoDeal,0) from CRE.DealReserveSchedule df join CRE.Deal d on df.DealID=d.DealID WHERE df.DealReserveScheduleGUID=@TaskID  
 SELECT  @dealid = (select dealid from cre.DealReserveSchedule where DealReserveScheduleGUID = @TaskID)  
 select @DebtAmount = Amount from CRE.DealReserveSchedule where DealReserveScheduleGUID=@TaskID  
IF(@lookupidSave = @SubmitType)  
BEGIN  
  
   
 IF NOT EXISTS  
 (  
 select 1 FROM   
 (  
   select top 1 WFTaskDetailID,TaskId,comment,updatedby from [CRE].[WFTaskDetailArchive] where TaskId = @TaskID and TaskTypeID=@TaskTypeID and [SubmitType] = @SubmitType order by updateddate desc  
 ) tbl  
 where tbl.Comment=(case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end) and tbl.UpdatedBy=@CreatedBy  
 )  
 BEGIN  
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
           ,[UpdatedDate])  
     SELECT  
   (SELECT MAX(WFTaskDetailID) from cre.WFTaskDetail where taskid=@TaskID and TaskTypeID=@TaskTypeID ),  
   @WFStatusPurposeMappingID,  
   @TaskID,  
   @TaskTypeID,  
   (case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end),  
   @SubmitType,  
   @CreatedBy,  
   getdate(),  
   @CreatedBy,  
   getdate()  
 END  
END  
  
ELSE IF(@lookupidSaveAsDraft = @SubmitType)  
BEGIN  
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
   VALUES  
   (  
    @WFStatusPurposeMappingID,  
    @TaskID,  
    @TaskTypeID,  
    (case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end),  
    @SubmitType,  
    @CreatedBy,  
    getdate(),  
    @CreatedBy,  
    getdate(),  
    @DelegatedUserID  
   )  
  
END  
ELSE IF(@lookupidWFNotification = @SubmitType)  
BEGIN  
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
   VALUES  
   (  
    @WFStatusPurposeMappingID,  
    @TaskID,  
    @TaskTypeID,  
    @Comment,  
    @lookupidSaveAsDraft,  
    @CreatedBy,  
    getdate(),  
    @CreatedBy,  
    getdate(),  
    @DelegatedUserID  
   )  
END  
ELSE IF (@lookupidSave != @SubmitType AND @lookupidSaveAsDraft != @SubmitType)   
BEGIN  
  
  
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
     VALUES  
  (  
   @WFStatusPurposeMappingID,  
   @TaskID,  
   @TaskTypeID,  
   @Comment,  
   @SubmitType,  
   @CreatedBy,  
   getdate(),  
   @CreatedBy,  
   getdate(),  
   @DelegatedUserID  
  )  
  -- transfer all rows in CRE.WFTaskDetailArchive  table except the latest  
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
   FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID  and   
   WFTaskDetailID <> (select max(WFTaskDetailID) FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID )  
  
    
  --delete archived rows from WFTaskDetail table  
  DELETE FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID  and   
     WFTaskDetailID <> (select max(WFTaskDetailID) FROM [CRE].[WFTaskDetail] where TaskID = @TaskID and TaskTypeID=@TaskTypeID )  
  
END  
  
  
  
  
  
  
  
  if (@Comment!='Canceled reserve final notification')
  BEGIN
  
--INsert Update checklist detail  
IF EXISTS(Select * from [CRE].[WFCheckListDetail] where TaskId = @TaskID and TaskTypeID=@TaskTypeID )  
BEGIN  
   
   --Delete   
    DELETE FROM [CRE].[WFCheckListDetail] WHERE WFCheckListDetailID NOT IN  
    (  
  select  wc.WFCheckListDetailID FROM [CRE].[WFCheckListDetail] wc join @CheckListDetail d on wc.WFCheckListDetailID = d.WFCheckListDetailID  
    )  
   and TaskId =@TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID is null  
   
 UPDATE [CRE].[WFCheckListDetail]  
 SET [CRE].[WFCheckListDetail].[CheckListStatus] = tblInCLD.CheckListStatus  
      ,[CRE].[WFCheckListDetail].[Comment] = tblInCLD.Comment  
      ,[CRE].[WFCheckListDetail].[UpdatedBy] = @CreatedBy  
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
  @TaskID,  
  @TaskTypeID,  
  WFCheckListMasterID,  
  CheckListName,  
  CheckListStatus,  
  Comment,  
  @CreatedBy,  
  getdate(),  
  @CreatedBy,  
  getdate()  
  from @CheckListDetail  
  where WFCheckListDetailID is null and NULLIF(CheckListName,'') is not null  
END  
ELSE  
BEGIN  
 /*  
    INSERT INTO [CRE].[WFCheckListDetail]  
           ([TaskId]  
           ,[WFCheckListMasterID]  
           ,[CheckListName]  
           ,[CheckListStatus]  
           ,[Comment]  
           ,[CreatedBy]  
           ,[CreatedDate]  
           ,[UpdatedBy]  
           ,[UpdatedDate])  
 Select  
  @TaskId,  
  WFList.WFCheckListMasterID,  
  null as CheckListName,  
  WFList.CheckListStatus,  
  null as Comment,  
  @CreatedBy,  
  getdate(),  
  @CreatedBy,  
  getdate()  
  from [CRE].[WFCheckListDetail] WFList WHERE TaskID =  
 (  
  Select TOP 1 wf.TaskID from [CRE].[WFTaskDetail] wf WHERE TaskId IN  
   (  
   Select df.DealFundingID from CRE.DealFunding df WHERE df.DealID IN (  
     Select DealID from CRE.DealFunding WHERE DealFundingID = @TaskId -- current taslID  
   )  
  ) AND wf.WFStatusPurposeMappingID = 6 ORDER BY WFTaskDetailID DESC  
 )  
 AND WFList.WFCheckListMasterID IS NOT NULL;  
 */  
   
   
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
  @TaskId,  
  @TaskTypeID,  
  WFCheckListMasterID,  
  null as CheckListName,  
  null as CheckListStatus,  
  null as Comment,  
  @CreatedBy,  
  getdate(),  
  @CreatedBy,  
  getdate()  
  from cre.WFCheckListMaster WHERE WorkFlowType=@WorkflowType  
  and ((@IsReoDeal=0 and WFCheckListMasterID not in (16,17)) OR @IsReoDeal=1)  
END  
  
---====================================================  
Declare @L_tblCheckListDetail_1 as table  
(  
taskid UNIQUEIDENTIFIER,  
TaskTypeID int,  
WFCheckListMasterID int,  
CheckListStatus int  
)  
INSERT INTO @L_tblCheckListDetail_1 (taskid,TaskTypeID,WFCheckListMasterID,CheckListStatus)  
Select taskid,TaskTypeID,WFCheckListMasterID,CheckListStatus from cre.WFCheckListDetail where taskid = @TaskID and TaskTypeID=@TaskTypeID  
  
  
  
--Update ckeck list as 'NO' for Funding Team’s Approval Required  
IF EXISTS(Select taskid from @L_tblCheckListDetail_1 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=15 and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=15 and ISNULL(CheckListStatus,550) = 550  
END  
  
--Update ckeck list as 'NO' for Include Acore Accounting in notifications  
IF EXISTS(Select taskid from @L_tblCheckListDetail_1 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=16 and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=16 and ISNULL(CheckListStatus,550) = 550  
END  
  
--Update ckeck list as 'NO' for Include Property Mangers in notification  
IF EXISTS(Select taskid from @L_tblCheckListDetail_1 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=17 and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=17 and ISNULL(CheckListStatus,550) = 550  
END  
  
--Update ckeck list as 'NO' for Verify Servicer Balance in notification  
IF EXISTS(Select taskid from @L_tblCheckListDetail_1 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=18 and ISNULL(CheckListStatus,550) = 550)  
BEGIN  
 Update cre.WFCheckListDetail  set CheckListStatus=616 where taskid = @TaskID and TaskTypeID=@TaskTypeID and WFCheckListMasterID=18 and ISNULL(CheckListStatus,550) = 550  
END  
--=============================================  
  
--Insert WF Preliminary notification  
  END
SET @WFStatusName = (select wsm.StatusName from CRE.WFStatusPurposeMapping wfsm inner join CRE.WFStatusMaster wsm on wfsm.WFStatusMasterID = wsm.WFStatusMasterID where WFStatusPurposeMappingID = @WFStatusPurposeMappingID)  
SET @L_SubmitType = (Select [name] from core.lookup  where ParentID=77 and lookupid = @SubmitType)  
  
IF(@L_SubmitType = 'Submit for Approver')  
BEGIN  
 IF(@WFStatusName = 'Requested')  
 BEGIN   
  IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Reserve Preliminary Notification' and IsEnable = 1)  
  BEGIN  
   SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Reserve Preliminary Notification')  
   SET @MessageHTML = null  
   SET @AdditionalText = null  
   SET @ScheduledDateTime = null  
   SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')  
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
  END  
 END  
 ELSE IF(@WFStatusName = 'Completed')  
 BEGIN   
  IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Reserve Final Notification' and IsEnable = 1)  
  BEGIN  
   SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Reserve Final Notification')  
   SET @MessageHTML = null  
   SET @AdditionalText = null  
   SET @ScheduledDateTime = null  
   SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')  
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
  END  
    
 END  
END  
  
  
IF(@L_SubmitType = 'Reject')  
BEGIN  
 IF(@WFStatusName = 'Projected')  
 BEGIN   
  IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Reserve Preliminary Notification' and IsEnable = 1)  
  BEGIN    
    
   SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Reserve Preliminary Notification')  
   SET @MessageHTML = null  
   SET @AdditionalText = null  
   SET @ScheduledDateTime = null  
   SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')  
  
   EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@TaskTypeID,@TaskID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null  
  END  
 END  
  
 --delete final and servicer notification if any and not yet sent  
   DELETE FROM cre.WFNotification WHERE  WFNotificationMasterID in (4,5) and ActionType<>577 and TaskID=@TaskID 
    --update special instruction and other fileds in case of reject as well
   IF NOT EXISTS (SELECT TaskID FROM CRE.WFTaskAdditionalDetail WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID )  
    BEGIN  
   
       INSERT INTO CRE.WFTaskAdditionalDetail  
           ([TaskID]  
           ,[TaskTypeID]  
           ,[SpecialInstruction]  
           ,[AdditionalComment]  
           ,[CreatedBy]  
           ,[CreatedDate]  
           ,[UpdatedBy]  
           ,[UpdatedDate])  
        VALUES  
        (  
         @TaskID,  
         @TaskTypeID,  
         @SpecialInstructions,  
         @AdditionalComments,  
         @CreatedBy,  
         getdate(),  
         @CreatedBy,  
         getdate()  
       )  
  
  END  
  ELSE  
    BEGIN  
  
      UPDATE CRE.WFTaskAdditionalDetail  
       SET SpecialInstruction = @SpecialInstructions,  
         AdditionalComment = @AdditionalComments,  
         UpdatedBy = @CreatedBy,  
         UpdatedDate = getdate()  
       WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID  
  
    END  
   
   --
END  
  
IF(@L_SubmitType != 'Reject')  
BEGIN  
  
  IF NOT EXISTS (SELECT TaskID FROM CRE.WFTaskAdditionalDetail WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID )  
  BEGIN  
   
   INSERT INTO CRE.WFTaskAdditionalDetail  
       ([TaskID]  
       ,[TaskTypeID]  
       ,[SpecialInstruction]  
       ,[AdditionalComment]  
       ,[CreatedBy]  
       ,[CreatedDate]  
       ,[UpdatedBy]  
       ,[UpdatedDate])  
    VALUES  
    (  
     @TaskID,  
     @TaskTypeID,  
     @SpecialInstructions,  
     @AdditionalComments,  
     @CreatedBy,  
     getdate(),  
     @CreatedBy,  
     getdate()  
   )  
  
  END  
  ELSE  
  BEGIN  
  
  UPDATE CRE.WFTaskAdditionalDetail  
   SET SpecialInstruction = @SpecialInstructions,  
     AdditionalComment = @AdditionalComments,  
     UpdatedBy = @CreatedBy,  
     UpdatedDate = getdate()  
   WHERE TaskID = @TaskId and TaskTypeID=@TaskTypeID  
  
  END  
END  
  --end  
 END  
  
  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED       
END  
  
  
  
  