CREATE PROCEDURE [dbo].[usp_GetWorkflowAdditionalDetailByTaskId] 
(
    @TaskTypeID int,
	@TaskID nvarchar(256),
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Max_WFTaskDetailID int 
	Declare @ApproverUserID uniqueidentifier
	Declare @PurposeID int
	Declare @CurrentStatus nvarchar(256)
	Declare @DealID uniqueidentifier, @SeniorCreNoteID nvarchar(50),@SeniorServicerName nvarchar(100),@ServicerName nvarchar(500)
	Declare @BaseCurrencyName nvarchar(max)
	DECLARE @ServicerEmailID nvarchar(256)
	DECLARE @BerkadiaReserveWFEmail nvarchar(256)
	DECLARE @ServicerEmailIDWithoutWellsBerkadia nvarchar(1000)
	
	DECLARE @AMGroup  nvarchar(256)
	DECLARE @IsREODeal bit=0
	DECLARE @REOEmails nvarchar(256)
	DECLARE @PropertyManagerEmail nvarchar(500)
	DECLARE @AccountingEmail nvarchar(256)
	DECLARE @LastPrelimSentDate datetime
	DECLARE @ACORECreditPartnersIIEmail nvarchar(500)='',
	@RevisedMessage nvarchar(1000)='A Revised [Preliminary or Final] Capital Call is being sent to update ',
	@RevisedMessageFinal nvarchar(1000)='',

	@LastNotificationDate datetime,
	@MsgTypeCount int=0,
	@ChangeType nvarchar(20)='',
	@Comments nvarchar(1000),
	@commentsAsc nvarchar(1000),
	@AdditionalEmail nvarchar(500),
	@NotesWithFSNone nvarchar(500),
	@TotalPendingInvoice int,
	@TotalPendingInvoiceAmt decimal(28,15),
	@IsPrelimDisabled bit=0,
	@IsFinalDisabled bit=0,
	@NoPrelimDate datetime,
	@NoFinalDate datetime,

	@LatestProjectedDate datetime,
	@LatestFinaldDate datetime

	DECLARE @tblRevisedMsg as table
	(
	  RevisedMsg nvarchar(1000),
	  CreatedDate datetime,
	  ChangeType nvarchar(20)
	
	)

	DECLARE @tblDateAmtChange as table
	(
	  Comment nvarchar(1000),
	  TaskID nvarchar(256),
	  TaskTypeID int,
	  CreatedDate datetime
	)

	DECLARE @tblInvoice as table
	(
	  DrawFeeStatus int,
	  Amount decimal(28,15)
	)

	--task detail
		declare @WFTaskDetail as table
		(
		[DealID] uniqueidentifier, 
		[WFTaskDetailID]           INT            NULL,
		[WFStatusPurposeMappingID] INT            NULL,
		[TaskID]                   NVARCHAR (MAX) NULL,
		[TaskTypeID]               INT            NULL,
		[Comment]                  NVARCHAR (MAX) NULL,
		[SubmitType]               INT            NULL,
		[CreatedBy]                NVARCHAR (256) NULL,
		[CreatedDate]              DATETIME       NULL,
		[UpdatedBy]                NVARCHAR (256) NULL,
		[UpdatedDate]              DATETIME       NULL,
		[IsDeleted]                BIT            NULL,
		[DelegatedUserID]          NVARCHAR (256) NULL,
		[Date]                      DATE             NULL,
		[DeadLineDate]              DATE             NULL,
		[Amount]                    DECIMAL (28, 15) NULL,
		[PurposeID]                 INT              NULL,
		[Applied]                   BIT              NULL,
		[DealComment]                   NVARCHAR (MAX)   NULL,
		[DrawFundingId]             NVARCHAR (256)   NULL,
		[RequiredEquity]            DECIMAL (28, 15) NULL,
		[AdditionalEquity]          DECIMAL (28, 15) NULL,
		[DealName]                             NVARCHAR (256)   NULL,
		[CREDealID]                            NVARCHAR (256)   NULL,
		[BoxDocumentLink]                      NVARCHAR (500)   NULL,
		[AMUserID]                             UNIQUEIDENTIFIER NULL,
		[AMSecondUserID]                       UNIQUEIDENTIFIER NULL,
		[AMTeamLeadUserID]                     UNIQUEIDENTIFIER NULL,
		[IsREODeal]                            BIT              NULL,
		[WatchlistStatus]                      NVARCHAR (256)   NULL,
		[AlternateAssetManager2ID]             UNIQUEIDENTIFIER NULL,
		[AlternateAssetManager3ID]             UNIQUEIDENTIFIER NULL
		)

		--task detail archieve

		declare @WFTaskDetailArchive as table
		(
		[WFTaskDetailArchiveID]    INT            NULL,
		[WFTaskDetailID]           INT            NULL,
		[WFStatusPurposeMappingID] INT            NULL,
		[TaskID]                   NVARCHAR (MAX) NULL,
		[TaskTypeID]               INT            NULL,
		[Comment]                  NVARCHAR (MAX) NULL,
		[SubmitType]               INT            NULL,
		[CreatedBy]                NVARCHAR (256) NULL,
		[CreatedDate]              DATETIME       NULL,
		[UpdatedBy]                NVARCHAR (256) NULL,
		[UpdatedDate]              DATETIME       NULL,
		[IsDeleted]                BIT            NULL,
		[DelegatedUserID]          NVARCHAR (256) NULL
		)

		declare @WFNotification as table 
		(
		[WFNotificationID]       INT,
		[WFNotificationMasterID] INT              NULL, 
		[TaskID]                 UNIQUEIDENTIFIER NULL,
		[CreatedBy]              NVARCHAR (256)   NULL,
		[CreatedDate]            DATETIME         NULL,
		[UpdatedBy]              NVARCHAR (256)   NULL,
		[UpdatedDate]            DATETIME         NULL,
		[NotificationType]       NVARCHAR (256)   NULL,
		[TaskTypeID] INT              NULL,
		[ActionType]             INT              NULL
		)
		INSERT INTO @WFNotification
		select [WFNotificationID],
		[WFNotificationMasterID],
		[TaskID],
		[CreatedBy],
		[CreatedDate],
		[UpdatedBy],
		[UpdatedDate],
		[NotificationType],
		[TaskTypeID],
		[ActionType]
		FROM CRE.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID
	IF(@TaskTypeID=502)
	BEGIN
	
		Select @DealID = DealID, @PurposeID = PurposeID from cre.DealFunding where DealFundingid = @TaskID

						insert into @WFTaskDetail
				(
				[DealID], 
				[WFTaskDetailID],          
				[WFStatusPurposeMappingID] ,
				[TaskID]  ,                 
				[TaskTypeID]    ,           
				[Comment]   ,               
				[SubmitType]   ,            
				[CreatedBy]    ,           
				[CreatedDate]   ,           
				[UpdatedBy]      ,          
				[UpdatedDate]   ,           
				[IsDeleted]       ,         
				[DelegatedUserID],
				[Date],
				[DeadLineDate],
				[Amount],
				[PurposeID],
				[Applied],
				[DealComment],
				[DrawFundingId],
				[RequiredEquity],
				[AdditionalEquity],
				[DealName],
				[CREDealID],
				[BoxDocumentLink],
				[AMUserID],
				[AMSecondUserID],
				[AMTeamLeadUserID],
				[IsREODeal],
				[WatchlistStatus],
				[AlternateAssetManager2ID],
				[AlternateAssetManager3ID]
				)        

				select distinct 
				@DealID,
				w.[WFTaskDetailID],          
				w.[WFStatusPurposeMappingID] ,
				w.[TaskID]  ,                 
				w.[TaskTypeID]    ,           
				w.[Comment]   ,               
				w.[SubmitType]   ,            
				w.[CreatedBy]    ,           
				w.[CreatedDate]   ,           
				w.[UpdatedBy]      ,          
				w.[UpdatedDate]   ,           
				w.[IsDeleted]       ,         
				[DelegatedUserID],
				df.Date,
				df.DeadLineDate,
				df.Amount,
				df.PurposeID,
				df.Applied,
				df.Comment,
				df.DrawFundingID,
				isnull(df.RequiredEquity,0) as RequiredEquity,
				isnull(df.AdditionalEquity,0) as AdditionalEquity,
				d.dealname,
				d.CREDealID,
				d.BoxDocumentLink,
				d.AMUserID,
				d.AMSecondUserID,
				d.AMTeamLeadUserID,
				isnull(d.IsREODeal,0) as IsREODeal,
				d.WatchlistStatus,
				d.[AlternateAssetManager2ID],
				d.[AlternateAssetManager3ID]
				from cre.WFTaskDetail w join cre.DealFunding df on df.DealFundingID=w.TaskID
				join Cre.Deal d on d.dealid=df.dealid
				where w.TaskTypeID=@TaskTypeID
				and d.DealID=@DealID


				insert into @WFTaskDetailArchive
				select distinct 
				[WFTaskDetailArchiveID],
				[WFTaskDetailID] ,      
				[WFStatusPurposeMappingID],
				[TaskID] ,                  
				[TaskTypeID]   ,        
				[Comment] ,                 
				[SubmitType],
				[CreatedBy] ,               
				[CreatedDate],
				[UpdatedBy],
				[UpdatedDate],
				[IsDeleted],
				[DelegatedUserID]
				FROM Cre.WFTaskDetailArchive w
				where w.TaskTypeID=@TaskTypeID
				and w.TaskID=@TaskID

			INSERT INTO @tblDateAmtChange 
			SELECT Comment,TaskID,TaskTypeID,CreatedDate FROM @WFTaskDetail WHERE TaskID=@TaskID and TaskTypeID=@TaskTypeID and (Comment like '%Changed the funding date%' or Comment like '%Changed the funding amount%') 
			UNION
			SELECT Comment,TaskID,TaskTypeID,CreatedDate FROM @WFTaskDetailArchive WHERE TaskID=@TaskID and TaskTypeID=@TaskTypeID and (Comment like '%Changed the funding date%' or Comment like '%Changed the funding amount%')


		
		
		select top 1 @NoPrelimDate = CreatedDate  from 
		(
			select CreatedDate from @WFTaskDetail where TaskID=@TaskID and Comment like '%No preliminary notification was sent%'
			union
			select CreatedDate from @WFTaskDetailArchive where TaskID=@TaskID and Comment like '%No preliminary notification was sent%'
		)tbl order by CreatedDate desc

		select top 1 @NoFinalDate = CreatedDate  from 
		(
			select CreatedDate from @WFTaskDetail where TaskID=@TaskID and Comment like '%No final notification was sent%'
			union
			select CreatedDate from @WFTaskDetailArchive where TaskID=@TaskID and Comment like '%No final notification was sent%'
		)tbl order by CreatedDate desc
	
	IF (@NoPrelimDate is not null)
	BEGIN

		--get latest projected status date
			select top 1 @LatestProjectedDate = CreatedDate from
			(
			select td.CreatedDate from @WFTaskDetail td
			inner join cre.WFStatusPurposeMapping m on m.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = m.WFStatusMasterID
			where TaskID=@TaskID and TaskTypeID=@TaskTypeID 
			--and PurposeTypeId = @PurposeID
			and (SubmitType=498 or SubmitType=496) and sm.WFStatusMasterID=1
			union
			select td.CreatedDate from @WFTaskDetailArchive td
			inner join cre.WFStatusPurposeMapping m on m.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = m.WFStatusMasterID
			where TaskID=@TaskID and TaskTypeID=@TaskTypeID 
			--and PurposeTypeId = @PurposeID
			and (SubmitType=498 or SubmitType=496) and sm.WFStatusMasterID=1
			) tbl order by CreatedDate desc

			IF (@NoPrelimDate>@LatestProjectedDate)
			BEGIN
				set @IsPrelimDisabled=1
			END

	END

	IF (@NoFinalDate is not null)
	BEGIN

		--get latest projected status date
			select top 1 @LatestFinaldDate = CreatedDate from
			(
			select td.CreatedDate from @WFTaskDetail td
			inner join cre.WFStatusPurposeMapping m on m.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = m.WFStatusMasterID
			where TaskID=@TaskID and TaskTypeID=@TaskTypeID 
			--and PurposeTypeId = @PurposeID
			and (SubmitType=498 or SubmitType=496) and sm.WFStatusMasterID=5
			union
			select td.CreatedDate from @WFTaskDetailArchive td
			inner join cre.WFStatusPurposeMapping m on m.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = m.WFStatusMasterID
			where TaskID=@TaskID and TaskTypeID=@TaskTypeID 
			--and PurposeTypeId = @PurposeID
			and (SubmitType=498 or SubmitType=496) and sm.WFStatusMasterID=5
			) tbl order by CreatedDate desc

			IF (@NoFinalDate>@LatestFinaldDate)
			BEGIN
				set @IsFinalDisabled=1
			END

	END

	
	select top 1  @LastPrelimSentDate = CreatedDate from @WFNotification where taskid=@TaskID and NotificationType in ('Preliminary','Preliminary Revised')
	and TaskTypeID=@TaskTypeID order by CreatedDate desc
	
	select @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from @WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)

	Select @DealID = DealID, @PurposeID = PurposeID from cre.DealFunding where DealFundingid = @TaskID
	select  @AdditionalEmail = AdditionalEmail from cre.WFTaskAdditionalDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID


		insert into @tblInvoice
		select DrawFeeStatus,isnull(i.Amount,0) from cre.InvoiceDetail i 
		join cre.dealfunding df on i.ObjectID=df.DealFundingID
		join cre.Deal d on d.DealID=df.DealID
		and i.InvoiceTypeID=558 and i.ObjectTypeID=698 
		where d.DealID=@DealID
		and d.IsDeleted = 0
		and dateadd(d,3,df.[Date])<getdate()
		--and i.DrawFeeStatus=693

		select @TotalPendingInvoice=count(1),@TotalPendingInvoiceAmt=isnull(sum(Amount),0) from @tblInvoice 
		where DrawFeeStatus=693
		

	if (@AdditionalEmail is null or @AdditionalEmail='')
	BEGIN
	   select top 1 @AdditionalEmail= AdditionalEmail from cre.WFTaskAdditionalDetail where TaskID in 
	   (
	        select  taskid from cre.WFTaskAdditionalDetail t join cre.DealFunding d on d.DealFundingID=t.TaskID where d.DealID = @DealID
	   )
	   and TaskTypeID=@TaskTypeID
	   order by AdditionalEmailUpdatedDate desc
	END


	select @BaseCurrencyName = ISNULL((SELECT TOP 1  ISNULL(REPLACE(l.Name,'CAD','USD'),'USD') as Name
											FROM cre.note n
											left join  core.account acc on n.Account_AccountID = acc.AccountID
											left join core.lookup l on l.lookupid = acc.BaseCurrencyID
											left join cre.deal d on d.DealID = n.DealID
											WHERE d.DealID = @Dealid
											ORDER BY case when l.Name = 'USD' then 9999 else 1 end desc) ,'USD')

	select @ApproverUserID = CreatedBy from @WFTaskDetail where WFTaskDetailID =(Select MAX(WFTaskDetailID) from @WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and SubmitType=498)
	
	SET @CurrentStatus = (Select top 1 sm.StatusName from @WFTaskDetail td
	inner join cre.WFStatusPurposeMapping m on m.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
	inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = m.WFStatusMasterID
	where taskid = @TaskID and TaskTypeID=@TaskTypeID and PurposeTypeId = @PurposeID)
	

	--SET @ServicerEmailID = (
	--				Select  Distinct s.EmailID + ','
	--				from cre.Deal d
	--				inner join CRE.Note n on n.dealid = d.dealid
	--				left join cre.Servicer s on s.ServicerID = n.ServicerNameID
	--				where 
	--				n.ServicerNameID is not null
	--				and d.IsDeleted <> 1
	--				and d.dealid = @DealID
	--				FOR XML PATH('') 
	--				)

	--get the servicer email ids on notes particepating in funding
	--Received requirement from rohit and json for this changes
	
	SET @ServicerEmailID = (SELECT Distinct
				s.EmailID + ','
				FROM [CORE].FundingSchedule fs
				INNER JOIN [CORE].[Event] e ON e.EventID = fs.EventId
				INNER JOIN 
				(
					SELECT 
					(SELECT AccountID FROM [CORE].[Account] ac WHERE ac.AccountID = ns.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					FROM [CORE].[Event] eve INNER JOIN [CRE].[Note] ns ON ns.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = ns.Account_AccountID
					WHERE EventTypeID = (SELECT LookupID FROM CORE.[Lookup] WHERE [Name] = 'FundingSchedule')
					AND acc.IsDeleted = 0
					AND eve.StatusID = (SELECT LookupID FROM Core.Lookup WHERE [Name] = 'Active' AND ParentID = 1)
					GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID
				) sEvent

				ON sEvent.AccountID = e.AccountID AND e.EffectiveStartDate = sEvent.EffectiveStartDate AND e.EventTypeID = sEvent.EventTypeID
				LEFT JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN cre.Servicer s on s.ServicerID = n.ServicerNameID
				INNER JOIN [CRE].Deal d ON n.DealID = d.DealID
				WHERE sEvent.StatusID = e.StatusID 
				AND acc.IsDeleted = 0 
				and n.ServicerNameID is not null
				AND fs.DealFundingID = @TaskID
				FOR XML PATH('') )

	
	--IF exists(select 1 from cre.Note n join core.Account ac on n.Account_AccountID=ac.AccountID where n.FinancingSourceID=45 and n.DealID=@DealID
	--and ac.IsDeleted=0 )

	--for ACORE Special Sits and ACP II -add email acorepefs@statestreet.com in cc

	IF exists
	(
		select 1 from cre.Note n join core.Account ac on n.Account_AccountID=ac.AccountID
		join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID=n.FinancingSourceID
		where (fm.ParentClient ='ACP II' or fm.ParentClient = 'ACORE Special Sits') and n.DealID=@DealID
		and ac.IsDeleted=0
	)

	BEGIN
		SELECT @ACORECreditPartnersIIEmail = STUFF((
			select  Distinct ',' + EmailID from app.EmailNotification where ModuleId=791
			FOR XML PATH('') 
		), 1, 1, '')
	END

--Get senior note and their servicer name
select  top 1 @SeniorCreNoteID =n.ServicerID,@SeniorServicerName =s.ServicerName from cre.note n 
join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
left join CRE.Servicer s on s.ServicerID = n.ServicerNameID
join cre.deal d on d.dealid=n.dealid
where 
--DebtTypeID=442   
--and  
fs.isThirdParty=0
and acc.IsDeleted = 0
and n.ActualPayOffDate is null
and d.dealid=@DealID
order by ISNULL(DebtTypeID,0),ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 

--Get servicer name for the payoff/paydown notification 
SELECT @ServicerName =STUFF((
			select  Distinct ',' + s.ServicerName from cre.note n 
join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
left join CRE.Servicer s on s.ServicerID = n.ServicerNameID
join cre.deal d on d.dealid=n.dealid
and acc.IsDeleted = 0
and d.dealid=@DealID
FOR XML PATH('') 
		), 1, 1, '')

--get notes having financing source ='None'
       SELECT @NotesWithFSNone = STUFF((
		select Distinct ',' +ac.Name from cre.Note n join core.Account ac on  n.Account_AccountID=ac.AccountID  
        where n.DealID=@DealID and isnull(ac.IsDeleted,0)=0 and (n.FinancingSourceID=18 or isnull(FinancingSourceID,'')='') 
        FOR XML PATH('') 
		), 1, 1, '')
--

		--format revised prilim/final message in case of funding date or amount gets changed
		IF EXISTS(
			SELECT 1 FROM @WFNotification WHERE TaskID=@TaskID and TaskTypeID=@TaskTypeID and NotificationType='Preliminary'
		)
		BEGIN

			 select @LastNotificationDate = max(UpdatedDate) from  @WFNotification WHERE TaskID=@TaskID and TaskTypeID=@TaskTypeID
			--if change in funding date and amount both
			IF EXISTS(select 1 from @tblDateAmtChange where taskid=@TaskID and TaskTypeID=@TaskTypeID and Comment like '%Changed the funding date%' and Comment like '%Changed the funding amount%' 
		    and CreatedDate>=@LastNotificationDate
			)
			BEGIN
			 INSERT INTO @tblRevisedMsg
			 --select top 1 @RevisedMessage+' '+replace(replace(Comment,'Changed the funding date','the funding date'),'Changed the funding amount','the funding amount')
			 select top 1 Comment,CreatedDate,'AmountAndDate'
			 from @tblDateAmtChange where taskid=@TaskID and TaskTypeID=@TaskTypeID and Comment like '%Changed the funding date%' and Comment like '%Changed the funding amount%'
			 and CreatedDate>=@LastNotificationDate 
			 order by CreatedDate desc

			END
			
			--if change in funding date
			IF EXISTS(select 1 from @tblDateAmtChange where taskid=@TaskID and TaskTypeID=@TaskTypeID and Comment like '%Changed the funding date%' and Comment not like '%Changed the funding amount%'
			and CreatedDate>=@LastNotificationDate
			)
			BEGIN
			 
			 INSERT INTO @tblRevisedMsg
			 --select top 1 @RevisedMessage+' '+replace(Comment,'Changed the funding date','the funding date') 
			 select top 1 Comment,CreatedDate,'Date' 
			 from @tblDateAmtChange where taskid=@TaskID and TaskTypeID=@TaskTypeID and Comment like '%Changed the funding date%' and Comment not like '%Changed the funding amount%' 
			 and CreatedDate>=@LastNotificationDate 
			 order by CreatedDate desc
			END

			--if change in amount
			IF EXISTS(select 1 from @tblDateAmtChange where taskid=@TaskID and TaskTypeID=@TaskTypeID and Comment like '%Changed the funding amount%' and Comment not like '%Changed the funding date%'
			and CreatedDate>=@LastNotificationDate
			)
			BEGIN
			INSERT INTO @tblRevisedMsg
			--select top 1 @RevisedMessage+' '+replace(Comment,'Changed the funding amount','the funding amount')
			select top 1 Comment,CreatedDate,'Amount'
			from @tblDateAmtChange where taskid=@TaskID and TaskTypeID=@TaskTypeID and Comment like '%Changed the funding amount%' and Comment not like '%Changed the funding date%' 
			and CreatedDate>=@LastNotificationDate 
			order by CreatedDate desc
			END

			select @MsgTypeCount = count(1) from @tblRevisedMsg

			IF (@MsgTypeCount>1)
				BEGIN
				     IF (@MsgTypeCount=3)
					      delete from  @tblRevisedMsg where CreatedDate=(select min(CreatedDate) from @tblRevisedMsg)

                     select top 1 @ChangeType=ChangeType,@comments=RevisedMsg from @tblRevisedMsg order by CreatedDate desc
					 select top 1 @commentsAsc=RevisedMsg from @tblRevisedMsg order by CreatedDate
					 
					 IF EXISTS(select 1 from @tblRevisedMsg where ChangeType='AmountAndDate')
					 BEGIN
					      IF (@ChangeType='AmountAndDate')
						  BEGIN
						      select  top 1 @RevisedMessageFinal= RevisedMsg from @tblRevisedMsg order by CreatedDate desc
							  SET @RevisedMessageFinal=replace(@RevisedMessageFinal,'<br>',' and ')
						  END
						  ELSE IF (@ChangeType='Amount')
						   BEGIN
							  select @RevisedMessageFinal = @comments + ' and '+substring(@commentsAsc,charindex('>',@commentsAsc)+1,len(@commentsAsc))
						  END
						  ELSE IF (@ChangeType='Date')
						   BEGIN
						      select @RevisedMessageFinal = substring(@commentsAsc,1,charindex('<',@commentsAsc)-1)+' and '+@comments
						  END
						
					 END
					 ELSE
					 BEGIN
					         Set @RevisedMessageFinal= (select  top 1 RevisedMsg from @tblRevisedMsg order by CreatedDate desc)+ ' and ' +(select  top 1 RevisedMsg from @tblRevisedMsg order by CreatedDate)
					 
					 END
					 IF(@RevisedMessageFinal!='')
					 BEGIN
						SET @RevisedMessageFinal=@RevisedMessageFinal+'.'
					 END

				END
			ELSE IF (@MsgTypeCount=0)
				BEGIN
					SET @RevisedMessageFinal=''
				END
			ELSE 
				BEGIN
					SELECT @RevisedMessageFinal=RevisedMsg from @tblRevisedMsg
					select top 1 @ChangeType=ChangeType,@comments=RevisedMsg from @tblRevisedMsg order by CreatedDate desc

					IF (@ChangeType='AmountAndDate')
					BEGIN
						SET @RevisedMessageFinal=replace(@RevisedMessageFinal,'<br>',' and ')
					END
					IF (@ChangeType='Amount')
					BEGIN
						SELECT @RevisedMessageFinal=replace(RevisedMsg,'<br>','') from @tblRevisedMsg
						SET @RevisedMessageFinal = @RevisedMessageFinal+'. Funding date has not changed.'
					END
					ELSE IF (@ChangeType='Date')
					BEGIN
						SELECT @RevisedMessageFinal=replace(RevisedMsg,'<br>','') from @tblRevisedMsg
						SET @RevisedMessageFinal=@RevisedMessageFinal+'. Total funding amount has not changed.'
					END
				END
			IF (@RevisedMessageFinal!='')
			BEGIN
			   SET @RevisedMessageFinal=@RevisedMessage+@RevisedMessageFinal
			END
			
			select @RevisedMessageFinal = replace(replace(@RevisedMessageFinal,'Changed the funding amount','the funding amount'),'Changed the funding date','the funding date')
			SET @RevisedMessageFinal=replace(@RevisedMessageFinal,'<br>','')
		END
		--

--============================================
	Select 
	td.WFTaskDetailID,
	td.TaskID,
	td.Date,
	td.DeadLineDate,
	td.Amount,
	td.PurposeID,
	lPurposeID.Name as PurposeIDText,
	td.Applied,
	td.DealComment as Comment,
	td.DrawFundingID,
	td.dealname,
	td.CREDealID,
	td.BoxDocumentLink,
	tad.SpecialInstruction,
	tad.AdditionalComment,
	isnull(td.RequiredEquity,0) as RequiredEquity,
	isnull(td.AdditionalEquity,0) as AdditionalEquity,
	--d.AssetManager,
	td.AMSecondUserID,
	td.AMTeamLeadUserID,
	u.FirstName+' '+u.LastName as AssetManager,
	uTeam.FirstName+' '+uTeam.LastName as AMTeamLeadUser,
	uSec.FirstName+' '+uSec.LastName as AMSecondUser,
	IsPreliminaryNotification = Case 
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 ) = 0 and @CurrentStatus <>  'Projected'  Then 1
	WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 and ActionType=575) and not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 and ActionType=577)  then 1 
	else 0 end,
	
	IsRevisedPreliminaryNotification = Case WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 and ActionType=577)>0 and @CurrentStatus <>  'Projected' then 1 else 0 end,
    
	IsFinalNotification =Case 
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 ) = 0 and @CurrentStatus =  'Completed'  Then 1
	WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=575) and 
	not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=577)  
	then 1 else 0 end,
    
	IsRevisedFinalNotification =Case WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=577)>0 then 1 else 0 end,
    
	IsServicerNotification =Case WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=575) and not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)  then 1 else 0 end,
	
	IsRevisedServicerNotification = Case WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)>0 then 1 else 0 end,
	(select FirstName+' '+LastName from app.[User] where UserID = @ApproverUserID) as CreatedByName,
	
	--(case when AM.Email IS NULL then '' else AM.Email+', ' end+
	-- case when AMS.Email IS NULL then '' else +AMS.Email+', ' end+
	-- case when AMT.Email IS NULL then '' else +AMT.Email+', ' end
	-- ) + @ServicerEmailID as AMEmails
	ISNULL(U_Email.Email,'') as AMEmails,
	--df.UpdatedDate WFUpdatedDate,
	--tad.UpdatedDate WFAdditionalUpdatedDate
	@SeniorCreNoteID as SeniorCreNoteID,
	@SeniorServicerName as SeniorServicerName
	,@BaseCurrencyName as BaseCurrencyName
	,@ServicerName as ServicerName
	,isnull(td.IsREODeal,0) as IsREODeal
	,IsFinalNotificationPayOff =Case 
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 ) = 0 and @CurrentStatus =  'Completed'  Then 1
	WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=575) and 
	not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=577)  
	then 1 else 0 end,
	IsRevisedFinalNotificationPayOff =Case WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=577)>0 then 1 else 0 end,
	tad.ExitFee,
	tad.ExitFeePercentage,
	tad.PrepayPremium
    ,'' as PropertyManagerEmail
	,'' as AccountingEmail
	,isnull(@LastPrelimSentDate,getdate()) LastPrelimSentDate
	,IsCancelFinalSent =Case 
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=8 ) = 0 Then 0
	else 1 end
	,@ACORECreditPartnersIIEmail as AdditionalGroupEmail
	,@RevisedMessageFinal as RevisedMessage
	,@AdditionalEmail as AdditionalEmail
	,@NotesWithFSNone as NotesWithFinancingSourceNone
	,'' as AMEmailsWithoutWellsBerkadia
	 ,td.WatchlistStatus
	,@TotalPendingInvoice TotalPendingInvoice
	,@TotalPendingInvoiceAmt TotalPendingInvoiceAmt
	,@IsPrelimDisabled IsPrelimDisabled
	,@IsFinalDisabled  IsFinalDisabled
	,CREDealIDWithREO=case when td.CREDealID like '%REO%' then 'REO' else td.WatchlistStatus end
	from @WFTaskDetail td
	left join cre.WFTaskAdditionalDetail tad on tad.TaskID = td.TaskID
	left join app.[User] u on td.AMUserID = u.UserID
	left join app.[User] uTeam on td.AMTeamLeadUserID = uTeam.UserID
	left join app.[User] uSec on td.AMSecondUserID = uSec.UserID
	left join core.Lookup lPurposeID on lPurposeID.LookupID = td.PurposeID and lPurposeID.ParentID = 50
	Outer Apply
	(
		SELECT STUFF((
			Select  ',' + Email from(
				SELECT  Email FROM App.[User]	where userid in (td.AMUserID,td.AMSecondUserID,td.AMTeamLeadUserID,td.AlternateAssetManager2ID,td.AlternateAssetManager3ID)
				UNION ALL
				SELECT  Email FROM App.[User]	where userid =@UserID
				UNION ALL
				Select  '|' +  @ServicerEmailID+@ACORECreditPartnersIIEmail as Email --
				)a
		FOR xml path ('')
		), 1, 1, '') as email 		
	)U_Email

	
	
	--left join App.[User] AM	on d.AMUserID =AM.userid
	--left join App.[User] AMS on d.AMSecondUserID =AMS.userid
	--left join App.[User] AMT on d.AMTeamLeadUserID =AMT.userid
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	END
	ELSE IF(@TaskTypeID=719)
	BEGIN
	select top 1  @LastPrelimSentDate = CreatedDate from @WFNotification where taskid=@TaskID and NotificationType in ('Preliminary','Preliminary Revised')
	and TaskTypeID=@TaskTypeID order by CreatedDate desc
	
	select @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from CRE.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)

	Select @DealID = DealID, @PurposeID = PurposeID from cre.DealReserveSchedule where DealReserveScheduleGUID = @TaskID
	
	select  @AdditionalEmail = AdditionalEmail from cre.WFTaskAdditionalDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID

	if (@AdditionalEmail is null or @AdditionalEmail='')
	BEGIN
	   select top 1 @AdditionalEmail= AdditionalEmail from cre.WFTaskAdditionalDetail where TaskID in 
	   (
	        select  taskid from cre.WFTaskAdditionalDetail t join cre.DealReserveSchedule d on d.DealReserveScheduleGUID=t.TaskID where d.DealID = @DealID
	   )
	   and TaskTypeID=@TaskTypeID
	   order by AdditionalEmailUpdatedDate desc
	END

	select @IsREODeal=isnull(IsREODeal,0),@PropertyManagerEmail = PropertyManagerEmail from cre.Deal where DealID=@DealID
	select @BaseCurrencyName  = ISNULL((SELECT TOP 1  ISNULL(REPLACE(l.Name,'CAD','USD'),'USD') as Name
											FROM cre.note n
											left join  core.account acc on n.Account_AccountID = acc.AccountID
											left join core.lookup l on l.lookupid = acc.BaseCurrencyID
											left join cre.deal d on d.DealID = n.DealID
											WHERE d.DealID = @Dealid
											ORDER BY case when l.Name = 'USD' then 9999 else 1 end desc) ,'USD')

	select @ApproverUserID = CreatedBy from Cre.WFTaskDetail where WFTaskDetailID =(Select MAX(WFTaskDetailID) from Cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and SubmitType=498)
	
	SET @CurrentStatus = (Select top 1 sm.StatusName from Cre.WFTaskDetail td
	inner join cre.WFStatusPurposeMapping m on m.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
	inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = m.WFStatusMasterID
	where taskid = @TaskID and TaskTypeID=@TaskTypeID and PurposeTypeId = @PurposeID)
	

	
	SET @ServicerEmailID = (
					Select  Distinct s.EmailID + ','
					from cre.Deal d
					inner join CRE.Note n on n.dealid = d.dealid
					left join cre.Servicer s on s.ServicerID = n.ServicerNameID
					where 
					n.ServicerNameID is not null
					and d.IsDeleted <> 1
					and d.dealid = @DealID
					FOR XML PATH('') 
					)

    

	set @ServicerEmailID=reverse(stuff(reverse(@ServicerEmailID), 1, 1, ''))

	--if servicer=Berkadia Commercial Mortgage than additional email in To line of reserve final notification
	if EXISTS(
	                Select  1
					from cre.Deal d
					inner join CRE.Note n on n.dealid = d.dealid
					left join cre.Servicer s on s.ServicerID = n.ServicerNameID
					where 
					n.ServicerNameID is not null
					and d.IsDeleted <> 1
					and d.dealid = @DealID
					and s.ServicerID=2
	)
	BEGIN
	SET @BerkadiaReserveWFEmail = (
					Select  Distinct EmailID + ','
					from app.emailnotification where ModuleId=857
					FOR XML PATH('') 
					)
	set @BerkadiaReserveWFEmail=reverse(stuff(reverse(@BerkadiaReserveWFEmail), 1, 1, ''))
	END
	
	--servicer email without wells and Berkadia,this will only be used for reserve prelim notification
	SET @ServicerEmailIDWithoutWellsBerkadia = (
					Select  Distinct s.EmailID + ','
					from cre.Deal d
					inner join CRE.Note n on n.dealid = d.dealid
					left join cre.Servicer s on s.ServicerID = n.ServicerNameID
					where 
					n.ServicerNameID is not null
					and d.IsDeleted <> 1
					and d.dealid = @DealID
					and s.ServicerID not in (1,2)
					FOR XML PATH('') 
					)
	set @ServicerEmailIDWithoutWellsBerkadia=reverse(stuff(reverse(@ServicerEmailIDWithoutWellsBerkadia), 1, 1, ''))


	--IF exists(select 1 from cre.Note n join core.Account ac on n.Account_AccountID=ac.AccountID where n.FinancingSourceID=45 and n.DealID=@DealID
	--and ac.IsDeleted=0 )
	IF exists
	(
		select 1 from cre.Note n join core.Account ac on n.Account_AccountID=ac.AccountID
		join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID=n.FinancingSourceID
		where fm.ParentClient ='ACP II' and n.DealID=@DealID
		and ac.IsDeleted=0
	)
	BEGIN
		SELECT @ACORECreditPartnersIIEmail = STUFF((
			select  Distinct ',' + EmailID from app.EmailNotification where ModuleId=791
			FOR XML PATH('') 
		), 1, 1, '')
	END

