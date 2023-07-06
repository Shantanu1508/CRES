

--EXEC [dbo].[usp_GetWorkflowAdditionalDetailByTaskId]   '0255f678-90bc-486a-b6cc-aa2c78277f12', 'D4CB7189-0B71-48C0-93E1-B81FDE38DA59'  


Create PROCEDURE [dbo].[usp_GetWorkflowAdditionalDetailByTaskId] 
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
	DECLARE @AMGroup  nvarchar(256)
	DECLARE @IsREODeal bit=0
	DECLARE @REOEmails nvarchar(256)
	DECLARE @PropertyManagerEmail nvarchar(500)
	DECLARE @AccountingEmail nvarchar(256)
	DECLARE @LastPrelimSentDate datetime
	DECLARE @ACORECreditPartnersIIEmail nvarchar(500)=''



	

	IF(@TaskTypeID=502)
	BEGIN
	select top 1  @LastPrelimSentDate = CreatedDate from cre.WFNotification where taskid=@TaskID and NotificationType in ('Preliminary','Preliminary Revised')
	and TaskTypeID=@TaskTypeID order by CreatedDate desc
	
	select @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)

	Select @DealID = DealID, @PurposeID = PurposeID from cre.DealFunding where DealFundingid = @TaskID

	select @BaseCurrencyName = ISNULL((SELECT TOP 1  ISNULL(REPLACE(l.Name,'CAD','USD'),'USD') as Name
											FROM cre.note n
											left join  core.account acc on n.Account_AccountID = acc.AccountID
											left join core.lookup l on l.lookupid = acc.BaseCurrencyID
											left join cre.deal d on d.DealID = n.DealID
											WHERE d.DealID = @Dealid
											ORDER BY case when l.Name = 'USD' then 9999 else 1 end desc) ,'USD')

	select @ApproverUserID = CreatedBy from cre.WFTaskDetail where WFTaskDetailID =(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and SubmitType=498)
	
	SET @CurrentStatus = (Select top 1 sm.StatusName from cre.WFTaskDetail td
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

	
	IF exists(select 1 from cre.Note n join core.Account ac on n.Account_AccountID=ac.AccountID where n.FinancingSourceID=45 and n.DealID=@DealID
	and ac.IsDeleted=0 )
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

--============================================
	Select 
	td.WFTaskDetailID,
	td.TaskID,
	df.Date,
	df.DeadLineDate,
	df.Amount,
	df.PurposeID,
	lPurposeID.Name as PurposeIDText,
	df.Applied,
	df.Comment,
	df.DrawFundingID,
	d.dealname,
	d.CREDealID,
	d.BoxDocumentLink,
	tad.SpecialInstruction,
	tad.AdditionalComment,
	isnull(df.RequiredEquity,0) as RequiredEquity,
	isnull(df.AdditionalEquity,0) as AdditionalEquity,
	--d.AssetManager,
	d.AMSecondUserID,
	d.AMTeamLeadUserID,
	u.FirstName+' '+u.LastName as AssetManager,
	uTeam.FirstName+' '+uTeam.LastName as AMTeamLeadUser,
	uSec.FirstName+' '+uSec.LastName as AMSecondUser,
	IsPreliminaryNotification = Case 
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 ) = 0 and @CurrentStatus <>  'Projected'  Then 1
	WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 and ActionType=575) and not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 and ActionType=577)  then 1 
	else 0 end,
	
	IsRevisedPreliminaryNotification = Case WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=1 and ActionType=577)>0 and @CurrentStatus <>  'Projected' then 1 else 0 end,
    
	IsFinalNotification =Case 
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 ) = 0 and @CurrentStatus =  'Completed'  Then 1
	WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=575) and 
	not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=577)  
	then 1 else 0 end,
    
	IsRevisedFinalNotification =Case WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=2 and ActionType=577)>0 then 1 else 0 end,
    
	IsServicerNotification =Case WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=575) and not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)  then 1 else 0 end,
	
	IsRevisedServicerNotification = Case WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)>0 then 1 else 0 end,
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
	,IsFinalNotificationPayOff =Case 
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 ) = 0 and @CurrentStatus =  'Completed'  Then 1
	WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=575) and 
	not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=577)  
	then 1 else 0 end,
	IsRevisedFinalNotificationPayOff =Case WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=6 and ActionType=577)>0 then 1 else 0 end,
	tad.ExitFee,
	tad.ExitFeePercentage,
	tad.PrepayPremium
    ,'' as PropertyManagerEmail
	,'' as AccountingEmail
	,isnull(@LastPrelimSentDate,getdate()) LastPrelimSentDate
	,IsCancelFinalSent =Case 
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=8 ) = 0 Then 0
	else 1 end
	,@ACORECreditPartnersIIEmail as AdditionalGroupEmail
	from cre.WFTaskDetail td
	inner join cre.DealFunding df on df.DealFundingID = td.TaskID
	inner join cre.Deal d on d.DealID = df.DealID
	left join cre.WFTaskAdditionalDetail tad on tad.TaskID = td.TaskID
	left join app.[User] u on d.AMUserID = u.UserID
	left join app.[User] uTeam on d.AMTeamLeadUserID = uTeam.UserID
	left join app.[User] uSec on d.AMSecondUserID = uSec.UserID
	left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 50
	Outer Apply
	(
		SELECT STUFF((
			Select  ',' + Email from(
				SELECT  Email FROM App.[User]	where userid in (d.AMUserID,d.AMSecondUserID,d.AMTeamLeadUserID)
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
	select top 1  @LastPrelimSentDate = CreatedDate from cre.WFNotification where taskid=@TaskID and NotificationType in ('Preliminary','Preliminary Revised')
	and TaskTypeID=@TaskTypeID order by CreatedDate desc
	
	select @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)

	Select @DealID = DealID, @PurposeID = PurposeID from cre.DealReserveSchedule where DealReserveScheduleGUID = @TaskID
	select @IsREODeal=isnull(IsREODeal,0),@PropertyManagerEmail = PropertyManagerEmail from cre.Deal where DealID=@DealID
	select @BaseCurrencyName  = ISNULL((SELECT TOP 1  ISNULL(REPLACE(l.Name,'CAD','USD'),'USD') as Name
											FROM cre.note n
											left join  core.account acc on n.Account_AccountID = acc.AccountID
											left join core.lookup l on l.lookupid = acc.BaseCurrencyID
											left join cre.deal d on d.DealID = n.DealID
											WHERE d.DealID = @Dealid
											ORDER BY case when l.Name = 'USD' then 9999 else 1 end desc) ,'USD')

	select @ApproverUserID = CreatedBy from cre.WFTaskDetail where WFTaskDetailID =(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and SubmitType=498)
	
	SET @CurrentStatus = (Select top 1 sm.StatusName from cre.WFTaskDetail td
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

	IF exists(select 1 from cre.Note n join core.Account ac on n.Account_AccountID=ac.AccountID where n.FinancingSourceID=45 and n.DealID=@DealID
	and ac.IsDeleted=0 )
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
	IsPreliminaryNotification = Case when isnull(d.IsREODeal,0)=0 then 0
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 ) = 0 and @CurrentStatus <>  'Projected'  Then 1
	WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 and ActionType=575) and not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 and ActionType=577)  then 1 
	else 0 end,
	
	IsRevisedPreliminaryNotification = Case when isnull(d.IsREODeal,0)=0 then 0  WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=4 and ActionType=577)>0 then 1 else 0 end,
    
	IsFinalNotification =Case 
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 ) = 0 and @CurrentStatus =  'Completed'  Then 1
	WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=575) and 
	not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=577)  
	then 1 else 0 end,
    
	IsRevisedFinalNotification =Case WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=5 and ActionType=577)>0 then 1 else 0 end,
    
	IsServicerNotification =Case WHEN exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=575) and not exists (select 1 from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)  then 1 else 0 end,
	
	IsRevisedServicerNotification = Case WHEN (select count(1) from cre.WFNotification where TaskID=@TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=3 and ActionType=577)>0 then 1 else 0 end,
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
	When (select count(WFNotificationId) from cre.WFNotification where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFNotificationMasterID=9 ) = 0 Then 0
	else 1 end,
	@ACORECreditPartnersIIEmail as AdditionalGroupEmail
	from cre.WFTaskDetail td
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
				Select @ServicerEmailID  as Email --
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
	
	--left join App.[User] AM	on d.AMUserID =AM.userid
	--left join App.[User] AMS on d.AMSecondUserID =AMS.userid
	--left join App.[User] AMT on d.AMTeamLeadUserID =AMT.userid
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	
	END 
	
	

END
