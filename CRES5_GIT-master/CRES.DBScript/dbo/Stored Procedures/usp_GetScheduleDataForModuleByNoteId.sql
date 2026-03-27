CREATE PROCEDURE [dbo].[usp_GetScheduleDataForModuleByNoteId] --'de6b0896-1a36-4bd1-ad73-783cabd595fe','FundingSchedule'
(
	@NoteId UNIQUEIDENTIFIER,
	@ModuleName nvarchar(256)
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF(@ModuleName = 'FundingSchedule')
	BEGIN

		Select 	distinct n.NoteID,eve.EventID,fs.FundingScheduleID,		
		eve.EffectiveStartDate,
		fs.Date,
		fs.Value
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID				
		where n.NoteID = @NoteId  and acc.IsDeleted = 0
		and eve.StatusID = 1
		and eve.EventTypeID = 10
		Order by  eve.effectivestartdate
		

	END


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

