
 

CREATE PROCEDURE [IO].[usp_ImpportFromBackshopByDealID] 
(
	@CREDealID nvarchar(256) 
)
AS 
BEGIN

Declare @UserName nvarchar(256) = (Select top 1 UserID from app.[user] where login like '%krishna%')

DECLARE @BatchLogID UNIQUEIDENTIFIER;

DECLARE @tBatchLog TABLE (tBatchLogID UNIQUEIDENTIFIER)


--Insert in batchlog
INSERT INTO [IO].[BatchLog]([BatchTypeID] ,[StartTime] ,[EndTime] ,[StartedByUserID] ,[ErrorMessage] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate])
OUTPUT inserted.BatchLogID INTO @tBatchLog(tBatchLogID)
VALUES(250,GETDATE(),NULL,@UserName,NULL,@UserName,GETDATE(),@UserName,GETDATE()) 

SET @BatchLogID = (Select tBatchLogID FROM @tBatchLog)
 

--ImportDataFromBackshopViews to landing tables
EXEC [dbo].[usp_ImportDataFromBackshopViews]

--Check If deal exist in Backshop
IF Exists(Select controlid as DealID,DealName from [IO].[IN_AcctDeal]  where controlid = @CREDealID)
BEGIN
	Print('Deal exists in ')

	exec [dbo].[usp_ImportBackShopInLandingtable] @CREDealID,@UserName,@BatchLogID
	exec [dbo].[usp_ImportLandingtableToMainDB]  @CREDealID,@UserName,@BatchLogID

END
ELSE
BEGIN
	Print('Deal does not exists in BackShop')
END













END



