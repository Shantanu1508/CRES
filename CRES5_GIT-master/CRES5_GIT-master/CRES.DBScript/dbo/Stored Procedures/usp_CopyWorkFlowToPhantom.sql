

CREATE PROCEDURE [dbo].[usp_CopyWorkFlowToPhantom]
(
	@PhtmDealID UNIQUEIDENTIFIER
)
  
AS
  BEGIN
  SET NOCOUNT ON;  



 
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

Select 
wfd.[WFStatusPurposeMappingID]
,df.DealFundingID as [TaskID]
,wfd.[TaskTypeID]
,wfd.[Comment]
,wfd.[SubmitType]
,wfd.[CreatedBy]
,wfd.[CreatedDate]
,wfd.[UpdatedBy]
,wfd.[UpdatedDate]
,wfd.[IsDeleted]
from [CRE].[WFTaskDetail] wfd
inner join cre.dealfunding df on df.LegalDeal_DealFundingID = wfd.TaskID
inner join cre.deal d on d.DealID = df.DealID
where d.DealID = @PhtmDealID and df.applied = 0
 

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
df.DealFundingID as [TaskID]
,wfd.[WFCheckListMasterID]
,wfd.[CheckListName]
,wfd.[CheckListStatus]
,wfd.[Comment]
,wfd.[CreatedBy]
,wfd.[CreatedDate]
,wfd.[UpdatedBy]
,wfd.[UpdatedDate]
from [CRE].[WFCheckListDetail] wfd
inner join cre.dealfunding df on df.LegalDeal_DealFundingID = wfd.TaskID
inner join cre.deal d on d.DealID = df.DealID
where d.DealID = @PhtmDealID and df.applied = 0


INSERT INTO [CRE].WFTaskAdditionalDetail 
([TaskId]
,SpecialInstruction 
,AdditionalComment
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])
Select 
df.DealFundingID as [TaskID]
,wfd.SpecialInstruction
,wfd.AdditionalComment
,wfd.[CreatedBy]
,wfd.[CreatedDate]
,wfd.[UpdatedBy]
,wfd.[UpdatedDate]
from [CRE].WFTaskAdditionalDetail  wfd
inner join cre.dealfunding df on df.LegalDeal_DealFundingID = wfd.TaskID
inner join cre.deal d on d.DealID = df.DealID
where d.DealID = @PhtmDealID and df.applied = 0


--Send Final notification
INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
Select 2,df.DealFundingID,null,null,577,wfd.[CreatedBy],wfd.[CreatedDate],wfd.[UpdatedBy],wfd.[UpdatedDate],'Final',null
from [CRE].[WFNotification] wfd
inner join cre.dealfunding df on df.LegalDeal_DealFundingID = wfd.TaskID
inner join cre.deal d on d.DealID = df.DealID
where wfd.WFNotificationMasterID = 2
and d.DealID = @PhtmDealID and df.applied = 0


END
