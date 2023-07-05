
--[CRE].[usp_GetWFNotificationMasterEmail]	'645291e0-8720-4b3e-a351-89bb8d016df5','e200cd6b-1237-486b-97d8-30ab3b869b01'


CREATE PROCEDURE [CRE].[usp_GetWFNotificationMasterEmail]	  --'e200cd6b-1237-486b-97d8-30ab3b869b01','e200cd6b-1237-486b-97d8-30ab3b869b01'
	@TaskTypeID int,
	@DealFundingID Uniqueidentifier,
    @UserID nvarchar(256)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
	/*
	--get third party notes to be excluded
	declare @ThirdPartyNotes table
	(
	  NoteID Uniqueidentifier
	)
	
	
	insert into @ThirdPartyNotes
	select noteid
	from cre.Note n
	inner join core.Account acc on acc.accountid = n.account_accountid
	left join core.lookup l on n.FinancingSourceID = l.lookupid
	left join cre.Client c on c.ClientID = n.ClientID
	inner join cre.Deal d on d.dealid = n.DealID

	where acc.isdeleted <> 1
	and d.dealid=(select top 1 dealid from cre.dealfunding where dealfundingid='e1f6f7c4-8773-4b80-af0f-4810145b13af')
	--and n.ClientID is null 
	--and ActualPayoffDate is null
	and l.Value in ('3rd Party Owned','Co-Fund','Note Sale','BcIMC Sidecar')
	order by d.dealname,d.credealid,crenoteid
	
	--
	*/

/* commented as the logic change in the task - https://hvantage.teamwork.com/#/tasks/20712954
DECLARE @DealClients nvarchar(256)
SET @DealClients = (
Select STUFF((
Select Distinct  ', '  + c.clientname  
from cre.note n
inner join cre.deal d on d.dealid = n.dealid
left join cre.client c on c.clientid= n.clientid
where d.dealid = (Select dealid from cre.dealfunding where dealfundingid =  @DealFundingID)
and c.clientname<>'None'
FOR XML PATH('') ), 1, 2, '') as DealClients
)
*/

--change the logic as per asked by json-
--logic- if the note financing source is third party than we do not need to display the client of that note in the subject line of 
--prelim and final notification
--Refer the task - https://hvantage.teamwork.com/#/tasks/20712954


if (@TaskTypeID = 502)
BEGIN
 DECLARE @DealClients nvarchar(256)
SET @DealClients = (
Select STUFF((
Select Distinct  ', '  + c.ClientAbbr  
from cre.note n
inner join cre.deal d on d.dealid = n.dealid
left join cre.client c on c.clientid= n.clientid
left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID=n.FinancingSourceID
where d.dealid = (Select dealid from cre.dealfunding where dealfundingid =  @DealFundingID)
and c.clientname<>'None'
and fs.IsThirdParty=0
FOR XML PATH('') ), 1, 2, '') as DealClients
)


