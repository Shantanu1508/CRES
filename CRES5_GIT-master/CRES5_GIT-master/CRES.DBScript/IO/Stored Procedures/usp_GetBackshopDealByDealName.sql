

--'15-0007'		'Stanley Hotel'
--'15-0050'		'Alden Park'
--'15-0480'		'10 Jay Street'

CREATE PROCEDURE [IO].[usp_GetBackshopDealByDealName] --'15-0006','Vbalapure'
(
	@DealName nvarchar(256)
)
AS
BEGIN


--Import Data From Backshop Views
EXEC [dbo].[usp_ImportDataFromBackshopViews]


	--Select '' as DealID,DealName from cre.Deal
	--Select controlid as DealID,DealName from tblControlMaster  where dealname = @DealName
	
	Select controlid as DealID,DealName from [IO].[IN_AcctDeal]  where controlid = @DealName


	--Select controlid as DealID,DealName from tblControlMaster  where controlid = @DealName


	--IF EXISTS(Select * from tblControlMaster  where dealname = @DealName)
	--BEGIN
	--	Select controlid as DealID,DealName from tblControlMaster  where dealname = @DealName
	--END
	--ELSE
	--BEGIN
	--	Select controlid as DealID,DealName from tblControlMaster  where controlid = @DealName
	--END
	

END

