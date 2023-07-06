
CREATE PROCEDURE [CRE].[usp_InsertUpdateWFNotification] 
(
	@WFNotificationMasterID int,
	@TaskTypeID int,
	@TaskID uniqueidentifier,
	@MessageHTML nvarchar(max),
	@AdditionalText   nvarchar(256),
	@ScheduledDateTime Datetime,
	@ActionType int,
	@UserID nvarchar(256),
	@EmailTo nvarchar(max),
	@EmailCC nvarchar(max),
	@AdditionalComments nvarchar(max) = null,
    @SpecialInstructions nvarchar(max) = null,
	@DelegatedUserID nvarchar(max) = null,
	@CheckListDetail tblType_CheckListDetail readonly
)
AS
BEGIN
	SET NOCOUNT ON;

Declare @dealid UNIQUEIDENTIFIER;
Declare @dealFundingData decimal(28,15);
Declare @dealFDate Date;
Declare @WFStatusName nvarchar(256)
Declare  @CREDealID nvarchar(256)
DECLARE @MessageData nvarchar(MAX);
DECLARE @WFStatusPurposeMappingID INT
DECLARE @NotificationMasterName  nvarchar(256) 
Declare @L_ActionTypeNone int
Declare @L_ActionTypeSend int
Declare @L_ActionTypeScheduled int
Declare @WFNotificationID int
Declare @NotificationTypeFlag nvarchar(256);
DECLARE @PurposeID int
--Delete Non send notification data
Delete from cre.wfnotification where taskid = @TaskID and TaskTypeID = @TaskTypeID and ActionType = 575

IF(@TaskTypeID=502)
	BEGIN
	--start
	   --===========Take Client wise data===========================

Select @dealid = dealid,@dealFundingData = amount,@dealFDate = [date] from cre.DealFunding where DealFundingID = @TaskID
set  @CREDealID =(select d.CREDealID from CRE.DealFunding df join CRE.Deal d on df.DealID=d.DealID WHERE df.DealFundingID=@TaskID)


		select @MessageData = STUFF((select '|'+ replace(ClientName,'aaaaa','') +'#'+ Value from 
		(
			select ClientName,Cast(Cast(ROUND(SUM(Value),2)  as decimal(28,2)) as nvarchar(256)) as Value
			from
			(
			select ClientName =(case when l.IsThirdParty=0 then +'aaaaa'+ISNULL(l.ParentClient,l.FinancingSourceName) else l.ParentClient end), fs.Value from [CORE].FundingSchedule fs
			INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
			INNER JOIN (
							
							Select 
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
								MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
								from [CORE].[Event] eve
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
								where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
								and n.NoteID in (
									select distinct n.noteid
									FROM cre.deal d
									inner join cre.note n ON d.dealid = n.dealid
									left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
									left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient and wf.LookupId <> 607
									
									join cre.dealfunding df on df.dealid = d.dealid 
									--WHERE n.ClientID is not null
									and df.dealfundingid =  @TaskID 			   
								) 
								and acc.IsDeleted = 0 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID	and fs.DealFundingRowno=(select DealFundingRowno from cre.DealFunding where dealfundingid =  @TaskID )
			left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
			left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
			where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 
			
		) tbl group by ClientName 
		) tbl1 order by ClientName
		--FOR XML PATH('')), 1, 1, '') as ClientFunding
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)') 
,1,0,'')

SET @MessageData = FORMAT(@dealFDate,'yyyy-MM-dd') +'|'+Cast(Cast(ROUND(@dealFundingData,2)  as decimal(28,2)) as nvarchar(256)) + @MessageData
--======================================

SET @WFStatusPurposeMappingID = (SELECT top 1 td.WFStatusPurposeMappingID FROM [CRE].[WFTaskDetail] td WHERE TaskId = @TaskID and TaskTypeID = @TaskTypeID ORDER BY WFTaskDetailID DESC ) 
SET @WFStatusName = (select wsm.StatusName from CRE.WFStatusPurposeMapping wfsm inner join CRE.WFStatusMaster wsm on wfsm.WFStatusMasterID = wsm.WFStatusMasterID where WFStatusPurposeMappingID = @WFStatusPurposeMappingID)
--========================================================================================================================================