Declare @PayOffEmailToGroupIds nvarchar(256)
set @PayOffEmailToGroupIds = (
Select STUFF((
Select Distinct  ', '  + EmailId  
from app.EmailNotification where ModuleId=704 and [Status]=1
FOR XML PATH('') ), 1, 2, ',')
)


	
SELECT dealid,credealid,dealname,0 as ClientID,ClientName,lookupID,EmailID,replace(ClientFunding,'aaaaa','') as ClientFunding,
-- format client name as 'client1,client2 and client3'
(case when charindex(',',reverse(ClientsName))>0 then reverse(replace(STUFF(reverse(ClientsName),charindex(',',reverse(ClientsName)),0,'#'),'#,','dna ')) else ClientsName end) as ClientsName,
EmailIDs = (EmailIDs+case when lookupid=704 then isnull(@PayOffEmailToGroupIds,'') else '' end),
(case when charindex(',',reverse(@DealClients))>0 then reverse(replace(STUFF(reverse(@DealClients),charindex(',',reverse(@DealClients)),0,'#'),'#,','dna ')) else @DealClients end)  as DealClients
FROM 
(
		SELECT d.dealid,d.credealid,d.dealname,l.ParentClient as ClientName,wf.LookupID,wf.EmailID,
		STUFF((SELECT distinct ', ' + l.ParentClient
			FROM cre.deal d
			inner join cre.note n ON d.dealid = n.dealid
			left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
			left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient and wf.LookupId <> 607
			--left join [CRE].WFNotificationMasterEmail wf ON wf.ClientID = n.ClientID and wf.LookupId <> 607
			--left join [CRE].Client l on l.ClientID = wf.ClientID
			join cre.dealfunding df on df.dealid = d.dealid 
			WHERE l.ParentClient is not null
			and df.dealfundingid =  @DealFundingID
			GROUP BY d.dealid,d.credealid,l.ParentClient,wf.lookupID,d.dealname,wf.EmailID 
			FOR XML PATH('')), 1, 2, '') as ClientsName,
			STUFF((
			select Distinct ', ' +wf1.EmailID 
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
								and n.NoteID in (
									select distinct n.noteid
									FROM cre.deal d
									inner join cre.note n ON d.dealid = n.dealid
									left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
									left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient and wf.LookupId <> 607
									
									join cre.dealfunding df on df.dealid = d.dealid 
									--WHERE n.ClientID is not null
									and df.dealfundingid =  @DealFundingID			   
								) 
								and acc.IsDeleted = 0 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID	and fs.DealFundingRowno=(select DealFundingRowno from cre.DealFunding where dealfundingid =  @DealFundingID)
			left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
			left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
			left join [CRE].WFNotificationMasterEmail wf1 ON wf1.ParentClient = l.ParentClient and wf1.LookupId <> 607
			where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 
			FOR XML PATH('') ), 1, 2, '') as EmailIDs,
		
		tblClientFunding.ClientFunding

FROM cre.deal d
inner join cre.note n ON d.dealid = n.dealid
INNER JOIN [CORE].[Account] acc on acc.AccountID = n.Account_AccountID
left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
left join [CRE].WFNotificationMasterEmail wf ON wf.ParentClient = l.ParentClient
join cre.dealfunding df on df.dealid = d.dealid 

outer apply(
	Select STUFF((select distinct '|'+ ClientName+','+ cast(sum(Value) as nvarchar(100)) from 
		(
			select ClientName =(case when l.IsThirdParty=1 then +'aaaaa'+ISNULL(l.ParentClient,l.FinancingSourceName) else l.ParentClient end), fs.Value from [CORE].FundingSchedule fs
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
									and df.dealfundingid =  @DealFundingID			   
								) 
								
								--and n.creNoteID not in (
								--	select n.crenoteid
								--	from cre.Note n
								--	inner join core.Account acc on acc.accountid = n.account_accountid
									
								--	left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
								--	--left join core.lookup l on n.FinancingSourceID = l.lookupid
									
								--	--left join cre.Client c on c.ClientID = n.ClientID
								--	inner join cre.Deal d on d.dealid = n.DealID
								--	left join cre.DealFunding df on df.dealid = d.dealid
								--	where acc.isdeleted <> 1
								--	and l.FinancingSourceName in ('3rd Party Owned','Co-Fund','Note Sale','BcIMC Sidecar')
								--	and df.dealfundingid = @DealFundingID
								--)
								and acc.IsDeleted = 0 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID	and fs.DealFundingRowno=(select DealFundingRowno from cre.DealFunding where dealfundingid =  @DealFundingID)
			left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
			left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
			where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 
			
		) tbl

		group by ClientName
		FOR XML PATH('')), 1, 1, '') as ClientFunding
) tblClientFunding

WHERE l.ParentClient is not null
and df.dealfundingid =  @DealFundingID
and acc.IsDeleted = 0
and wf.LookupId <> 607
GROUP BY d.dealid,d.credealid,l.ParentClient,wf.lookupID,d.dealname,wf.EmailID,tblClientFunding.ClientFunding

) tbl order by ClientName

END
ELSE IF(@TaskTypeID=719)
	BEGIN
	
	SELECT DealID,'' as credealid,'' as dealname,0 as ClientID,'' as ClientName,604 as lookupID,'skhan@hvantage.com'as EmailID,'' as ClientFunding,'' as ClientsName,'skhan@hvantage.com' as EmailIDs,'' as DealClients
	from CRE.DealReserveSchedule where DealReserveScheduleGUID = @DealFundingID
	union
	SELECT DealID,'' as credealid,'' as dealname,0 as ClientID,'' as ClientName,605 as lookupID,'skhan@hvantagetechnologies.com' as EmailID,'' as ClientFunding,'' as ClientsName,'skhan@hvantagetechnologies.com' as EmailIDs,'' as DealClients
	from CRE.DealReserveSchedule where DealReserveScheduleGUID = @DealFundingID
	
	END 


END


