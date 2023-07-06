
CREATE PROCEDURE [dbo].[usp_DeleteBatchRequestByAnalysisID] --'23f0b173-722d-4802-a8ad-c87c5c0c90e8'
(
	@AnalysisID UNIQUEIDENTIFIER
)
	
AS
BEGIN	
	--Delete from Core.CalculationRequests --where StatusID in( 267,292,326,736) and (PriorityID <>272 or PriorityID is null)
	truncate  table  Core.CalculationRequests

END
