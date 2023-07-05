
CREATE PROCEDURE [DBO].[usp_InsertSchedulerLog] 
(
	@UserID nvarchar(256),
	@SchedulerLogID int,
	@SchedulerConfigID int,
	@Message nvarchar(max),
	@StartTime datetime,
	@EndTime datetime,
	@GeneratedBy  nvarchar(256),
	@OutSchedulerLogID INT OUTPUT   
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @tSchedulerLog TABLE (tSchedulerLogID int)
	
	if (@SchedulerLogID is null or @SchedulerLogID=0)
	BEGIN
		 INSERT INTO [App].[SchedulerLog](
		 [SchedulerConfigID],
		 [Message],
		 [StartTime],
		 [EndTime],
		 [GeneratedBy],
		 [CreatedDate]
		 )
		 OUTPUT inserted.SchedulerLogID INTO @tSchedulerLog(tSchedulerLogID)
		 values
		 (
		  @SchedulerConfigID,
		  @Message,
		  @StartTime,
		  @EndTime,
		  @GeneratedBy,
		  getdate()
		 )
		 Select @SchedulerLogID = tSchedulerLogID FROM @tSchedulerLog;
	 END
	 ELSE
	 BEGIN
		UPDATE [App].[SchedulerLog] Set [EndTime] = @EndTime where SchedulerLogID=@SchedulerLogID
	 END
	 set @OutSchedulerLogID = @SchedulerLogID
END

