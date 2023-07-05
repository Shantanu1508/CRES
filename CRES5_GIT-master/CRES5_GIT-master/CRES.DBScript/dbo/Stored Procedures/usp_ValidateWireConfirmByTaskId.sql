CREATE PROCEDURE [dbo].[usp_ValidateWireConfirmByTaskId] 
(
    @TaskID nvarchar(500),
	@UserID nvarchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;

	Declare @DealID uniqueidentifier,@FundingDate DateTime,@Status int =0
	
	select @DealID = DealID, @FundingDate = [Date] from cre.DealFunding where DealFundingID=@TaskID
	
    IF EXISTS(select [date] from  cre.dealfunding where dealid=@DealID and cast([Date] as DATE)<cast(@FundingDate as DATE) and Applied=0)
	BEGIN
	   SET @Status=1
	END
	select @Status as StatusCode
END
