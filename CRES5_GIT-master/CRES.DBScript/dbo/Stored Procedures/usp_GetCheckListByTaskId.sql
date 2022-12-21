
create PROCEDURE [dbo].[usp_GetCheckListByTaskId] 
(
    @TaskTypeID int,
	@TaskID nvarchar(256),
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;

	Declare @Max_WFTaskDetailID int = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)
	Declare @LookupIDPending int = (Select LookupID from core.Lookup where ParentID = 78 and [Name] = 'Pending')
	--Declare @DealID nvarchar(256)=(Select top 1 DealID from CRE.DealFunding where  DealFundingID=@TaskID)
	declare @PrevvCheckListStatus int,@PrevCheckListStatusText nvarchar(256),@NewTaskID nvarchar(256),@IsDrawExist bit=1,
	@PrevvCheckListComment nvarchar(max)
	declare @countInWftaskDetail int  = (Select count(TaskID) from Cre.WFTaskDetail where TaskID=@TaskID and TaskTypeID=@TaskTypeID 
	    and isnull(Comment,'') not like '%Changed the funding date%'
		and isnull(Comment,'') not like '%Changed the funding amount%')
		declare @IsReoDeal int=0
		declare @dealID uniqueidentifier

	if (@TaskTypeID=502)
	BEGIN
	
	--update the logic for the Draw Fee Applicable field in the checklist to carry over the status and the comment from the previous draw workflow for that loan
	select @dealID = dealid from cre.DealFunding where DealFundingID=@TaskID
	IF NOT EXISTS(SELECT InvoiceDetailID FROM CRE.[InvoiceDetail] WHERE ObjectTypeID=698 and ObjectID=@TaskID and InvoiceTypeID=558)
	AND NOT EXISTS(Select 1 from Cre.WFTaskDetailArchive where TaskID=@TaskID and isnull(Comment,'') not like '%Changed the funding date%'
		and isnull(Comment,'') not like '%Changed the funding amount%')
	and @countInWftaskDetail is not null and @countInWftaskDetail = 1
	BEGIN
	    set @IsDrawExist = 0

		--get most recent draw detail
		 select top 1 @NewTaskID=w.TaskID from cre.WFTaskDetail w join cre.DealFunding df on w.TaskID=df.DealFundingID
			join cre.WFTaskDetailArchive wa on wa.TaskID=w.TaskID
			where dealid=@dealID
			and isnull(w.Comment,'') not like 'Draw Fee%'
			and isnull(w.Comment,'') not like '%Changed the funding date%'
			and isnull(w.Comment,'') not like '%Changed the funding amount%'
			and w.TaskTypeID=502
			order by w.CreatedDate desc

		Select 
		@PrevvCheckListStatus=CheckListStatus,
		@PrevCheckListStatusText=lCheckListStatus.Name,
		@PrevvCheckListComment = cld.Comment
		from cre.WFCheckListDetail cld 
		left join core.Lookup lCheckListStatus on lCheckListStatus.LookupID = cld.CheckListStatus and lCheckListStatus.ParentID = 78	
		Where cld.TaskID = @NewTaskID and cld.WFCheckListMasterID is not null and cld.WFCheckListMasterID=9
		 
	END

	
