CREATE TYPE [val].[tbltype_DealOutput] AS TABLE
(
	MarkedDate date
	,DealID	nvarchar(256)
	,CalculationStatus	nvarchar(256)
	,LastCalculatedon	datetime
	,PayoffExtended	int
	,DealMarkPriceClean	decimal(28,15)
	,DealGAAPPriceClean	decimal(28,15)
	,DealMarkClean	decimal(28,15)
	,DealUPB	decimal(28,15)
	,DealCommitment	decimal(28,15)
	,DealGAAPBasisDirty	decimal(28,15)
	,DealYieldatParClean	decimal(28,15)
	,DealYieldatGAAPBasis	decimal(28,15)
	,DealMarkYield	decimal(28,15)
	,CalculatedDealAccruedRate	decimal(28,15)
	,DealGAAPDM_GtrFLR_Index	decimal(28,15)
	,DealMarkDM_GtrFLR_Index	decimal(28,15)
	,DealDuration_OnCommitment	decimal(28,15)
	,GrossFloorValuefromGrid	decimal(28,15)
	,GrossValue_UsageScalar	decimal(28,15)
	,DollarValueofFloorinMark	decimal(28,15)
	,PointvalueofFloorinMark	decimal(28,15)
	,Term	decimal(28,15)
	,Strike	decimal(28,15)
	,MktStrike	decimal(28,15)
	,UserID	nvarchar(256)
)

