CREATE PROCEDURE [DW].[usp_InsertBackshopDealFundingBI] 
(
	@ControlID [nvarchar](100) ,
	@DealName [nvarchar](256) ,
	@FundingDate [datetime] ,
	@FundingAmount [decimal](28, 15) 
)
AS
BEGIN
     SET NOCOUNT ON;
   
  INSERT INTO [DW].[BackshopDealFundingBI]([ControlID],[DealName] ,[FundingDate]
           ,[FundingAmount])
     VALUES
	 (@ControlID,
	 @DealName,
	 @FundingDate,
	 @FundingAmount
	 )

END
