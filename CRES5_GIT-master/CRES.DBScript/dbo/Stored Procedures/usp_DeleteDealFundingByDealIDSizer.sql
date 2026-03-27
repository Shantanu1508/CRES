-- Procedure

CREATE PROCEDURE [dbo].[usp_DeleteDealFundingByDealIDSizer] 
@credealid nvarchar(256)

AS
BEGIN

Delete from cre.DealFunding where DealID=(select Top 1 DealID from cre.Deal where credealID= @creDealID and isdeleted <> 1);

END
