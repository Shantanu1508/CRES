
CREATE PROCEDURE [HBOT].[usp_InsertAIApiStartandEndTime] 
(
	@UserId Uniqueidentifier,
	@StartTime datetime,
	@EndTime datetime,
	@IntentName nvarchar(max)
)
AS
BEGIN
	INSERT INTO HBOT.APIAnalysisLog(StartTime,EndTime,IntentName,CreatedBy) VALUES(@StartTime,@EndTime,@IntentName,@UserId)

END

