-- [dbo].[usp_GetActivityLogByObjectID] 'b0e6697b-3534-4c09-be0a-04473401ab93','90fa31ec-a1e5-4714-a157-b4f8def20b1f',283,1,20,'2020-2-21 16:26',0
CREATE PROCEDURE [dbo].[usp_GetActivityLogByObjectID]
 @UserID NVARCHAR(256) ,
 @ObjectID  UNIQUEIDENTIFIER,
 @ObjectTypeID INT,
 @PgeIndex INT=1,
 @pageSize INT=20,
 @Currentdate NVARCHAR(50),
 @TotalCount INT OUTPUT 
AS
Begin

--Declare @TimeZone nvarchar(256);
--SET @TimeZone = (Select Top 1 TimeZone from app.[UserEx] Where UserID = @UserID)
--IF(@TimeZone is null)
--BEGIN
	--SET @TimeZone = 'Azores Standard Time'
--END
--==================	

	if (@ObjectTypeID=182)
	BEGIN
		select @TotalCount = count(1) from app.ActivityLog AL
		left join CRE.Note n on n.NoteID = AL.ModuleID
		left join App.[User] u on u.UserID = AL.CreatedBy
		left join Core.Lookup l on l.LookupID = AL.ActivityType
		left join APP.UserEx userex on userex.UserID=AL.CreatedBy
		Where AL.ParentModuleID=@ObjectID and AL.ParentModuleTypeID = 182
	 
		Select
		l.name as AcitivityTypeText,
		--l.name + ' is '+ Lower(DisplayMessage) + ' By '+u.FirstName+' '+u.LastName + ' on '+ Cast(AL.CreatedDate as nvarchar(256)) as [Message],
		'<b>'+ISNULL(l.Value,l.Name) +'</b>'+ ' has been '+ Lower(DisplayMessage) + ' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>' as [Message],
		u.FirstName+' '+u.LastName  as UserName,
		LEFT(u.FirstName, 1) + LEFT(u.LastName , 1)  as ActivityByFirstLetter,
		'avatorcircle dbcontenticon ' + userex.Color UColor
		,Lower(AL.DisplayMessage) DisplayMessage	
		,AL.CreatedDate
		--,dbo.ufn_GetUserNotificationTime(@Currentdate,AL.CreatedDate) as CurrentDate
		--,stuff(right( Convert(nvarchar(256),AL.CreatedDate,109), 15 ), 7, 7, ' ' )  as CurrentDate
		--,convert(nvarchar,CAST(CONVERT(datetimeoffset, AL.CreatedDate) AT TIME ZONE @TimeZone as time),100) as CurrentDate
		,stuff(right(Convert(nvarchar(256),[dbo].[ufn_GetTimeByTimeZone](AL.CreatedDate,@UserID),109),15),7,7,' ') as CurrentDate
		from app.ActivityLog AL
		left join CRE.Note n on n.NoteID = AL.ModuleID
		left join App.[User] u on u.UserID = AL.CreatedBy
		left join Core.Lookup l on l.LookupID = AL.ActivityType
		left join APP.UserEx userex on userex.UserID=AL.CreatedBy
		Where AL.ParentModuleID=@ObjectID and AL.ParentModuleTypeID = 182
		order by AL.CreatedDate desc
		OFFSET (@PgeIndex - 1)*@PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY
	END
	ELSE if (@ObjectTypeID=283)
	BEGIN
	select @TotalCount = count(1) from app.ActivityLog AL
		left join App.[User] u on u.UserID = AL.CreatedBy
		left join Core.Lookup l on l.LookupID = AL.ActivityType
		left join APP.UserEx userex on userex.UserID=AL.CreatedBy
		left join cre.Deal d on d.DealID =AL. ModuleID
		left join cre.Note n on n.NoteID = AL.ModuleID
		left join core.Account a on a.AccountID = n.Account_AccountID
		left join [App].[UploadedDocumentLog] ud on ud.UploadedDocumentLogID = AL.ModuleID and ud.ObjectTypeID = 283
		
		Where ParentModuleID=@ObjectID and ParentModuleTypeID = 283 --and ModuleIDInt is null
	
		Select 
		l.name as AcitivityTypeText,
		--l.name + ' is '+ Lower(DisplayMessage) + ' By '+u.FirstName+' '+u.LastName + ' on '+ Cast(AL.CreatedDate as nvarchar(256)) as [Message],
		(case when l.LookupID=414 then
		'Note <b><a href=#/notedetail/' + CAST(n.NoteID  AS varchar(50)) +'>'+a.Name +'</a></b>'+ ' has been '+ Lower(DisplayMessage) + ' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>' 
		when l.LookupID=417 then
		'Document '+'<b>'+ud.OriginalFileName+'</b>'+' has been imported By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>'
		when l.LookupID=418 then
		'Deal Status has been '+ Lower(DisplayMessage) + ' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>'
		when l.LookupID=634 then
		'Auto Spread has been '+ Lower(DisplayMessage) + ' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>'
		when l.LookupID=419 then
		'Status of note '+ '<b><a href=#/notedetail/' + CAST(n.NoteID  AS varchar(50)) +'>'+a.Name +'</a></b>'+' has been '+ Lower(DisplayMessage) + ' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>'
		else
		'<b>'+ISNULL(l.Value,l.Name)+'</b>'+ ' has been '+ Lower(DisplayMessage) + ' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>' 
		end)
		as [Message],
		u.FirstName+' '+u.LastName  as UserName,
		LEFT(u.FirstName, 1) + LEFT(u.LastName , 1)  as ActivityByFirstLetter,
		'avatorcircle dbcontenticon ' + userex.Color UColor
		,Lower(AL.DisplayMessage) DisplayMessage	
		,AL.CreatedDate
		--,dbo.ufn_GetUserNotificationTime(@Currentdate,AL.CreatedDate) as CurrentDate
		--,stuff(right( Convert(nvarchar(256),AL.CreatedDate,109), 15 ), 7, 7, ' ' )  as CurrentDate
		--,convert(nvarchar,CAST(CONVERT(datetimeoffset, AL.CreatedDate) AT TIME ZONE @TimeZone as time),100) as CurrentDate
		,stuff(right(Convert(nvarchar(256),[dbo].[ufn_GetTimeByTimeZone](AL.CreatedDate,@UserID),109),15),7,7,' ') as CurrentDate
		from app.ActivityLog AL
		left join App.[User] u on u.UserID = AL.CreatedBy
		left join Core.Lookup l on l.LookupID = AL.ActivityType
		left join APP.UserEx userex on userex.UserID=AL.CreatedBy
		left join cre.Deal d on d.DealID =AL. ModuleID
		left join cre.Note n on n.NoteID = AL.ModuleID
		left join core.Account a on a.AccountID = n.Account_AccountID
		left join [App].[UploadedDocumentLog] ud on ud.UploadedDocumentLogID = AL.ModuleID and ud.ObjectTypeID = 283
		
		Where ParentModuleID=@ObjectID and ParentModuleTypeID = 283 and ModuleIDInt is null

		union
		--activities for deal level fees
		Select 
		l.name as AcitivityTypeText,
		--l.name + ' is '+ Lower(DisplayMessage) + ' By '+u.FirstName+' '+u.LastName + ' on '+ Cast(AL.CreatedDate as nvarchar(256)) as [Message],
		ISNULL(l.Value,l.Name)+'</b>'+ ' has been '+ Lower(DisplayMessage) + ' for amount $'+cast(format((inv.Amount),'#,0.00') as nvarchar(256))+' By '+'<b>' + u.FirstNAme+' '+u.LastName + '</b>' 
		as [Message],
		u.FirstName+' '+u.LastName  as UserName,
		LEFT(u.FirstName, 1) + LEFT(u.LastName , 1)  as ActivityByFirstLetter,
		'avatorcircle dbcontenticon ' + userex.Color UColor
		,Lower(AL.DisplayMessage) DisplayMessage	
		,AL.CreatedDate
		--,dbo.ufn_GetUserNotificationTime(@Currentdate,AL.CreatedDate) as CurrentDate
		--,stuff(right( Convert(nvarchar(256),AL.CreatedDate,109), 15 ), 7, 7, ' ' )  as CurrentDate
		--,convert(nvarchar,CAST(CONVERT(datetimeoffset, AL.CreatedDate) AT TIME ZONE @TimeZone as time),100) as CurrentDate
		,stuff(right(Convert(nvarchar(256),[dbo].[ufn_GetTimeByTimeZone](AL.CreatedDate,@UserID),109),15),7,7,' ') as CurrentDate
		from app.ActivityLog AL
		left join App.[User] u on u.UserID = AL.CreatedBy
		left join Core.Lookup l on l.LookupID = AL.ActivityType
		left join APP.UserEx userex on userex.UserID=AL.CreatedBy
		left join cre.Deal d on d.DealID =AL. ModuleID
		left join cre.Note n on n.NoteID = AL.ModuleID
		left join core.Account a on a.AccountID = n.Account_AccountID
		left join cre.InvoiceDetail inv on inv.InvoiceDetailID = AL.ModuleIDInt
		left join [App].[UploadedDocumentLog] ud on ud.UploadedDocumentLogID = AL.ModuleID and ud.ObjectTypeID = 283
		
		Where ParentModuleID=@ObjectID and ParentModuleTypeID = 283 and ModuleIDInt is not null
		--
		
		order by AL.CreatedDate desc
		OFFSET (@PgeIndex - 1)*@PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY
	
	
	END

END
GO

