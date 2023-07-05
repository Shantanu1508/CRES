
CREATE PROCEDURE [dbo].[usp_GetCREDealIdByDealID] --'18-0866'
(
	@DealID uniqueidentifier,
	@UserID uniqueidentifier
	
)
AS

 BEGIN
 	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

	SELECT CREDealID from cre.deal where dealid = @DealID
			

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