SET @NotificationMasterName = (Select [Name] from cre.WFNotificationMaster where WFNotificationMasterID = @WFNotificationMasterID)

SET @L_ActionTypeNone = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')
SET @L_ActionTypeSend = (Select LookupID from core.lookup where ParentID = 96 and name = 'Sent')
SET @L_ActionTypeScheduled = (Select LookupID from core.lookup where ParentID = 96 and name = 'Scheduled')

IF(@NotificationMasterName = 'Preliminary Notification')

BEGIN
	IF(@L_ActionTypeNone = @ActionType) --Action type is 'None'
	BEGIN
		IF EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType = @ActionType)
		BEGIN	
			Delete from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType <> @L_ActionTypeSend

			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Preliminary Revised',@MessageData)			
		END
		ELSE
		BEGIN
			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Preliminary Revised',@MessageData)			
		END
				
	END
	
	IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================
		

		IF EXISTS(select TaskID from cre.WFNotification where TaskID=@TaskID  and TaskTypeID = @TaskTypeID and WFNotificationMasterID=1 and ActionType=577)
		BEGIN
			SET @NotificationTypeFlag = 'Preliminary Revised'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent revised preliminary notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail
		END
		ELSE
		BEGIN
			SET @NotificationTypeFlag = 'Preliminary'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent preliminary notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		END
		--==============================

		
		SET @WFNotificationID = (Select WFNotificationID from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend)

		Update [CRE].[WFNotification] 
		SET ActionType = @ActionType,
		MessageHTML = @MessageHTML,
		AdditionalText = @AdditionalText
		where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and  ActionType <> @L_ActionTypeSend

		DECLARE @tpWFNotification TABLE (tWFNotificationID int)
		
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
		OUTPUT inserted.WFNotificationID INTO @tpWFNotification(tWFNotificationID)
		VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)	 --@L_ActionTypeNone		

		SELECT @WFNotificationID = tWFNotificationID FROM @tpWFNotification
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

		
		

	END
END

IF(@NotificationMasterName = 'Final Notification')
BEGIN
	IF(@L_ActionTypeNone = @ActionType) --Action type is 'None'
	BEGIN
		IF EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType = @ActionType)
		BEGIN	
			Delete from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend

			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Final Revised',@MessageData)			
		END
		ELSE
		BEGIN
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Final Revised',@MessageData)			
		END
				
	END
	
	IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================		
		IF EXISTS(select TaskID from cre.WFNotification where TaskID=@TaskID  and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=577)
		BEGIN
			SET @NotificationTypeFlag = 'Final Revised'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent revised final Notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail
		END
		ELSE
		BEGIN
			SET @NotificationTypeFlag = 'Final'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent final notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		    
		END
		--==================================
		
		SET @WFNotificationID = (Select WFNotificationID from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend)

		Update [CRE].[WFNotification] 
		SET ActionType = @ActionType,
		MessageHTML = @MessageHTML,
		AdditionalText = @AdditionalText
		where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and  ActionType <> @L_ActionTypeSend

		DECLARE @tfWFNotification TABLE (tWFNotificationID int)
		
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
			OUTPUT inserted.WFNotificationID INTO @tpWFNotification(tWFNotificationID)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)		
		
		SELECT @WFNotificationID = tWFNotificationID FROM @tfWFNotification
		--INsert into [WFNotificationRecipient]

		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)


		IF (@WFStatusName='Completed')
			BEGIN
				UPDATE CRE.DealFunding SET Applied=1,Issaved=1,UpdatedDate=Getdate(),UpdatedBy=@UserID WHERE DealFundingID=@TaskID and  ISNULL(Applied,0) = 0
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
			--update user in invoice detail who wireconfirmed the funding for draw fee becasue we need to display the sender name in draw fee invoice pdf
			 update CRE.InvoiceDetail set [UpdatedBy]=@UserID,[UpdatedDate] = getdate() where ObjectID=@TaskID and ObjectTypeID = 698 and invoicetypeid = 558

			--updat phantom deal on draw wireconfirmed 
		    EXEC [dbo].[usp_CopyDealFundingFromLegalToPhantom] @CREDealID
			EXEC [dbo].[usp_UpdateWireConfirmedForPhantomDeal] @CREDealID
			EXEC [dbo].[usp_ExportFutureFundingToBackshopByDealID] @dealid,@UserID
			END
		

	END
