Create PROCEDURE [dbo].[usp_GetDealFundingByDealFundingID] 
(
    @UserID nvarchar(256),
    @DealFundingID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	--get dealfunding by dealid
    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT [DealFundingID]
      ,[DealID]
      ,[Date]
      ,[Amount]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[Comment]
      ,[PurposeID]
      ,[Applied]
      ,[DrawFundingId]
      ,[Issaved]
      ,[DealFundingRowno]
      ,[DeadLineDate]
      ,[LegalDeal_DealFundingID]
      ,[EquityAmount]
      ,[RemainingFFCommitment]
      ,[RemainingEquityCommitment]
      ,[SubPurposeType]
      ,[DealFundingAutoID]
      ,[RequiredEquity]
      ,[AdditionalEquity]
  FROM [CRE].[DealFunding]
  where DealFundingID = @DealFundingID
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