--Get senior note and their servicer name
select  top 1 @SeniorCreNoteID =n.ServicerID,@SeniorServicerName =s.ServicerName from cre.note n 
join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
left join CRE.Servicer s on s.ServicerID = n.ServicerNameID
join cre.deal d on d.dealid=n.dealid
where 
--DebtTypeID=442   
--and  
fs.isThirdParty=0
and acc.IsDeleted = 0
and n.ActualPayOffDate is null
and d.dealid=@DealID
order by ISNULL(DebtTypeID,0),ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 

--Get servicer name for the payoff/paydown notification 
SELECT @ServicerName =STUFF((
			select  Distinct ',' + s.ServicerName from cre.note n 
join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
left join CRE.Servicer s on s.ServicerID = n.ServicerNameID
join cre.deal d on d.dealid=n.dealid
and acc.IsDeleted = 0
and d.dealid=@DealID
FOR XML PATH('') 
		), 1, 1, '')

	select @AMGroup =STUFF((
			select  Distinct ',' + EmailId from App.EmailNotification where ModuleId=614 and [status]=1
			FOR XML PATH('') 
		), 1, 1, '')

		if (@IsREODeal=1)
		BEGIN
			select @REOEmails =STUFF((
				select  Distinct ',' + EmailId from App.EmailNotification where ModuleId=720 and [status]=1
				FOR XML PATH('') 
			), 1, 1, '')
		END

		SELECT @AccountingEmail =STUFF((
			select  Distinct ',' + EmailId from App.EmailNotification where ModuleId=703
			FOR XML PATH('') 
		), 1, 1, '')

