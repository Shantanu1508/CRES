
--[dbo].[usp_GetStatusMasterByTaskId] 'c01d4dd6-151b-44ef-8d2b-5a634d219e89','c01d4dd6-151b-44ef-8d2b-5a634d219e89'

CREATE PROCEDURE [dbo].[usp_GetStatusMasterByTaskId] 
(
    @TaskTypeID int,
	@TaskID nvarchar(256),
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;

	Declare @PurposeTypeId int 
	Declare @DealID uniqueidentifier
	Declare @FirstDealFundingID uniqueidentifier

	if(@TaskTypeID=502)
	BEGIN
	Select 
	@DealID = DealID,
	@PurposeTypeId = PurposeID 
	from cre.DealFunding where DealFundingID=@TaskID

	Select top 1 @FirstDealFundingID=DealFundingID from cre.DealFunding where dealid = @DealID and PurposeID = @PurposeTypeId
    order by Date,DealFundingRowno

	--====================================
	IF(@FirstDealFundingID = @TaskID) --First Draw
	BEGIN
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		sm.StatusDisplayName,
		mapp.WFStatusPurposeMappingID	
		from cre.WFStatusPurposeMapping mapp 
		left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and sm.StatusName not in ('Submitted for Approval (L1)','Submitted for Approval (L2)')
	END
	ELSE
	BEGIN
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		sm.StatusDisplayName,
		mapp.WFStatusPurposeMappingID	
		from cre.WFStatusPurposeMapping mapp 
		left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
	END

  END
  ELSE IF(@TaskTypeID=719)
	BEGIN
	Select 
	@DealID = DealID,
	@PurposeTypeId = PurposeID 
	from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID

	Select top 1 @FirstDealFundingID=DealReserveScheduleGUID from cre.DealReserveSchedule where dealid = @DealID and PurposeID = @PurposeTypeId
    order by Date

	--====================================
	IF(@FirstDealFundingID = @TaskID) --First Draw
	BEGIN
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		sm.StatusDisplayName,
		mapp.WFStatusPurposeMappingID	
		from cre.WFStatusPurposeMapping mapp 
		left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
		and sm.StatusName not in ('Submitted for Approval (L1)','Submitted for Approval (L2)')
	END
	ELSE
	BEGIN
		Select 
		@TaskID as TaskID,
		mapp.OrderIndex,
		mapp.WFStatusMasterID,
		sm.StatusName,
		sm.StatusDisplayName,
		mapp.WFStatusPurposeMappingID	
		from cre.WFStatusPurposeMapping mapp 
		left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID	
		Where mapp.PurposeTypeId = @PurposeTypeId
	END
	
	
	END 


END
