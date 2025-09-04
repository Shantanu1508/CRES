
CREATE PROCEDURE [DW].[usp_DeltaJobEntity]
AS
BEGIN
	
	SET NOCOUNT ON;

	----=========Kill Process If running more than 2 hour's
	IF ((Select top 1 Status2 from dw.batchlog where BatchName = 'Refresh Entity Data' order by batchlogid desc) = 'Process Running')  
	BEGIN  
		--Print('Process is Running.');  
		Declare @BSDate Datetime
		Declare @BLID Int
		Select top 1 @BSDate = BatchStartTime ,@BLID = batchlogid
		from dw.batchlog where BatchName = 'Refresh Entity Data' and Status2 = 'Process Running' order by batchlogid desc	
	
		IF(ABS(DateDiff(hour,getdate(),@BSDate)) >= 1)
		BEGIN
			--Print('Process is Running too long.');  
			--Delete from dw.BatchDetail where batchlogid = @BLID
			--Delete from dw.BatchLog where batchlogid = @BLID
			Delete from dw.batchDetail where batchlogid in (Select batchlogID from dw.batchlog where BatchName = 'Refresh Entity Data' and Status2 = 'Process Running')
			Delete from dw.batchlog where BatchName = 'Refresh Entity Data' and Status2 = 'Process Running'
		END

	END
	----================================
		
	IF ((Select top 1 Status2 from dw.batchlog where BatchName = 'Refresh Entity Data' order by batchlogid desc) = 'Process Running')  
	BEGIN  
		Print('Process is already Running.');  
		return  
	END 
	----================================


	DECLARE @id int,@batchCount int,@FirstTimeImport bit
	
	INSERT INTO [DW].BatchLog (BatchName,BatchStartTime,StartedBy,Status2)
	VALUES ('Refresh Entity Data',GETDATE(),USER_NAME(),'Process Running')

	SET @id = @@IDENTITY


	BEGIN TRY
		DECLARE @BatchDetail_id int,@RowCount int
		

		----Exec [DW].[usp_ImportNotePeriodicCalcByEntity]	 
	
		------===========================================
		----INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime,LandingEndTime,LandingRecordCount,BITableName,BIStartTime) 
		----VALUES (@id,'L_TransactionByEntityBI',GETDATE(),GETDATE(),0,'TransactionByEntityBI',GETDATE())		

		----	Exec [DW].[usp_ImportTransactionByEntity] 
		
		----SET @RowCount = @@ROWCOUNT
		
		----UPDATE [DW].BatchDetail	SET	BIEndTime = GETDATE(),BIRecordCount = @RowCount	WHERE BatchLogId = @id and LandingTableName = 'L_TransactionByEntityBI'
		------===========================================
		

		--===========================================
		INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime,LandingEndTime,LandingRecordCount,BITableName,BIStartTime) 
		VALUES (@id,'L_NotePeriodicCalcByEntityBI_All',GETDATE(),GETDATE(),0,'NotePeriodicCalcByEntityBI_All',GETDATE())		

			Exec [DW].[usp_ImportNotePeriodicCalcByEntity_All]
		
		SET @RowCount = @@ROWCOUNT
		
		UPDATE [DW].BatchDetail	SET	BIEndTime = GETDATE(),BIRecordCount = @RowCount	WHERE BatchLogId = @id and LandingTableName = 'L_NotePeriodicCalcByEntityBI_All'
		--===========================================
		




		UPDATE [DW].BatchLog
		SET Status = 'SUCCESS',BatchEndTime = GETDATE(),Status2 = 'Process Complete'
		WHERE BatchLogId = @id		
		
		 
	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT,@ErrorProc NVARCHAR(4000)

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE(),@ErrorProc = ERROR_PROCEDURE();

		UPDATE [DW].BatchLog
		SET Status = 'FAILURE',
			Status2 = 'Process Incomplete',
			BatchEndTime = GETDATE(),
			ErrorMessage = @ErrorMessage + 'Occurred in ' + @ErrorProc
		WHERE BatchLogId = @id

		RAISERROR (@ErrorMessage, -- Message text.
           @ErrorSeverity, -- Severity.
           @ErrorState -- State.
           );

	END CATCH
		
END