END

IF(@NotificationMasterName = 'Servicer Notification')
BEGIN
	IF(@L_ActionTypeNone = @ActionType) --Action type is 'None'
	BEGIN
		IF EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType = @ActionType)
		BEGIN	
			Delete from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend

			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Servicer Revised',@MessageData)			
		END
		ELSE
		BEGIN
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Servicer Revised',@MessageData)			
		END
				
	END
	
	IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================		
		IF EXISTS(select TaskID from cre.WFNotification where TaskID=@TaskID  and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)
		BEGIN
			SET @NotificationTypeFlag = 'Servicer Revised'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent revised servicer Notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail
		END
		ELSE
		BEGIN
			SET @NotificationTypeFlag = 'Servicer'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent servicer notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		END
		--==================================
		
		SET @WFNotificationID = (Select WFNotificationID from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and ActionType <> @L_ActionTypeSend)

		Update [CRE].[WFNotification] 
		SET ActionType = @ActionType,
		MessageHTML = @MessageHTML,
		AdditionalText = @AdditionalText
		where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and  ActionType <> @L_ActionTypeSend

		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)		
		
		
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)


		

	END
END

IF(@NotificationMasterName = 'Final Notification Without Approval')
BEGIN
  
  IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
  BEGIN
  
--add an entry for revised notification
		DECLARE @tWFNotification TABLE (tWFNotificationID int)

		--==================================		
		IF EXISTS(select TaskID from cre.WFNotification where TaskID=@TaskID  and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=577)
		BEGIN
			set @NotificationTypeFlag ='Final Without Approval Revised'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent revised final Notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail
		END
		ELSE
		BEGIN
			set @NotificationTypeFlag ='Final Without Approval'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent final notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		END
		--==================================
		
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
			OUTPUT inserted.WFNotificationID INTO @tWFNotification(tWFNotificationID)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)		
		
		--INsert into [WFNotificationRecipient]
		SELECT @WFNotificationID = tWFNotificationID FROM @tWFNotification

		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

		IF (@WFStatusName='Completed')
			BEGIN
				UPDATE CRE.DealFunding SET Applied=1,Issaved=1,UpdatedDate=Getdate(),UpdatedBy=@UserID WHERE DealFundingID=@TaskID and  ISNULL(Applied,0) = 0
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
			--update user in invoice detail who wireconfirmed the funding for draw fee becasue we need to display the sender name in draw fee invoice pdf
			 update CRE.InvoiceDetail set [UpdatedBy]=@UserID,[UpdatedDate] = getdate() where ObjectID=@TaskID and ObjectTypeID = 698 and invoicetypeid = 558

			--updat phantom deal on draw wireconfirmed 
		    EXEC [dbo].[usp_CopyDealFundingFromLegalToPhantom] @CREDealID
			EXEC [dbo].[usp_UpdateWireConfirmedForPhantomDeal] @CREDealID
			END
  END
END
	--end
-- cancel prelim notification
IF(@NotificationMasterName = 'Cancel Preliminary Notification')

BEGIN
	IF(@L_ActionTypeNone = @ActionType) --Action type is 'None'
	BEGIN
		IF EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType = @ActionType)
		BEGIN	
			Delete from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType <> @L_ActionTypeSend

			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Preliminary Cancelled',@MessageData)			
		END
		ELSE
		BEGIN
			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Preliminary Cancelled',@MessageData)			
		END
				
	END
	
	IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================
		SET @NotificationTypeFlag = 'Preliminary Cancelled'
		
		select @PurposeID = PurposeID from cre.DealFunding where DealFundingID=@TaskID
		select top 1 @WFStatusPurposeMappingID= WFStatusPurposeMappingID from cre.WFStatusPurposeMapping where WFStatusMasterID=1 and PurposeTypeId=@PurposeID
		
		exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Cancelled preliminary notification',496,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		--==============================

		
		SET @WFNotificationID = (Select WFNotificationID from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend)

		Update [CRE].[WFNotification] 
		SET ActionType = @ActionType,
		MessageHTML = @MessageHTML,
		AdditionalText = @AdditionalText
		where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and  ActionType <> @L_ActionTypeSend

		DECLARE @tcWFNotification TABLE (tWFNotificationID int)
		
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
		OUTPUT inserted.WFNotificationID INTO @tcWFNotification(tWFNotificationID)
		VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)	 --@L_ActionTypeNone		

		SELECT @WFNotificationID = tWFNotificationID FROM @tcWFNotification
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

	END
