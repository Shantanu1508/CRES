
CREATE PROCEDURE [VAL].[usp_InsertUpdatedDealOutput]
(
	@tbltype_DealOutput [val].[tbltype_DealOutput] READONLY 

	--@DealID	nvarchar(256)
	--,@CalculationStatus	int
	--,@LastCalculatedon	datetime
	--,@PayoffExtended	int
	--,@DealMarkPriceClean	decimal(28,15)
	--,@DealGAAPPriceClean	decimal(28,15)
	--,@DealMarkClean	decimal(28,15)
	--,@DealUPB	decimal(28,15)
	--,@DealCommitment	decimal(28,15)
	--,@DealGAAPBasisDirty	decimal(28,15)
	--,@DealYieldatParClean	decimal(28,15)
	--,@DealYieldatGAAPBasis	decimal(28,15)
	--,@DealMarkYield	decimal(28,15)
	--,@CalculatedDealAccruedRate	decimal(28,15)
	--,@DealGAAPDM_GtrFLR_Index	decimal(28,15)
	--,@DealMarkDM_GtrFLR_Index	decimal(28,15)
	--,@DealDuration_OnCommitment	decimal(28,15)
	--,@GrossFloorValuefromGrid	decimal(28,15)
	--,@GrossValue_UsageScalar	decimal(28,15)
	--,@DollarValueofFloorinMark	decimal(28,15)
	--,@PointvalueofFloorinMark	decimal(28,15)
	--,@Term	decimal(28,15)
	--,@Strike	decimal(28,15)
	--,@MktStrike	decimal(28,15)

	--,@UserID	nvarchar(256)	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_DealOutput))




	Delete from [VAL].[DealOutput] where dealid in (
		Select Distinct d.dealid from cre.deal d
		Inner join @tbltype_DealOutput t on t.DealID = d.CREDealID		
	)
	and MarkedDateMasterID = @MarkedDateMasterID


	INSERT INTO [VAL].[DealOutput]
	(MarkedDateMasterID
	,[DealID]
	,[CalculationStatus]
	,[LastCalculatedon]
	,[PayoffExtended]
	,[DealMarkPriceClean]
	,[DealGAAPPriceClean]
	,[DealMarkClean]
	,[DealUPB]
	,[DealCommitment]
	,[DealGAAPBasisDirty]
	,[DealYieldatParClean]
	,[DealYieldatGAAPBasis]
	,[DealMarkYield]
	,[CalculatedDealAccruedRate]
	,[DealGAAPDM_GtrFLR_Index]
	,[DealMarkDM_GtrFLR_Index]
	,[DealDuration_OnCommitment]
	,[GrossFloorValuefromGrid]
	,[GrossValue_UsageScalar]
	,[DollarValueofFloorinMark]
	,[PointvalueofFloorinMark]
	,[Term]
	,[Strike]
	,[MktStrike]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdateBy]
	,[UpdatedDate])
	Select 
	@MarkedDateMasterID
	 ,d.[DealID]
	,t.[CalculationStatus]
	,t.[LastCalculatedon]
	,t.[PayoffExtended]
	,t.[DealMarkPriceClean]
	,t.[DealGAAPPriceClean]
	,t.[DealMarkClean]
	,t.[DealUPB]
	,t.[DealCommitment]
	,t.[DealGAAPBasisDirty]
	,t.[DealYieldatParClean]
	,t.[DealYieldatGAAPBasis]
	,t.[DealMarkYield]
	,t.[CalculatedDealAccruedRate]
	,t.[DealGAAPDM_GtrFLR_Index]
	,t.[DealMarkDM_GtrFLR_Index]
	,t.[DealDuration_OnCommitment]
	,t.[GrossFloorValuefromGrid]
	,t.[GrossValue_UsageScalar]
	,t.[DollarValueofFloorinMark]
	,t.[PointvalueofFloorinMark]
	,t.[Term]
	,t.[Strike]
	,t.[MktStrike]
	,t.UserID
	,getdate()
	,t.UserID
	,getdate()
	From @tbltype_DealOutput t
	Left Join CRE.Deal d on d.credealid = t.dealid




 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
