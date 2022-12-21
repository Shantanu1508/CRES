-- Procedure
CREATE PROCEDURE [DW].[usp_DeltaJobBS]
 @isButtonClick int
AS
BEGIN
	
	SET NOCOUNT ON;

	----=========Kill Process If running more than 2 hour's	IF ((Select top 1 Status2 from dw.batchlog where BatchName = 'Refresh From Backshop' order by batchlogid desc) = 'Process Running')  	BEGIN  		--Print('Process is Running.');  		Declare @BSDate Datetime		Declare @BLID Int		Select top 1 @BSDate = BatchStartTime ,@BLID = batchlogid		from dw.batchlog where BatchName = 'Refresh From Backshop' and Status2 = 'Process Running' order by batchlogid desc				IF(ABS(DateDiff(hour,getdate(),@BSDate)) >= 1)		BEGIN			--Print('Process is Running too long.');  			--Delete from dw.BatchDetail where batchlogid = @BLID			--Delete from dw.BatchLog where batchlogid = @BLID			Delete from dw.batchDetail where batchlogid in (Select batchlogID from dw.batchlog where BatchName = 'Refresh From Backshop' and Status2 = 'Process Running')
			Delete from dw.batchlog where BatchName = 'Refresh From Backshop' and Status2 = 'Process Running'		END	END
	----================================

	
	IF ((Select top 1 Status2 from dw.batchlog where BatchName = 'Refresh From Backshop' order by batchlogid desc) = 'Process Running')  
	BEGIN  
		Print('Process is already Running.');  
		return  
	END 



	DECLARE @id int,@batchCount int,@FirstTimeImport bit
	
	INSERT INTO [DW].BatchLog (BatchName,BatchStartTime,StartedBy,Status2)
	VALUES ('Refresh From Backshop',GETDATE(),USER_NAME(),'Process Running')

	SET @id = @@IDENTITY

	IF(@isButtonClick = 1)
	BEGIN
		Update [DW].BatchLog set [LogType] = 'ClickedFromButton' where BatchLogID = @id
	END


	Print('usp_DeltaJobBS');


	EXEC [DW].[usp_UpdateNoteMatrixFields]




	IF NOT EXISTS (Select ControlID from [DW].UwDealBI)
		SET @FirstTimeImport = 1


	BEGIN TRY

		IF(@FirstTimeImport = 1)
		BEGIN
			Print(char(9) +'FirstTimeImport');
			Declare @CurrentBatchStart DateTime = (SELECT BatchStartTime FROM [DW].BatchLog WHERE BatchLogId = @id)


			EXEC [DW].usp_ImportUwDeal @id,NULL,@CurrentBatchStart
			EXEC [DW].usp_ImportUwNote @id,NULL,@CurrentBatchStart
			EXEC [DW].usp_ImportUwNoteFunding @id,NULL,@CurrentBatchStart
			EXEC [DW].usp_ImportUwNoteCommitmentAdjustment @id,NULL,@CurrentBatchStart
			EXEC [DW].usp_ImportUwCashflow @id,NULL,@CurrentBatchStart
			EXEC [DW].usp_ImportUwProperty @id,NULL,@CurrentBatchStart
			
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].[UwDealBI]) WHERE BatchLogId = @id and LandingTableName = 'L_UwDealBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].[UwNoteBI]) WHERE BatchLogId = @id and LandingTableName = 'L_UwNoteBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].[UwNoteFundingBI]) WHERE BatchLogId = @id and LandingTableName = 'L_UwNoteFundingBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].[UwNoteCommitmentAdjustmentBI]) WHERE BatchLogId = @id and LandingTableName = 'L_UwNoteCommitmentAdjustmentBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(PeriodEndDate) FROM [DW].[UwCashflowBI]) WHERE BatchLogId = @id and LandingTableName = 'L_UwCashflowBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].[UwPropertyBI]) WHERE BatchLogId = @id and LandingTableName = 'L_UwPropertyBI'
			

		END
		ELSE
		BEGIN
			/*Import*/
			EXEC [DW].usp_DeltaImportProcessBS @id
		END


		/*Delete*/
		EXEC [DW].usp_DeltaDeleteProcessBS @id

		/*Calculation before merge*/
		EXEC [DW].usp_Calculations_BeforeMergeBS @id

		/*Merge*/
		EXEC [DW].usp_DeltaMergeProcessBS @id

		/*Calculation after merge*/
		EXEC [DW].usp_Calculations_AfterMergeBS @id


		UPDATE [DW].BatchLog
		SET Status = 'SUCCESS',BatchEndTime = GETDATE(),Status2 = 'Process Complete'
		WHERE BatchLogId = @id		


		--Update records for wells newly added column
		EXEC [DW].[usp_UpdateDealNotePropertyNewColumnForWells]
		 
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
