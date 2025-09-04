CREATE PROCEDURE [VAL].[usp_GetDealList] 
	@MarkedDate date,
	@CREDealID nvarchar(256) = null

AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


 IF(@CREDealID is not null)
 BEGIN
	Select CalculateText,IsCashFlowLive,DealID,dealname,Scenario,IndexType,IndexForecast,IndexFloor,PORTFOLIO,LastIndexReset,PaymentDay,PriceCaptoThirdParty,DealNominalDMOrPriceForMark,DMAdjustment,StubInterestinAdvancelastaccrualDate,IOValuationmo,PendingPayoff,PpayAdjustedAL,MaterialMezz,SliverMezz
	From(
		SELECT 	 Distinct
		lCalculate.name as CalculateText
		,d.CREDealID as [DealID]
		,d.dealname
		,a.name as [Scenario]
		,dl.[IndexType]
		,CASE WHEN dl.[IndexType]='LIBOR01M' THEN GS.LIBORForecast ELSE RE.[Value] END as IndexForecast
		,dl.[IndexFloor] 
		,dl.[PORTFOLIO]
		,dl.[LastIndexReset]
		,dl.[PaymentDay]
		,ISNULL(dl.[PriceCaptoThirdParty], 99.5) as PriceCaptoThirdParty
		,dl.[DealNominalDMOrPriceForMark]
		,dl.[DMAdjustment]
		,CAST(dl.[StubInterestinAdvancelastaccrualDate] as DateTime) as StubInterestinAdvancelastaccrualDate
		,ISNULL(dl.[IOValuationmo], 3) as IOValuationmo
		,dl.[PendingPayoff]
		,dl.[PpayAdjustedAL]
		,dl.[MaterialMezz]
		,dl.[SliverMezz]
		,lIsCashFlowLive.Name IsCashFlowLive
		,ISNULL(DealListID ,999999999)  as DealListID	
		FROM [VAL].[DealList] dl	
		Inner join cre.deal d on d.dealid = dl.dealid
		Inner join cre.note n on n.dealid = d.dealid
		Inner join Core.account acc on acc.accountid = n.account_accountid
		Left Join core.lookup lCalculate on lCalculate.lookupID = dl.Calculate
		left join core.lookup lIsCashFlowLive on lIsCashFlowLive.lookupid = dl.IsCashFlowLive and lIsCashFlowLive.ParentID = 95
		Left Join core.Analysis a on a.AnalysisID = dl.[Scenario]
		Left Join Val.GlobalSetup GS ON GS.MarkedDateMasterID = dl.MarkedDateMasterID
		Left JOIN (
			Select Top 1 MarkedDateMasterID, [Value] 
			from Val.RateExtension 
			Where MarkedDateMasterID = @MarkedDateMasterID 
			Order By RateExtensionID Asc
		) RE ON RE.MarkedDateMasterID = DL.MarkedDateMasterID
		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		and d.status = 323
		and dl.MarkedDateMasterID = @MarkedDateMasterID
		and d.credealid = @CREDealID
	)a
	Order by DealListID  
 END
 ELSE
 BEGIN
 	Select CalculateText,IsCashFlowLive,DealID,dealname,Scenario,IndexType,IndexForecast,IndexFloor,PORTFOLIO,LastIndexReset,PaymentDay,PriceCaptoThirdParty,DealNominalDMOrPriceForMark,DMAdjustment,StubInterestinAdvancelastaccrualDate,IOValuationmo,PendingPayoff,PpayAdjustedAL,MaterialMezz,SliverMezz
	From(
		SELECT 	 Distinct
		lCalculate.name as CalculateText
		,d.CREDealID as [DealID]
		,d.dealname
		,a.name as [Scenario]
		,dl.[IndexType]
		,CASE WHEN dl.[IndexType]='LIBOR01M' THEN GS.LIBORForecast ELSE RE.[Value] END as IndexForecast
		,dl.[IndexFloor] 
		,dl.[PORTFOLIO]
		,dl.[LastIndexReset]
		,dl.[PaymentDay]
		,ISNULL(dl.[PriceCaptoThirdParty], 99.5) as PriceCaptoThirdParty
		,dl.[DealNominalDMOrPriceForMark]
		,dl.[DMAdjustment]
		,CAST(dl.[StubInterestinAdvancelastaccrualDate] as DateTime) as StubInterestinAdvancelastaccrualDate
		,ISNULL(dl.[IOValuationmo], 3) as IOValuationmo
		,dl.[PendingPayoff]
		,dl.[PpayAdjustedAL]
		,dl.[MaterialMezz]
		,dl.[SliverMezz]
		,lIsCashFlowLive.Name IsCashFlowLive
		,ISNULL(DealListID ,999999999)  as DealListID	
		FROM [VAL].[DealList] dl	
		Inner join cre.deal d on d.dealid = dl.dealid
		Inner join cre.note n on n.dealid = d.dealid
		Inner join Core.account acc on acc.accountid = n.account_accountid
		Left Join core.lookup lCalculate on lCalculate.lookupID = dl.Calculate
		left join core.lookup lIsCashFlowLive on lIsCashFlowLive.lookupid = dl.IsCashFlowLive and lIsCashFlowLive.ParentID = 95
		Left Join core.Analysis a on a.AnalysisID = dl.[Scenario]
		Left Join Val.GlobalSetup GS ON GS.MarkedDateMasterID = dl.MarkedDateMasterID
		Left JOIN (
			Select Top 1 MarkedDateMasterID, [Value] 
			from Val.RateExtension 
			Where MarkedDateMasterID = @MarkedDateMasterID 
			Order By RateExtensionID Asc
		) RE ON RE.MarkedDateMasterID = DL.MarkedDateMasterID
		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		and d.status = 323
		and dl.MarkedDateMasterID = @MarkedDateMasterID
	)a
	Order by DealListID  
END

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

