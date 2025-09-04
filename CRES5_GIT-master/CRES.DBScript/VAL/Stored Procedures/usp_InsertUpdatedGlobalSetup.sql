CREATE PROCEDURE [VAL].[usp_InsertUpdatedGlobalSetup]
(
	@MarkedDate date,

	@UseDurSpreadVolWt	nvarchar(20),
	@GAAPBasisInputsIncludeAccrued	nvarchar(20),
	@MinimumExcessIOCredit	int,
	@PercentageofFloorValueincludedinMark	decimal(28,15),
	---@MarkedDate	Date,
	@FloorIndexDate Date,
	@UserID	nvarchar(256),
	@PricingGridKey nvarchar(256),
	@PricingGridMarketSOFRFloor decimal(28, 15),
	@LIBORForecast decimal(28,15)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	Declare @L_UseDurSpreadVolWt int = (Select lookupid from core.lookup where [name] = @UseDurSpreadVolWt and ParentID = 95);
	Declare @L_GAAPBasisInputsIncludeAccrued int = (Select lookupid from core.lookup where [name] = @GAAPBasisInputsIncludeAccrued and ParentID = 95);
	

	IF EXISTS(Select GlobalSetupID from [VAL].[GlobalSetup] where MarkedDateMasterID = @MarkedDateMasterID)
	BEGIN
		Update [VAL].[GlobalSetup] SET
		UseDurSpreadVolWt = @L_UseDurSpreadVolWt,
		GAAPBasisInputsIncludeAccrued = @L_GAAPBasisInputsIncludeAccrued,
		MinimumExcessIOCredit = @MinimumExcessIOCredit,
		PercentageofFloorValueincludedinMark = @PercentageofFloorValueincludedinMark,
		---MarkedDate = @MarkedDate,
		FloorIndexDate = @FloorIndexDate,
		PricingGridKey=@PricingGridKey,
		PricingGridMarketSOFRFloor=@PricingGridMarketSOFRFloor,
		LIBORForecast=@LIBORForecast,
		UpdatedBy= @UserID,
		UpdatedDate	= getdate()
		Where MarkedDateMasterID = @MarkedDateMasterID

	END
	ELSE
	BEGIN
		INSERT INTO [VAL].[GlobalSetup](
		MarkedDateMasterID
		,UseDurSpreadVolWt
		,GAAPBasisInputsIncludeAccrued
		,MinimumExcessIOCredit
		,PercentageofFloorValueincludedinMark
		--,MarkedDate
		,FloorIndexDate
		,PricingGridKey
		,PricingGridMarketSOFRFloor
		,LIBORForecast
		,CreatedBy
		,CreatedDate
		,UpdatedBy
		,UpdatedDate)
		VALUES(
		@MarkedDateMasterID
		,@L_UseDurSpreadVolWt
		,@L_GAAPBasisInputsIncludeAccrued
		,@MinimumExcessIOCredit
		,@PercentageofFloorValueincludedinMark
		--,@MarkedDate
		,@FloorIndexDate
		,@PricingGridKey
		,@PricingGridMarketSOFRFloor
		,@LIBORForecast
		,@UserID
		,getdate()
		,@UserID
		,getdate())
		
	END

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

