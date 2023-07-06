


CREATE PROCEDURE  [DW].[usp_DeltaDeleteProcess] 
	@BatchLogId int
AS
BEGIN
	
	SET NOCOUNT ON;

	Print('usp_DeltaDeleteProcess - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	

	DECLARE @currentBatchStart datetime,@batchCount int

	SET @currentBatchStart = (SELECT BatchStartTime FROM [DW].BatchLog WHERE BatchLogID = @BatchLogId)
	

	Delete from dw.dealbi where dealid in (Select dealid from cre.deal where IsDeleted = 1)

	Delete from dw.Notebi where noteid in (
	Select noteid from cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid
	where acc.IsDeleted = 1)
	
	--Delete From DW.NotePeriodicCalcBI where AnalysisID is null
	--Delete From DW.TransactionEntryBI where AnalysisID is null

	--Delete From dw.NotePeriodicCalcByEntityBI where AnalysisID is null
	--Delete From dw.TransactionByEntityBI where AnalysisID is null


	UPDATE BatchLog
	SET Status = 'DELETING'
	WHERE BatchLogId = @BatchLogId

	



	--DELETE FROM [DW].L_DealBI
	--WHERE DealID not in (SELECT DealID FROM [DW].L_DealBI) and DealID not in (SELECT DealID from [DW].L_DealBI)


	--SET @batchCount = (SELECT count(*) FROM BatchLog 
	--						WHERE BatchName = 'Delta Refresh Process' 
	--							and BatchStartTime > CONVERT(DATE,GETDATE()) 
	--							and BatchLogId <> @BatchLogId)
	--If @batchCount = 0
	--BEGIN
		
	--END

	IF @@ERROR <> 0
	BEGIN
		UPDATE BatchLog
		SET BatchEndTime = GETDATE(),Status = 'FAILURE',ErrorMessage = @@ERROR
		WHERE BatchLogId = @BatchLogId
	END
	
END