END
	--
		-- cancel final notification
IF(@NotificationMasterName = 'Cancel Final Notification')

BEGIN
	IF((@L_ActionTypeSend = @ActionType) and
	
	NOT EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType = @ActionType)
	) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================
		SET @NotificationTypeFlag = 'Final Cancelled'
		
		exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Cancelled final notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		--==============================
		DECLARE @tfcWFNotification TABLE (tWFNotificationID int)
		
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
		OUTPUT inserted.WFNotificationID INTO @tfcWFNotification(tWFNotificationID)
		VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)	 --@L_ActionTypeNone		

		SELECT @WFNotificationID = tWFNotificationID FROM @tfcWFNotification
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

	END
END
	END
ELSE IF(@TaskTypeID=719)
BEGIN
	--start
	   --===========Take Client wise data===========================

 

Select @dealid = dealid,@dealFundingData = amount,@dealFDate = [date] from CRE.DealReserveSchedule where DealReserveScheduleGUID = @TaskID
select  @CREDealID =(select d.CREDealID from CRE.DealReserveSchedule df join CRE.Deal d on df.DealID=d.DealID WHERE df.DealReserveScheduleGUID=@TaskID)
--======================================


SET @WFStatusPurposeMappingID = (SELECT top 1 td.WFStatusPurposeMappingID FROM [CRE].[WFTaskDetail] td WHERE TaskId = @TaskID and TaskTypeID = @TaskTypeID ORDER BY WFTaskDetailID DESC ) 
SET @WFStatusName = (select wsm.StatusName from CRE.WFStatusPurposeMapping wfsm inner join CRE.WFStatusMaster wsm on wfsm.WFStatusMasterID = wsm.WFStatusMasterID where WFStatusPurposeMappingID = @WFStatusPurposeMappingID)
--========================================================================================================================================



SET @NotificationMasterName = (Select [Name] from cre.WFNotificationMaster where WFNotificationMasterID = @WFNotificationMasterID)


SET @L_ActionTypeNone = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')
SET @L_ActionTypeSend = (Select LookupID from core.lookup where ParentID = 96 and name = 'Sent')
SET @L_ActionTypeScheduled = (Select LookupID from core.lookup where ParentID = 96 and name = 'Scheduled')



IF(@NotificationMasterName = 'Reserve Preliminary Notification')
BEGIN
	IF(@L_ActionTypeNone = @ActionType) --Action type is 'None'
	BEGIN
		IF EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType = @ActionType)
		BEGIN	
			Delete from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType <> @L_ActionTypeSend

			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Preliminary Revised',@MessageData)			
		END
		ELSE
		BEGIN
			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Preliminary Revised',@MessageData)			
		END
				
	END
	
	IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================
		

		IF EXISTS(select TaskID from cre.WFNotification where TaskID=@TaskID  and TaskTypeID = @TaskTypeID and WFNotificationMasterID=4 and ActionType=577)
		BEGIN
			SET @NotificationTypeFlag = 'Preliminary Revised'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent revised preliminary notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail
		END
		ELSE
		BEGIN
			SET @NotificationTypeFlag = 'Preliminary'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent preliminary notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		END
		--==============================

		
		SET @WFNotificationID = (Select WFNotificationID from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend)

		Update [CRE].[WFNotification] 
		SET ActionType = @ActionType,
		MessageHTML = @MessageHTML,
		AdditionalText = @AdditionalText
		where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and  ActionType <> @L_ActionTypeSend

		DECLARE @trpWFNotification TABLE (tWFNotificationID int)
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
		OUTPUT inserted.WFNotificationID INTO @trpWFNotification(tWFNotificationID)
		VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)	 --@L_ActionTypeNone		

		SELECT @WFNotificationID = tWFNotificationID FROM @trpWFNotification
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

		
		

	END
