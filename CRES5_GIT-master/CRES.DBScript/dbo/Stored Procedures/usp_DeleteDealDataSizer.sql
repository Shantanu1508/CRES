
CREATE PROCEDURE [dbo].[usp_DeleteDealDataSizer] 
@credealid nvarchar(256)

AS
BEGIN

exec usp_DeleteFundingRepaymentSequenceSizer @credealid
exec usp_DeleteDealFundingByDealIDSizer @credealid
 


END

