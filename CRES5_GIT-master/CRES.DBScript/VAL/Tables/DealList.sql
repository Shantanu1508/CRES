CREATE TABLE [VAL].[DealList] (
    
	DealListID    INT    IDENTITY (1, 1) NOT NULL,
	MarkedDateMasterID    INT ,

	Calculate	int	,
	DealID	Uniqueidentifier	,
	Scenario	Uniqueidentifier	,
	IndexType	nvarchar(100)	,
	IndexForecast	decimal(28,15)	,
	IndexFloor	decimal(28,15)	,
	---ExcludefromServerCalculation	int	,
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
	
	IsCashFlowLive int,

	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime


    CONSTRAINT [PK_DealList_DealListID] PRIMARY KEY CLUSTERED ([DealListID] ASC)   , 
	CONSTRAINT [FK_DealList_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