END

IF(@NotificationMasterName = 'Reserve Final Notification')
BEGIN
	IF(@L_ActionTypeNone = @ActionType) --Action type is 'None'
	BEGIN
		IF EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType = @ActionType)
		BEGIN	
			Delete from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend

			INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Final Revised',@MessageData)			
		END
		ELSE
		BEGIN
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NotificationType,MessageData)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@ActionType,@UserID,getdate(),@UserID,getdate(),'Final Revised',@MessageData)			
		END
				
	END
	
	IF(@L_ActionTypeSend = @ActionType) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================		
		IF EXISTS(select TaskID from cre.WFNotification where TaskID=@TaskID  and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=577)
		BEGIN
			SET @NotificationTypeFlag = 'Final Revised'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent revised final Notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail
		END
		ELSE
		BEGIN
			SET @NotificationTypeFlag = 'Final'
			exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Sent final notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		    
		END
		--==================================
		
		SET @WFNotificationID = (Select WFNotificationID from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and ActionType <> @L_ActionTypeSend)

		Update [CRE].[WFNotification] 
		SET ActionType = @ActionType,
		MessageHTML = @MessageHTML,
		AdditionalText = @AdditionalText
		where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID  and TaskTypeID=@TaskTypeID and  ActionType <> @L_ActionTypeSend
		
		DECLARE @trfWFNotification TABLE (tWFNotificationID int)
		
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
			OUTPUT inserted.WFNotificationID INTO @trfWFNotification(tWFNotificationID)
			VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)		
		
		SELECT @WFNotificationID = tWFNotificationID FROM @trfWFNotification
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

	END
END
	--end

	-- cancel reserve final notification
IF(@NotificationMasterName = 'Cancel Reserve Final Notification')

BEGIN
	IF((@L_ActionTypeSend = @ActionType) and
	
	NOT EXISTS(Select [WFNotificationMasterID] from [CRE].[WFNotification] where [WFNotificationMasterID] = @WFNotificationMasterID and [TaskID] = @TaskID and TaskTypeID = @TaskTypeID and ActionType = @ActionType)
	) --Action type is 'Sent'
	BEGIN

		-- ====Parameter==============================
		--@TaskID nvarchar(max),
		--@WFStatusPurposeMappingID int,
		--@TaskTypeID int,
		--@Comment  nvarchar(max),
		--@SubmitType int,
		--@CreatedBy nvarchar(256),
		--@CheckListDetail tblType_CheckListDetail readonly
		--==================================
		SET @NotificationTypeFlag = 'Reserve Final Cancelled'
		exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'Cancelled reserve final notification',582,@UserID,@AdditionalComments,@SpecialInstructions,@DelegatedUserID,@CheckListDetail			
		--==============================
		
		DECLARE @trfcWFNotification TABLE (tWFNotificationID int)
		
		--add an entry for revised notification
		INSERT INTO [CRE].[WFNotification]([WFNotificationMasterID],[TaskID],[TaskTypeID],[MessageHTML],[ScheduledDateTime],[ActionType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AdditionalText,NotificationType,MessageData)
		OUTPUT inserted.WFNotificationID INTO @trfcWFNotification(tWFNotificationID)
		VALUES(@WFNotificationMasterID,@TaskID,@TaskTypeID,@MessageHTML,@ScheduledDateTime,@L_ActionTypeSend,@UserID,getdate(),@UserID,getdate(),@AdditionalText,@NotificationTypeFlag,@MessageData)	 --@L_ActionTypeNone		

		SELECT @WFNotificationID = tWFNotificationID FROM @trfcWFNotification
		--INsert into [WFNotificationRecipient]
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'To',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailTo)

		
		INSERT INTO [CRE].[WFNotificationRecipient]([WFNotificationID],[UserID],[EmailID],[RecipientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		select @WFNotificationID,null,Value,'CC',@UserID,getdate(),@UserID,GETDATE() from fn_Split(@EmailCC)

	END
END
END



--Delete Non send notification data
Delete from cre.wfnotification where taskid = @TaskID and TaskTypeID = @TaskTypeID and ActionType = 575
	
END
