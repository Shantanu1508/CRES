



CREATE PROCEDURE [IO].[usp_DeleteBatchLogByBatchLogID] --'15-0050','0C1DF314-D83A-44F6-88D9-84AB6A3C41A0'
(
	@BatchLogID UNIQUEIDENTIFIER
)
	
AS
BEGIN

 

	DELETE From [IO].[BatchDetail] WHERE BatchLog_BatchLogID = @BatchLogID

	DELETE From [IO].[BatchLog] WHERE BatchLogID = @BatchLogID


END
