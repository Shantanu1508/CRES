
CREATE PROCEDURE [dbo].[usp_InsertDealFundingScheduleSizer] 
@creDealID nvarchar(256),
@Date datetime,
@Amount decimal(28,15),
@PurposeID int,
@Comment nvarchar(max),
@UpdatedBy nvarchar(256)

AS
BEGIN

 
INSERT INTO cre.DealFunding (DealID, Date, Amount,PurposeID,Comment, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
	SELECT 
	(select Top 1 DealID from cre.Deal where credealID= @creDealID),
	@Date,
	@Amount,
	@PurposeID,
	@Comment,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()  
	WHERE @Date is not null AND isnull(@Amount,0) !=0 
END
