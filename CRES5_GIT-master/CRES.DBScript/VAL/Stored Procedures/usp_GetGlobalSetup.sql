CREATE PROCEDURE [VAL].[usp_GetGlobalSetup]
(
	@MarkedDate date
)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	SELECT 
		 gs.[GlobalSetupID]		 
		,lUseDurSpreadVolWt.name as UseDurSpreadVolWt	 
		,lGAAPBasisInputsIncludeAccrued.name as GAAPBasisInputsIncludeAccrued
		,gs.[MinimumExcessIOCredit]
		,gs.[PercentageofFloorValueincludedinMark]
		---,gs.[MarkedDate]
		,gs.FloorIndexDate
		,gs.PricingGridKey
		,gs.PricingGridMarketSOFRFloor
		,gs.[CreatedBy]
		,gs.[CreatedDate]
		,gs.[UpdatedBy]
		,gs.[UpdatedDate]
		,gs.[LIBORForecast]
	FROM [VAL].[GlobalSetup] gs
	Left Join core.lookup lUseDurSpreadVolWt on lUseDurSpreadVolWt.lookupID = gs.UseDurSpreadVolWt
	Left Join core.lookup lGAAPBasisInputsIncludeAccrued on lGAAPBasisInputsIncludeAccrued.lookupID = gs.GAAPBasisInputsIncludeAccrued
	Where MarkedDateMasterID = @MarkedDateMasterID


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

