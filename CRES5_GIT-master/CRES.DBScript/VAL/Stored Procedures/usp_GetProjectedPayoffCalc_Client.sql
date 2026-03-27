CREATE PROCEDURE [VAL].[usp_GetProjectedPayoffCalc_Client]  --'21-2086'
	@MarkedDate date,
	@CREDealid nvarchar(256) = null
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	Select
	 p.ControlID
	,p.DealName
	,p.Client
	--,null as FHLB
	--,null as Servicer
	--,null as ServicerLoan
	--,null as Sponsor
	--,null as Location
	--,null as Region
	,p.PropertyType
	--,null as ACOREOffice
	--,null as Banker
	--,null as AMOversight
	--,null as PrimaryAM
	--,null as AlternateAssetManager
	--,null as OriginationDate
	--,null as MaturityDate
	,CAST(FullyExtendedMaturityDate as Datetime) as FullyExtendedMaturityDate
	--,null as ProjectedCompletionDate
	--,null as Complete
	--,null as Leased
	--,null as Spread
	--,null as CurrentIndex
	--,null as IndexFloor
	--,null as IndexCap
	--,null as CurrentCoupon
	--,null as XIRR
	--,null as StabLTV
	--,null as FeesDueforNextExtension
	--,null as ExitFee
	,p.OpenDate
	From [VAL].[ProjectedPayoffCalc] p
	Where MarkedDateMasterID = @MarkedDateMasterID
	and 1 = (CASE WHEN @CREDealid is null THEN 1 WHEN p.ControlID = @CREDealid THEN 1 ELSE 0 END ) 
	

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
