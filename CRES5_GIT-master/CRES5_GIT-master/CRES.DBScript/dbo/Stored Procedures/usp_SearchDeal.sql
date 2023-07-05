
--[usp_SearchDeal] 'new deal'
CREATE PROCEDURE [dbo].[usp_SearchDeal]
(
	@CREDealId nvarchar(256)
)
AS

 BEGIN
 
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 SELECT DealID
		,DealName
		,DealType
		,Status
		,l4.name StatusText
		,EstClosingDate 
		,CREDealID
		,d.AssetManager
  FROM CRE.Deal d
	Left Join Core.Lookup l4 on d.Status=l4.LookupID
	where (d.CREDealID=@CREDealId OR d.DealName = @CREDealId)
	and d.IsDeleted=0
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
