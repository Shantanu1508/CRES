
CREATE PROCEDURE [VAL].[usp_GetDealOutput]
	@MarkedDate date,
	@TimeZoneName nvarchar(250)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)



	select 
	do.CalculationStatus
	,isnull( [dbo].[ufn_GetTimeByTimeZoneName] (LastCalculatedOn,@TimeZoneName ),LastCalculatedOn)  as LastCalculatedOn
	,lPayoffExtended.name as [PayoffExtended]
	,d.credealid as [DealID]
	,d.dealname
	,do.[DealMarkPriceClean]
	,do.[DealGAAPPriceClean]
	,do.[DealMarkClean]
	,do.[DealUPB]
	,do.[DealCommitment]
	,do.[DealGAAPBasisDirty]
	,do.[DealYieldatParClean]
	,do.[DealYieldatGAAPBasis]
	,do.[DealMarkYield]
	,do.[CalculatedDealAccruedRate]
	,do.[DealGAAPDM_GtrFLR_Index]
	,do.[DealMarkDM_GtrFLR_Index]
	,do.[DealDuration_OnCommitment]
	,do.[GrossFloorValuefromGrid]
	,do.[GrossValue_UsageScalar]
	,do.[DollarValueofFloorinMark]
	,do.[PointvalueofFloorinMark]
	,do.[Term]
	,do.[Strike]
	,do.[MktStrike]	 
	from [val].DealOutput do
	Inner join cre.deal d on d.dealid = do.dealid	 
	left Join Core.lookup lPayoffExtended on lPayoffExtended.lookupid = do.PayoffExtended
	where do.MarkedDateMasterID = @MarkedDateMasterID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
