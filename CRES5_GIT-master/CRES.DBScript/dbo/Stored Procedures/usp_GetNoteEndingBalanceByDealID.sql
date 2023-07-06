
--[dbo].[usp_GetNoteEndingBalanceByDealID]  'b0e6697b-3534-4c09-be0a-04473401ab93',  '1fd23dfd-9739-48e5-8c4d-20a6015a77ae','2017-12-30'


 CREATE PROCEDURE [dbo].[usp_GetNoteEndingBalanceByDealID]  
(
    @UserID UNIQUEIDENTIFIER,
    @DealID UNIQUEIDENTIFIER,
	@AmortStartDate Date,
	@AmortEndDate Date = null
)	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    --select EndingBalance, NoteID  from  CRE.DailyInterestAccruals WHERE [Date] = '2017-12-30 00:00:00.000' and  NoteID IN (SELECT NoteID FROM CRE.Note WHERE DEALID = '1fd23dfd-9739-48e5-8c4d-20a6015a77ae');
	IF(@AmortEndDate IS NOT NULL)
	BEGIN
		select EndingBalance, NoteID, Date from  CRE.DailyInterestAccruals WHERE NoteID IN (SELECT NoteID FROM CRE.Note WHERE DEALID = @DealID) 
		And AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Date] BETWEEN @AmortStartDate and @AmortEndDate
	END
	ELSE
	BEGIN
		select EndingBalance, NoteID, Date from  CRE.DailyInterestAccruals WHERE [Date] = @AmortStartDate and  NoteID IN (SELECT NoteID FROM CRE.Note WHERE DEALID = @DealID)
		And AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	END

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END





