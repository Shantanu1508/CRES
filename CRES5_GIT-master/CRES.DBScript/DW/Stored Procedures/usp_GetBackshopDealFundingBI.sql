CREATE PROCEDURE [DW].[usp_GetBackshopDealFundingBI] 

AS
BEGIN
     SET NOCOUNT ON;
   

   truncate table dw.BackshopDealFundingBI

   SELECT [ControlID]
      ,[DealName]
      ,[FundingDate]
      ,[FundingAmount]
  FROM [DW].[BackshopDealFundingBI]

END