--============================================

	Select 
	td.WFTaskDetailID,
	td.TaskID,
	df.Date,
	null as DeadLineDate,
	Abs(df.Amount) as Amount,
	df.PurposeID,
	lPurposeID.Name as PurposeIDText,
	df.Applied,
	df.Comment,
	null as DrawFundingID,
	d.dealname,
	d.CREDealID,
	d.BoxDocumentLink,
	tad.SpecialInstruction,
	tad.AdditionalComment,
	0 as RequiredEquity,
	0 as AdditionalEquity,
	--d.AssetManager,
	d.AMSecondUserID,
	d.AMTeamLeadUserID,
	u.FirstName+' '+u.LastName as AssetManager,
	uTeam.FirstName+' '+uTeam.LastName as AMTeamLeadUser,
	uSec.FirstName+' '+uSec.LastName as AMSecondUser,
	IsPreliminaryNotification = Case 
	--when isnull(d.IsREODeal,0)=0 then 0
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 ) = 0 and @CurrentStatus <>  'Projected'  Then 1
	WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 and ActionType=575) and not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 and ActionType=577)  then 1 
	else 0 end,
	
	IsRevisedPreliminaryNotification = Case 
	--when isnull(d.IsREODeal,0)=0 then 0  
	WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 and ActionType=577)>0 then 1 else 0 end,
    
	IsFinalNotification =Case 
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 ) = 0 and @CurrentStatus =  'Completed'  Then 1
	WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=575) and 
	not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=577)  
	then 1 else 0 end,
    
	IsRevisedFinalNotification =Case WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=577)>0 then 1 else 0 end,
    
	IsServicerNotification =Case WHEN exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=575) and not exists (select 1 from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)  then 1 else 0 end,
	
	IsRevisedServicerNotification = Case WHEN (select count(1) from @WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)>0 then 1 else 0 end,
	(select FirstName+' '+LastName from app.[User] where UserID = @ApproverUserID) as CreatedByName,
	
	--(case when AM.Email IS NULL then '' else AM.Email+', ' end+
	-- case when AMS.Email IS NULL then '' else +AMS.Email+', ' end+
	-- case when AMT.Email IS NULL then '' else +AMT.Email+', ' end
	-- ) + @ServicerEmailID as AMEmails
	ISNULL(U_Email.Email,'') as AMEmails,
	--df.UpdatedDate WFUpdatedDate,
	--tad.UpdatedDate WFAdditionalUpdatedDate
	@SeniorCreNoteID as SeniorCreNoteID,
	@SeniorServicerName as SeniorServicerName
	,@BaseCurrencyName as BaseCurrencyName
	,@ServicerName as ServicerName
	,isnull(d.IsREODeal,0) as IsREODeal
	,0 as IsFinalNotificationPayOff
	,0 as IsRevisedFinalNotificationPayOff
	,null as ExitFee
	,null as ExitFeePercentage
	,null as PrepayPremium
	,isnull(@PropertyManagerEmail,'') as PropertyManagerEmail
	,isnull(@AccountingEmail,'') as AccountingEmail
	,isnull(@LastPrelimSentDate,getdate()) LastPrelimSentDate
	,IsCancelFinalSent =Case 
	When (select count(WFNotificationId) from @WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=9 ) = 0 Then 0
	else 1 end,
	@ACORECreditPartnersIIEmail as AdditionalGroupEmail
	,@RevisedMessageFinal as RevisedMessage
	,@AdditionalEmail as AdditionalEmail
	,'' as NotesWithFinancingSourceNone
	,ISNULL(U_Email_WithoutwellsBerkadia.Email,'') as AMEmailsWithoutWellsBerkadia
	,d.WatchlistStatus
	,0 TotalPendingInvoice
	,0 TotalPendingInvoiceAmt
	,0 IsPrelimDisabled
	,0 IsFinalDisabled
	,'' as CREDealIDWithREO
	from Cre.WFTaskDetail td
	inner join cre.DealReserveSchedule df on df.DealReserveScheduleGUID = td.TaskID
	inner join cre.Deal d on d.DealID = df.DealID
	left join cre.WFTaskAdditionalDetail tad on tad.TaskID = td.TaskID
	left join app.[User] u on d.AMUserID = u.UserID
	left join app.[User] uTeam on d.AMTeamLeadUserID = uTeam.UserID
	left join app.[User] uSec on d.AMSecondUserID = uSec.UserID
	left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 119
	Outer Apply
	(
		SELECT STUFF((
			Select  ',' + Email from(
				Select @REOEmails  as Email
				UNION ALL
				SELECT  Email FROM App.[User]	where userid in (d.AMUserID,d.AMSecondUserID,d.AMTeamLeadUserID)
				UNION ALL
				SELECT  Email FROM App.[User]	where userid =@UserID
				UNION ALL
				Select @ServicerEmailID  as Email --
				UNION ALL 
				select @BerkadiaReserveWFEmail as Email
				UNION ALL
				SELECT '|'+STUFF((SELECT ',' + Email FROM(
				select Email from App.[User] where userid in (d.AlternateAssetManager2ID,d.AlternateAssetManager3ID)
				union ALL 
				Select @AMGroup  as Email) inr
				FOR xml path ('')), 1, 1, '')
			)a
		FOR xml path ('')
		), 1, 1, '') as email 		
	)U_Email
	Outer Apply
	(
		SELECT STUFF((
			Select  ',' + Email from(
				Select @REOEmails  as Email
				UNION ALL
				SELECT  Email FROM App.[User]	where userid in (d.AMUserID,d.AMSecondUserID,d.AMTeamLeadUserID)
				UNION ALL
				SELECT  Email FROM App.[User]	where userid =@UserID
				UNION ALL
				Select @ServicerEmailIDWithoutWellsBerkadia  as Email --
				UNION ALL
				SELECT '|'+STUFF((SELECT ',' + Email FROM(
				select Email from App.[User] where userid in (d.AlternateAssetManager2ID,d.AlternateAssetManager3ID)
				union ALL 
				Select @AMGroup  as Email) inr
				FOR xml path ('')), 1, 1, '')
			)a
		FOR xml path ('')
		), 1, 1, '') as email 		
	)U_Email_WithoutwellsBerkadia
	
	--left join App.[User] AM	on d.AMUserID =AM.userid
	--left join App.[User] AMS on d.AMSecondUserID =AMS.userid
	--left join App.[User] AMT on d.AMTeamLeadUserID =AMT.userid
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	
	END 
	
	

END
