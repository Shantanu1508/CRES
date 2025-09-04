CREATE PROCEDURE [dbo].[usp_UpdateHistoryScheduleDataForModuleByNoteId] --'de6b0896-1a36-4bd1-ad73-783cabd595fe','FundingSchedule'
(
	@tblScheduleData [dbo].[tblScheduleData]  Readonly,
	@ModuleName nvarchar(256)
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF(@ModuleName = 'FundingSchedule')
	BEGIN

		Update [CORE].FundingSchedule set [CORE].FundingSchedule.[value]  = a.Value
		From(
			Select NoteID,EventID,ScheduleID,[Value]
			From @tblScheduleData
		)a
		where [CORE].FundingSchedule.EventId = a.EventID and [CORE].FundingSchedule.FundingScheduleID = a.ScheduleID

	END


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

