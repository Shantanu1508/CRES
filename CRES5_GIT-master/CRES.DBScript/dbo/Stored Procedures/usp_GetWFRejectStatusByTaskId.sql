
--[usp_GetWFRejectStatusByTaskId] '432687d6-c730-4fea-ab3e-e69bbf85cccb','432687d6-c730-4fea-ab3e-e69bbf85cccb'


CREATE PROCEDURE [dbo].[usp_GetWFRejectStatusByTaskId] 
(
    @TaskTypeID int,
	@TaskID nvarchar(256),
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;

	Declare @PurposeTypeId int, 
	@DealID uniqueidentifier,
	@FirstDealFundingID uniqueidentifier,
	@Amount decimal(28, 15),
	@AmountTobeCheckforL1L2 decimal(28,15),
	@AmountTobeCheckForPrimaryAM decimal(28,15),
	@Reject_WFTaskDetailID int=null,
	@ShowSecondApproval bit = 0,
	@WorkFlowType nvarchar(256)
	
	SET @AmountTobeCheckforL1L2 = 1500000
	SET @AmountTobeCheckForPrimaryAM = 500000

	IF(@TaskTypeID=502)
	BEGIN
		Select 
		@DealID = DealID,
		@PurposeTypeId = PurposeID,
		@Amount = Amount
		from cre.DealFunding where DealFundingID=@TaskID
		SELECT @WorkFlowType =Value1 from core.lookup where LookupID=@PurposeTypeId

		Select top 1 @FirstDealFundingID=DealFundingID from cre.DealFunding where dealid = @DealID and PurposeID = @PurposeTypeId
		order by Date,DealFundingRowno
	
	
	
	
	
	  Select  top 1 @Reject_WFTaskDetailID = t.WFTaskDetailID from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where sp.PurposeTypeId=@PurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID
			and t.SubmitType=496
			order by t.WFTaskDetailID desc
	
	IF @Reject_WFTaskDetailID IS NOT NULL
	BEGIN
	      IF EXISTS(
	          Select  t.WFTaskDetailID from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where s.WFStatusMasterID=4 and sp.PurposeTypeId=@PurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID
			and t.WFTaskDetailID >= @Reject_WFTaskDetailID
			)
			BEGIN
			  SET @ShowSecondApproval=1
			END
	END
	ELSE IF EXISTS(
	          Select  t.WFTaskDetailID from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where s.WFStatusMasterID=4 and sp.PurposeTypeId=@PurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID
			and t.SubmitType=498
			
			)
	BEGIN
		   SET @ShowSecondApproval=1
	END
	
	
	
	
	--print @AmountTobeCheckForPrimaryAM

	--for any AM to get reject button
	IF EXISTS(Select rs.SearchKey
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.PurposeTypeID=@PurposeTypeId
		and (rs.SearchKey IS NULL or rs.SearchKey='No Search Condition'))
		
		BEGIN
			Select 
			@TaskID as TaskID,
			mapp.OrderIndex,
			mapp.WFStatusMasterID,
			sm.StatusName,
			StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
			mapp.WFStatusPurposeMappingID	
			from CRE.WFRejectStatus rs
			join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
			join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
			Where mapp.PurposeTypeId = @PurposeTypeId
			and rs.SearchKey='No Search Condition'
			and rs.PurposeTypeID=@PurposeTypeId
		 
		END

	--====================================
	ELSE IF(@FirstDealFundingID = @TaskID) --First Draw
	BEGIN
		print 'First Draw'
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'First draw'
		and rs.PurposeTypeID=@PurposeTypeId
	END
	ELSE IF (@Amount<=@AmountTobeCheckForPrimaryAM)
	BEGIN
	print '<=500k'
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'Less than or equal to 500k'
		and rs.PurposeTypeID=@PurposeTypeId
		AND ((@ShowSecondApproval=0 and rs.WFStatusMasterID not in (4)) OR @ShowSecondApproval=1)
	END
	ELSE IF (@Amount<=@AmountTobeCheckforL1L2)
	BEGIN
	print '<=1.5M'
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'Less than or equal to 1.5M'
		and rs.PurposeTypeID=@PurposeTypeId
		AND ((@ShowSecondApproval=0 and rs.WFStatusMasterID not in (4)) OR @ShowSecondApproval=1)
	END
	ELSE IF (@Amount>@AmountTobeCheckforL1L2)
	BEGIN
	print '>1.5M'
	print @PurposeTypeId
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'Greater than 1.5M'
		and rs.PurposeTypeID=@PurposeTypeId
		AND ((@ShowSecondApproval=0 and rs.WFStatusMasterID not in (4)) OR @ShowSecondApproval=1)
	END
	END
	ELSE IF(@TaskTypeID=719)
	BEGIN
	   Select 
		@DealID = DealID,
		@PurposeTypeId = PurposeID,
		@Amount = Amount
		from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID
		SELECT @WorkFlowType =Value1 from core.lookup where LookupID=@PurposeTypeId

		Select top 1 @FirstDealFundingID=DealReserveScheduleGUID from cre.DealReserveSchedule where dealid = @DealID and PurposeID = @PurposeTypeId
		order by Date
	
	
	
	
	
	  Select  top 1 @Reject_WFTaskDetailID = t.WFTaskDetailID from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where sp.PurposeTypeId=@PurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID
			and t.SubmitType=496
			order by t.WFTaskDetailID desc
	
	IF @Reject_WFTaskDetailID IS NOT NULL
	BEGIN
	      IF EXISTS(
	          Select  t.WFTaskDetailID from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where s.WFStatusMasterID=4 and sp.PurposeTypeId=@PurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID
			and t.WFTaskDetailID >= @Reject_WFTaskDetailID
			)
			BEGIN
			  SET @ShowSecondApproval=1
			END
	END
	ELSE IF EXISTS(
	          Select  t.WFTaskDetailID from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where s.WFStatusMasterID=4 and sp.PurposeTypeId=@PurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID
			and t.SubmitType=498
			
			)
	BEGIN
		   SET @ShowSecondApproval=1
	END
	
	
	
	
	--print @AmountTobeCheckForPrimaryAM

	--for any AM to get reject button
	IF EXISTS(Select rs.SearchKey
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.PurposeTypeID=@PurposeTypeId
		and (rs.SearchKey IS NULL or rs.SearchKey='No Search Condition'))
		
		BEGIN
			Select 
			@TaskID as TaskID,
			mapp.OrderIndex,
			mapp.WFStatusMasterID,
			sm.StatusName,
			StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
			mapp.WFStatusPurposeMappingID	
			from CRE.WFRejectStatus rs
			join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
			join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
			Where mapp.PurposeTypeId = @PurposeTypeId
			and rs.SearchKey='No Search Condition'
			and rs.PurposeTypeID=@PurposeTypeId
		 
		END

	--====================================
	ELSE IF(@FirstDealFundingID = @TaskID) --First Draw
	BEGIN
		print 'First Draw'
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'First draw'
		and rs.PurposeTypeID=@PurposeTypeId
	END
	ELSE IF (@Amount<=@AmountTobeCheckForPrimaryAM)
	BEGIN
	print '<=500k'
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'Less than or equal to 500k'
		and rs.PurposeTypeID=@PurposeTypeId
		AND ((@ShowSecondApproval=0 and rs.WFStatusMasterID not in (4)) OR @ShowSecondApproval=1)
	END
	ELSE IF (@Amount<=@AmountTobeCheckforL1L2)
	BEGIN
	print '<=1.5M'
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'Less than or equal to 1.5M'
		and rs.PurposeTypeID=@PurposeTypeId
		AND ((@ShowSecondApproval=0 and rs.WFStatusMasterID not in (4)) OR @ShowSecondApproval=1)
	END
	ELSE IF (@Amount>@AmountTobeCheckforL1L2)
	BEGIN
	print '>1.5M'
	print @PurposeTypeId
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		StatusDisplayName = (CASE WHEN @WorkFlowType='WF_UNDERREVIEW' then  sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
		mapp.WFStatusPurposeMappingID	
		from CRE.WFRejectStatus rs
		join cre.WFStatusMaster sm on sm.WFStatusMasterID = rs.WFStatusMasterID
		join cre.WFStatusPurposeMapping mapp on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and rs.SearchKey = 'Greater than 1.5M'
		and rs.PurposeTypeID=@PurposeTypeId
		AND ((@ShowSecondApproval=0 and rs.WFStatusMasterID not in (4)) OR @ShowSecondApproval=1)
	END
	   
	END 
END