Select
WFTaskDetailID,
TaskID,
WFCheckListDetailID,
WFCheckListMasterID,
CheckListName,
CheckListStatus = case when (@PrevvCheckListStatus is not null and @PrevvCheckListStatus<>0 and WFCheckListMasterID=9) then @PrevvCheckListStatus else CheckListStatus end,
CheckListStatusText = case when (@PrevvCheckListStatus is not null and @PrevvCheckListStatus<>0 and WFCheckListMasterID=9) then @PrevCheckListStatusText else CheckListStatusText end,
Comment = case when (isnull(@PrevvCheckListComment,'') <>'' and WFCheckListMasterID=9) then @PrevvCheckListComment else Comment end,
IsMandatory from
(
	Select 
	td.WFTaskDetailID,
	td.TaskID,
	cld.WFCheckListDetailID,
	cld.WFCheckListMasterID,
	clm.CheckListName,
	ISNULL(cld.CheckListStatus,@LookupIDPending) as CheckListStatus,
	lCheckListStatus.Name as CheckListStatusText,
	cld.Comment	,
	clm.IsMandatory,
	clm.SortOrder
	from cre.WFTaskDetail td
	left join cre.WFCheckListDetail cld on cld.TaskId = td.TaskId
	left join cre.WFCheckListMaster clm on clm.WFCheckListMasterID = cld.WFCheckListMasterID
	left join core.Lookup lCheckListStatus on lCheckListStatus.LookupID = ISNULL(cld.CheckListStatus,@LookupIDPending) and lCheckListStatus.ParentID = 78	
	Where td.WFTaskDetailID = @Max_WFTaskDetailID and cld.WFCheckListMasterID is not null
	

	UNION ALL

	Select 
	td.WFTaskDetailID,
	td.TaskID,
	cld.WFCheckListDetailID,
	null as WFCheckListMasterID,
	cld.CheckListName,
	ISNULL(cld.CheckListStatus,@LookupIDPending) as CheckListStatus,
	lCheckListStatus.Name as CheckListStatusText,
	cld.Comment	,
	null IsMandatory,
	null SortOrder
	from cre.WFTaskDetail td
	left join cre.WFCheckListDetail cld on cld.TaskId = td.TaskId
	left join core.Lookup lCheckListStatus on lCheckListStatus.LookupID = ISNULL(cld.CheckListStatus,@LookupIDPending) and lCheckListStatus.ParentID = 78	
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	and cld.WFCheckListMasterID is  null

)a
order by ISNULL(a.SortOrder,9999)
	END

	ELSE IF(@TaskTypeID=719)
	BEGIN
	select @IsReoDeal = isnull(IsReoDeal,0),@dealID=d.DealID from cre.deal d join cre.DealReserveSchedule rs on d.DealID=rs.DealID
		where DealReserveScheduleGUID=@TaskID
	--update the logic for the Draw Fee Applicable field in the checklist to carry over the status and the comment from the previous draw workflow for that loan
	IF NOT EXISTS(Select 1 from Cre.WFTaskDetailArchive where TaskID=@TaskID and isnull(Comment,'') not like '%Changed the funding date%'
		and isnull(Comment,'') not like '%Changed the funding amount%')
	and @countInWftaskDetail is not null and @countInWftaskDetail = 1
	BEGIN
	    set @IsDrawExist = 0

		--get most recent invoice detail
		  select top 1 @NewTaskID=w.TaskID from cre.WFTaskDetail w join cre.DealReserveSchedule df on w.TaskID=df.DealReserveScheduleGUID
			join cre.WFTaskDetailArchive wa on wa.TaskID=w.TaskID
			where dealid=@dealID
			and isnull(w.Comment,'') not like 'Draw Fee%'
			and isnull(w.Comment,'') not like '%Changed the funding date%'
			and isnull(w.Comment,'') not like '%Changed the funding amount%'
			and w.TaskTypeID=719
			order by w.CreatedDate desc

		Select 
		@PrevvCheckListStatus=CheckListStatus,
		@PrevCheckListStatusText=lCheckListStatus.Name,
		@PrevvCheckListComment = cld.Comment
		from cre.WFCheckListDetail cld 
		left join core.Lookup lCheckListStatus on lCheckListStatus.LookupID = cld.CheckListStatus and lCheckListStatus.ParentID = 78	
		Where cld.TaskID = @NewTaskID and cld.WFCheckListMasterID is not null and cld.WFCheckListMasterID=9
		 
	END

	
Select
WFTaskDetailID,
TaskID,
WFCheckListDetailID,
WFCheckListMasterID,
CheckListName,
CheckListStatus = case when (@PrevvCheckListStatus is not null and @PrevvCheckListStatus<>0 and WFCheckListMasterID=9) then @PrevvCheckListStatus else CheckListStatus end,
CheckListStatusText = case when (@PrevvCheckListStatus is not null and @PrevvCheckListStatus<>0 and WFCheckListMasterID=9) then @PrevCheckListStatusText else CheckListStatusText end,
Comment = case when (isnull(@PrevvCheckListComment,'') <>'' and WFCheckListMasterID=9) then @PrevvCheckListComment else Comment end,
IsMandatory from
(
	Select 
	td.WFTaskDetailID,
	td.TaskID,
	cld.WFCheckListDetailID,
	cld.WFCheckListMasterID,
	clm.CheckListName,
	ISNULL(cld.CheckListStatus,@LookupIDPending) as CheckListStatus,
	lCheckListStatus.Name as CheckListStatusText,
	cld.Comment	,
	clm.IsMandatory,
	clm.SortOrder
	from cre.WFTaskDetail td
	left join cre.WFCheckListDetail cld on cld.TaskId = td.TaskId
	left join cre.WFCheckListMaster clm on clm.WFCheckListMasterID = cld.WFCheckListMasterID
	left join core.Lookup lCheckListStatus on lCheckListStatus.LookupID = ISNULL(cld.CheckListStatus,@LookupIDPending) and lCheckListStatus.ParentID = 78	
	Where td.WFTaskDetailID = @Max_WFTaskDetailID and cld.WFCheckListMasterID is not null
	and ((@IsReoDeal=0 and clm.WFCheckListMasterID not in (16,17)) OR @IsReoDeal=1)
	

	UNION ALL

	Select 
	td.WFTaskDetailID,
	td.TaskID,
	cld.WFCheckListDetailID,
	null as WFCheckListMasterID,
	cld.CheckListName,
	ISNULL(cld.CheckListStatus,@LookupIDPending) as CheckListStatus,
	lCheckListStatus.Name as CheckListStatusText,
	cld.Comment	,
	null IsMandatory,
	null SortOrder
	from cre.WFTaskDetail td
	left join cre.WFCheckListDetail cld on cld.TaskId = td.TaskId
	left join core.Lookup lCheckListStatus on lCheckListStatus.LookupID = ISNULL(cld.CheckListStatus,@LookupIDPending) and lCheckListStatus.ParentID = 78	
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	and cld.WFCheckListMasterID is  null

)a
order by ISNULL(a.SortOrder,9999)
	
	END
	
	


END
