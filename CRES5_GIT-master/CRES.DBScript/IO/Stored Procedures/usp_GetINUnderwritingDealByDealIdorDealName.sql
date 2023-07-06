

--'15-0007'		'Stanley Hotel'
--'15-0050'		'Alden Park'
--'15-0480'		'10 Jay Street'
--[IO].[usp_GetINUnderwritingDealByDealIdorDealName] '15-0006'

CREATE PROCEDURE [IO].[usp_GetINUnderwritingDealByDealIdorDealName] --'15-0006'
(
	@DealName nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Select '' as DealID,DealName from cre.Deal
	--Select controlid as DealID,DealName from tblControlMaster  where dealname = @DealName
	

	Select 
	[IN_UnderwritingDealID]
	,[ClientDealID]
	,[DealName]
	,[StatusID]
	,AssetManager
	,DealCity
	,DealState
	,DealPropertyType
	,TotalCommitment
	,FullyExtMaturityDate
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	from [IO].IN_UnderwritingDeal  
	where [ClientDealID] = @DealName


	--IF EXISTS(Select * from [IO].IN_UnderwritingDeal where [DealName] = @DealName)
	--BEGIN
	--	Select 
	--	[IN_UnderwritingDealID]
	--	,[ClientDealID]
	--	,[DealName]
	--	,[StatusID]
	--	,[CreatedBy]
	--	,[CreatedDate]
	--	,[UpdatedBy]
	--	,[UpdatedDate]
	--	from [IO].IN_UnderwritingDeal  
	--	where [DealName] = @DealName
	--END
	--ELSE
	--BEGIN
	--	Select 
	--	[IN_UnderwritingDealID]
	--	,[ClientDealID]
	--	,[DealName]
	--	,[StatusID]
	--	,[CreatedBy]
	--	,[CreatedDate]
	--	,[UpdatedBy]
	--	,[UpdatedDate]
	--	from [IO].IN_UnderwritingDeal  
	--	where [ClientDealID] = @DealName
	--END
	
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

