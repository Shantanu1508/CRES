CREATE TYPE [val].[tbltype_DealList] AS TABLE
(
	MarkedDate    Date ,
	Calculate	nvarchar(10)	,
	DealID	nvarchar(256)	,
	Scenario	nvarchar(256)	,
	IndexType	nvarchar(100)	,
	IndexForecast	decimal(28,15)	,
	IndexFloor	decimal(28,15)	, 
	PORTFOLIO	nvarchar(100)	,	
	LastIndexReset	decimal(28,15)	,
	PaymentDay	int	,
	PriceCaptoThirdParty	decimal(28,15)	,
	DealNominalDMOrPriceForMark	decimal(28,15)	,
	DMAdjustment	decimal(28,15)	,
	StubInterestinAdvancelastaccrualDate	Date	,
	IOValuationmo	decimal(28,15)	,
	PendingPayoff	decimal(28,15)	,
	PpayAdjustedAL	decimal(28,15)	,
	MaterialMezz	nvarchar(256)	,
	SliverMezz	int	,
	IsCashFlowLive nvarchar(256),
	UserID	nvarchar(256)
)
