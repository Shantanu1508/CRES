
CREATE PROCEDURE [dbo].[usp_DeletePayruleSetupByDealIDSizer] 
@credealid nvarchar(256)

AS
BEGIN 

Delete from cre.[PayruleSetup] where DealID=(select Top 1 DealID from cre.Deal where credealID= @creDealID);

END
