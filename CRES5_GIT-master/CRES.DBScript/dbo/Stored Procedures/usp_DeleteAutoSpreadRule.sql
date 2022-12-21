

CREATE PROCEDURE [dbo].[usp_DeleteAutoSpreadRule] 
@DealID nvarchar(256)

AS
BEGIN

  
Delete from CRE.AutoSpreadRule where DealID = @DealID


END

