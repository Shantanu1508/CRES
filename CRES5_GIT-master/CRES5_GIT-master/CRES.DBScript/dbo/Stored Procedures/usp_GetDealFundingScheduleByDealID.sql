


CREATE PROCEDURE [dbo].[usp_GetDealFundingScheduleByDealID] --'250ED133-E591-4EA3-91B8-9CB2D1A48495'
(
    @DealID UNIQUEIDENTIFIER
	
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Select
 fs.DealFundingID, 
 fs.[DealID]
,fs.[Date]
,fs.[Amount]
,fs.[Comment]
,fs.[PurposeID]
,fs.UpdatedDate
,l1.name PurposeText
,fs.DealFundingRowno
,ISNULL(fs.Applied,0) Applied
,DrawFundingId

from [CRE].[DealFunding] fs
left join cre.deal d on d.DealID = fs.DealID
Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID
where fs.DealID = @DealID and d.IsDeleted = 0

order by fs.[Date]
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

