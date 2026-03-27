CREATE PROCEDURE [VAL].[usp_InsertUpdatedDealList]
(
	@tbltype_DealList [val].[tbltype_DealList] READONLY

	--@Calculate	nvarchar(10)	,
	--@DealID	nvarchar(256)	,
	--@Scenario	nvarchar(256)	,
	--@IndexType	nvarchar(100)	,
	--@IndexForecast	decimal(28,15)	,
	--@IndexFloor	decimal(28,15)	, 
	--@PORTFOLIO	nvarchar(100)	,	
	--@LastIndexReset	decimal(28,15)	,
	--@PaymentDay	int	,
	--@PriceCaptoThirdParty	decimal(28,15)	,
	--@DealNominalDMOrPriceForMark	decimal(28,15)	,
	--@DMAdjustment	decimal(28,15)	,
	--@StubInterestinAdvancelastaccrualDate	Date	,
	--@IOValuationmo	decimal(28,15)	,
	--@PendingPayoff	decimal(28,15)	,
	--@PpayAdjustedAL	decimal(28,15)	,
	--@MaterialMezz	nvarchar(256)	,
	--@SliverMezz	int	,		
	--@UserID	nvarchar(256)	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_DealList))


	IF OBJECT_ID('tempdb..[#tblDealList]') IS NOT NULL                                         
		DROP TABLE [#tblDealList]  

	Create table [#tblDealList]
	(
		MarkedDateMasterID int,
		Calculate	int,
		DealID	UNIQUEIDENTIFIER,
		Scenario	UNIQUEIDENTIFIER,
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
		UserID	nvarchar(256),
		IsCashFlowLive int,

		Insert_Update_flag nvarchar(256)
	)


	INSERT INTO [#tblDealList](MarkedDateMasterID,Calculate,DealID,Scenario,IndexType,IndexForecast,IndexFloor,PORTFOLIO,LastIndexReset,PaymentDay,PriceCaptoThirdParty,DealNominalDMOrPriceForMark,DMAdjustment,StubInterestinAdvancelastaccrualDate,IOValuationmo,PendingPayoff,PpayAdjustedAL,MaterialMezz,SliverMezz,UserID,IsCashFlowLive,Insert_Update_flag)
	Select @MarkedDateMasterID
	,lCalculate.lookupid as Calculate
	,d.dealid as DealID
	,an.analysisid as Scenario
	,IndexType,IndexForecast,IndexFloor,PORTFOLIO,LastIndexReset,PaymentDay,PriceCaptoThirdParty,DealNominalDMOrPriceForMark,DMAdjustment,StubInterestinAdvancelastaccrualDate,IOValuationmo,PendingPayoff,PpayAdjustedAL,MaterialMezz,SliverMezz,UserID
	,lIsCashFlowLive.LookupID as IsCashFlowLive
	,'insert' as Insert_Update_flag
	
	From @tbltype_DealList dl
	left Join cre.deal d on d.credealid = dl.dealid
	left join core.lookup lCalculate on lCalculate.name = dl.Calculate and lCalculate.ParentID = 95
	left join core.lookup lIsCashFlowLive on lIsCashFlowLive.name = dl.IsCashFlowLive and lIsCashFlowLive.ParentID = 95
	left join Core.Analysis an on an.Name = dl.Scenario
	Where d.isdeleted <> 1


	Update [#tblDealList] set Insert_Update_flag = 'update' 
	where dealid in (
		Select dl.dealid
		from [#tblDealList] dl
		Inner Join [VAL].[DealList] mdl on mdl.dealid = dl.dealid and mdl.MarkedDateMasterID = dl.MarkedDateMasterID
	)
	

	INSERT INTO [VAL].[DealList](
		MarkedDateMasterID
		,[Calculate]
		,[DealID]
		,[Scenario]
		,[IndexType]
		,[IndexForecast]
		,[IndexFloor]	 
		,[PORTFOLIO]
		,[LastIndexReset]
		,[PaymentDay]
		,[PriceCaptoThirdParty]
		,[DealNominalDMOrPriceForMark]
		,[DMAdjustment]
		,[StubInterestinAdvancelastaccrualDate]
		,[IOValuationmo]
		,[PendingPayoff]
		,[PpayAdjustedAL]
		,[MaterialMezz]
		,[SliverMezz]
		,IsCashFlowLive
		,[CreatedBy]
		,[CreatedDate]
		,[UpdateBy]
		,[UpdatedDate])
		Select 
		@MarkedDateMasterID
		,Calculate
		,DealID
		,Scenario
		,IndexType
		,IndexForecast
		,IndexFloor
		,PORTFOLIO
		,LastIndexReset
		,PaymentDay
		,PriceCaptoThirdParty
		,DealNominalDMOrPriceForMark
		,DMAdjustment
		,CASE When StubInterestinAdvancelastaccrualDate='0001-01-01' Then NULL ELSE StubInterestinAdvancelastaccrualDate END StubInterestinAdvancelastaccrualDate
		,IOValuationmo
		,PendingPayoff
		,PpayAdjustedAL
		,MaterialMezz
		,SliverMezz
		,IsCashFlowLive
		,UserID
		,Getdate()
		,UserID
		,Getdate()
		From [#tblDealList]
		Where Insert_Update_flag = 'insert'




		Update [VAL].[DealList] SET 
		Calculate		= z.Calculate,
		DealID			= z.DealID,
		Scenario		= z.Scenario,
		IndexType		= z.IndexType,
		IndexForecast	= z.IndexForecast,
		IndexFloor		= z.IndexFloor,		 
		PORTFOLIO		= z.PORTFOLIO,
		LastIndexReset	= z.LastIndexReset,
		PaymentDay		= z.PaymentDay,
		PriceCaptoThirdParty					= z.PriceCaptoThirdParty,
		DealNominalDMOrPriceForMark				= z.DealNominalDMOrPriceForMark,
		DMAdjustment							= z.DMAdjustment,
		StubInterestinAdvancelastaccrualDate	= CASE When z.StubInterestinAdvancelastaccrualDate='0001-01-01' Then NULL ELSE z.StubInterestinAdvancelastaccrualDate END,
		IOValuationmo	= z.IOValuationmo,
		PendingPayoff	= z.PendingPayoff,
		PpayAdjustedAL	= z.PpayAdjustedAL,
		MaterialMezz	= z.MaterialMezz,
		SliverMezz		= z.SliverMezz,
		IsCashFlowLive = z.IsCashFlowLive,
		UpdateBy= z.UserID,
		UpdatedDate	= getdate()
		From(
			Select 
			MarkedDateMasterID
			,Calculate
			,DealID
			,Scenario
			,IndexType
			,IndexForecast
			,IndexFloor
			,PORTFOLIO
			,LastIndexReset
			,PaymentDay
			,PriceCaptoThirdParty
			,DealNominalDMOrPriceForMark
			,DMAdjustment
			,StubInterestinAdvancelastaccrualDate
			,IOValuationmo
			,PendingPayoff
			,PpayAdjustedAL
			,MaterialMezz
			,SliverMezz
			,IsCashFlowLive
			,UserID			
			From [#tblDealList]
			Where Insert_Update_flag = 'update'
		)z
		Where [VAL].[DealList].dealid = z.Dealid and [VAL].[DealList].MarkedDateMasterID = z.MarkedDateMasterID 






 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

