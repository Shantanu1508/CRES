

-- [dbo].[usp_GetWFCommentsByTaskId] 'f9f421a7-8fce-44ea-9164-38a75ef3ac43' ,'B0E6697B-3534-4C09-BE0A-04473401AB93'
--[dbo].[usp_GetWFCommentsByTaskId] 'eceb813b-55c7-4bcb-aa9c-e2ce3770fd0e' ,'dc7139ab-d18f-47c4-a711-420b4bde4f38'

create PROCEDURE [dbo].[usp_GetWFCommentsByTaskId] --'eceb813b-55c7-4bcb-aa9c-e2ce3770fd0e' ,'dc7139ab-d18f-47c4-a711-420b4bde4f38'
(
    @TaskTypeID int,
	@TaskID nvarchar(500),
	@UserID nvarchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	Declare  @PurposeTypeId int
	
	IF(@TaskTypeID=502)
	BEGIN
		select  @PurposeTypeId = (select PurposeID from cre.DealFunding where DealFundingID=@TaskID)
	END
	--ELSE IF(@TaskTypeID=719)
	--BEGIN
	--END 
	Declare @WorkFlowType nvarchar(256) = (SELECT Value1 from core.lookup where LookupID=@PurposeTypeId)
    Declare @SubmitforApproverLookupId int = (Select LookupID from core.lookup where ParentID = 77 and [name] = 'Submit for Approver')
	Declare @Abbreviation nvarchar(20)  --,@DefaultTimeZone nvarchar(256) = 'Azores Standard Time'
	--Declare @DefaultAbbreviation nvarchar(20) =(select Abbreviation	from [App].[TimeZone]  WHERE Name=@DefaultTimeZone) 
	
	--SELECT @Abbreviation = Abbreviation	from [App].[TimeZone]  WHERE (Name='Central Standard Time' and @UserID='00000000-0000-0000-0000-000000000000') 
	--	  OR (Name=@DefaultTimeZone and @UserID IS NULL) 
	--SELECT @Abbreviation = t.Abbreviation from [App].[TimeZone] t left join [APP].[UserEx] ux on t.Name = ux.TimeZone Where ux.UserID=@UserID

	

	declare @wfcomment as table
	(
	WFTaskDetailID int,
	TaskID nvarchar(256),
	[Login] nvarchar(256),
	CreatedDate datetime,
	StatusName nvarchar(256),
	Comment nvarchar(max),
	UColor nvarchar(256),
	CommentedByFirstLetter nvarchar(256),
	WFStatusPurposeMappingID int,
	PurposeTypeId int,
	OrderIndex int,
	WFStatusMasterID int,
	PreviousWFStatusMasterID int,
	SubmitType int,
	CreatedBy nvarchar(256),	
	UpdatedBy nvarchar(256),
	UpdatedDate datetime,
	DelegatedUserID nvarchar(256),
	DelegatedUserName  nvarchar(256),
	Abbreviation nvarchar(256)
	)

	insert into @wfcomment
	
	select 
	WFTaskDetailID,
	TaskID,
	[Login] ,
	CreatedDate,
	StatusName ,
	Comment,
	UColor ,
	CommentedByFirstLetter ,
	WFStatusPurposeMappingID,
	PurposeTypeId,
	OrderIndex,
	WFStatusMasterID,
    isnull(LEAD(WFStatusMasterID) OVER (ORDER BY UpdatedDate DESC),99) PreviousWFStatusMasterID,
	SubmitType,
	CreatedBy ,	
	UpdatedBy ,
	UpdatedDate,
	DelegatedUserID ,
	DelegatedUserName  ,
	Abbreviation

	from
	(
	Select 
	td.WFTaskDetailID,
	td.TaskID,	
	u.FirstName+' '+u.LastName as [Login],
	[dbo].[ufn_GetTimeByTimeZone] (td.CreatedDate, @UserID ) as CreatedDate,
	--td.CreatedDate,
	--(Case
	--When ((Select count(WFCheckListDetailID) from cre.WFCheckListDetail where TaskId = td.TaskID and (CheckListStatus = (Select Lookupid from core.lookup where parentid = 78 and [name] = 'No') or CheckListStatus is null)) > 0) and  sm.StatusName not in ('Projected','Requested')
	--then sm.StatusDisplayName + ' (Partial)' 
	--Else sm.StatusDisplayName END
	--)StatusName,
	StatusName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end), 	
	ISNULL(td.Comment,'') as Comment,
	'avatorcircle dbcontenticon ' + userex.Color UColor	,
	LEFT(u.FirstName, 1) + LEFT(u.LastName , 1)  as CommentedByFirstLetter,

	td.WFStatusPurposeMappingID,
	mapp.PurposeTypeId,
	mapp.OrderIndex,
	mapp.WFStatusMasterID,
	
	td.SubmitType,
	td.CreatedBy,	
	td.UpdatedBy,
	td.UpdatedDate,
	td.DelegatedUserID,
	DelegatedUserName=(CASE WHEN isNULL(td.DelegatedUserID,'')<>'' THEN u1.FirstName +' '+u1.LastName ELSE td.DelegatedUserID END),
	[dbo].[ufn_GetAbbreviationByTimeZone] (td.CreatedDate, @UserID ) as Abbreviation
	--ISNULL(@Abbreviation,@DefaultAbbreviation) as Abbreviation
	from cre.WFTaskDetail td
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID
	left join app.[user] u on CAST(u.UserID AS NVARCHAR(256)) = td.CreatedBy
	left join app.[user] u1 on CAST(u1.UserID AS NVARCHAR(256)) = td.DelegatedUserID
	left join APP.UserEx userex on CAST(userex.UserID AS NVARCHAR(256))=td.CreatedBy
	

	Where td.WFTaskDetailID
	in (
		Select WFTaskDetailID from cre.WFTaskDetail 
		Where TaskID = @TaskID  and TaskTypeID=@TaskTypeID
		--and SubmitType = @SubmitforApproverLookupId
		--group by WFStatusPurposeMappingID
	) --AND td.Comment != ''

	UNION
	
	Select 
	td.WFTaskDetailID,
	td.TaskID,	
	u.FirstName+' '+u.LastName as [Login],
	[dbo].[ufn_GetTimeByTimeZone] (td.CreatedDate, @UserID ) as CreatedDate,
	--td.CreatedDate,
	--(Case
	--When ((Select count(WFCheckListDetailID) from cre.WFCheckListDetail where TaskId = td.TaskID and (CheckListStatus = (Select Lookupid from core.lookup where parentid = 78 and [name] = 'No') or CheckListStatus is null)) > 0) and  sm.StatusName not in ('Projected','Requested')
	--then sm.StatusDisplayName + ' (Partial)' 
	--Else sm.StatusDisplayName END
	--)StatusName,
	StatusName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end), 
	ISNULL(td.Comment,'') as Comment,
	'avatorcircle dbcontenticon ' + userex.Color UColor	,
	LEFT(u.FirstName, 1) + LEFT(u.LastName , 1)  as CommentedByFirstLetter,

	td.WFStatusPurposeMappingID,
	mapp.PurposeTypeId,
	mapp.OrderIndex,
	mapp.WFStatusMasterID,
	td.SubmitType,
	td.CreatedBy,	
	td.UpdatedBy,
	td.UpdatedDate,
	td.DelegatedUserID,
	DelegatedUserName=(CASE WHEN isNULL(td.DelegatedUserID,'')<>'' THEN u1.FirstName +' '+u1.LastName ELSE td.DelegatedUserID END),
	dbo.ufn_GetAbbreviationByTimeZone(td.CreatedDate, @UserID) as Abbreviation
	--ISNULL(@Abbreviation,@DefaultAbbreviation) as Abbreviation
	from cre.WFTaskDetailArchive td
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID
	left join app.[user] u on CAST(u.UserID AS NVARCHAR(256)) = td.CreatedBy
	left join app.[user] u1 on CAST(u1.UserID AS NVARCHAR(256)) = td.DelegatedUserID
	left join APP.UserEx userex on CAST(userex.UserID AS NVARCHAR(256))=td.CreatedBy

	Where td.WFTaskDetailID
	in (
		Select WFTaskDetailID from cre.WFTaskDetailArchive 
		Where TaskID = @TaskID and TaskTypeID=@TaskTypeID
		--and SubmitType = @SubmitforApproverLookupId
		--group by WFStatusPurposeMappingID
	)  --AND td.Comment != ''

	 -- td.WFStatusPurposeMappingID desc
	) tbl order by UpdatedDate DESC
	--td.TaskID = @TaskID


	select 
	WFTaskDetailID,
	TaskID,
	[Login] ,
	CreatedDate,
	(case when WFStatusMasterID=PreviousWFStatusMasterID then '' else StatusName end) as StatusName,
	Comment,
	isnull(UColor,'avatorcircle dbcontenticon plum') UColor,
	CommentedByFirstLetter ,
	WFStatusPurposeMappingID,
	PurposeTypeId,
	OrderIndex,
	WFStatusMasterID,
    --PreviousWFStatusMasterID,
	SubmitType,
	CreatedBy ,	
	UpdatedBy ,
	UpdatedDate,
	DelegatedUserID ,
	DelegatedUserName  ,
	Abbreviation
	from @wfcomment
	order by UpdatedDate DESC

	--td.TaskID = @TaskID
END











