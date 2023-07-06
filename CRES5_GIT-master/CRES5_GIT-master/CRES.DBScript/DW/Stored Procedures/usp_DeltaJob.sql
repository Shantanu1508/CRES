CREATE PROCEDURE [DW].[usp_DeltaJob]
AS
BEGIN
	
	SET NOCOUNT ON;
	

	----=========Kill Process If running more than 2 hour's	IF ((Select top 1 Status2 from dw.batchlog where BatchName = 'Delta Refresh Process' order by batchlogid desc) = 'Process Running')  	BEGIN  		--Print('Process is Running.');  		Declare @BSDate Datetime		Declare @BLID Int		Select top 1 @BSDate = BatchStartTime ,@BLID = batchlogid		from dw.batchlog where BatchName = 'Delta Refresh Process' and Status2 = 'Process Running' order by batchlogid desc				IF(ABS(DateDiff(hour,getdate(),@BSDate)) >= 1)		BEGIN			--Print('Process is Running too long.');  			--Delete from dw.BatchDetail where batchlogid = @BLID			--Delete from dw.BatchLog where batchlogid = @BLID			Delete from dw.batchDetail where batchlogid in (Select batchlogID from dw.batchlog where BatchName = 'Delta Refresh Process' and Status2 = 'Process Running')
			Delete from dw.batchlog where BatchName = 'Delta Refresh Process' and Status2 = 'Process Running'		END	END
	----================================


	IF ((Select top 1 Status2 from dw.batchlog where BatchName = 'Delta Refresh Process' order by batchlogid desc) = 'Process Running')  
	BEGIN  
		Print('Process is already Running.');  
		return  
	END  


	DECLARE @id int,@batchCount int,@FirstTimeImport bit
	
	INSERT INTO [DW].BatchLog (BatchName,BatchStartTime,StartedBy,Status2)
	VALUES ('Delta Refresh Process',GETDATE(),USER_NAME(),'Process Running')

	SET @id = @@IDENTITY

	Print('usp_DeltaJob');


	IF NOT EXISTS (Select top 1 DealID from [DW].DealBI)
		SET @FirstTimeImport = 1


	BEGIN TRY

		IF(@FirstTimeImport = 1)
		BEGIN
			Print(char(9) +'FirstTimeImport');
			EXEC [DW].usp_ImportDeal @id,NULL,NULL
			EXEC [DW].usp_ImportNote @id,NULL,NULL
			EXEC [DW].usp_ImportTransaction @id,NULL,NULL
			EXEC [DW].usp_ImportDailyCalc @id,NULL,NULL

			EXEC [DW].usp_ImportTransactionEntry @id,NULL,NULL
			EXEC [DW].usp_ImportNotePeriodicCalc @id,NULL,NULL

			EXEC [DW].usp_ImportExceptionsBI @id,NULL,NULL
			
			EXEC [DW].[usp_MergeNoteFunding]  @id,NULL,NULL
			EXEC [DW].[usp_MergeBSNoteFunding]  @id,NULL,NULL

			EXEC [DW].[usp_MergeDealFundingSchdule] @id,NULL,NULL
			EXEC [DW].[usp_MergeNoteFundingSchedule] @id,NULL,NULL
			EXEC [DW].[usp_MergeFundingSequences] @id,NULL,NULL

			EXEC [DW].[usp_MergeBackshopCurrentBalance] @id,NULL,NULL

			EXEC [DW].[usp_MergeWorkFlow] @id,NULL,NULL


			----UPDATE [DW].BatchLog
			----SET Status = 'IMPORTING',LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].[DealBI])
			----WHERE BatchLogId = @id

			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].[DealBI]) WHERE BatchLogId = @id and LandingTableName = 'L_DealBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].[NoteBI]) WHERE BatchLogId = @id and LandingTableName = 'L_NoteBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].TransactionBI) WHERE BatchLogId = @id and LandingTableName = 'L_TransactionBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].DailyCalcBI) WHERE BatchLogId = @id and LandingTableName = 'L_DailyCalcBI'

			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].TransactionEntryBI) WHERE BatchLogId = @id and LandingTableName = 'L_TransactionEntryBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].NotePeriodicCalcBI) WHERE BatchLogId = @id and LandingTableName = 'L_NotePeriodicCalcBI'

			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].ExceptionsBI) WHERE BatchLogId = @id and LandingTableName = 'L_ExceptionsBI'

			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].NoteFundingBI) WHERE BatchLogId = @id and LandingTableName = 'L_NoteFundingBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(AuditAddDate) FROM [DW].BSNoteFundingBI) WHERE BatchLogId = @id and LandingTableName = 'L_BSNoteFundingBI'

			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].DealFundingSchduleBI) WHERE BatchLogId = @id and LandingTableName = 'L_DealFundingSchduleBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].NoteFundingScheduleBI) WHERE BatchLogId = @id and LandingTableName = 'L_NoteFundingScheduleBI'
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(CreatedDate) FROM [DW].FundingSequencesBI) WHERE BatchLogId = @id and LandingTableName = 'L_FundingSequencesBI'


			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(ImportDate) FROM [DW].BackshopCurrentBalanceBI) WHERE BatchLogId = @id and LandingTableName = 'L_BackshopCurrentBalanceBI'
			
			UPDATE [DW].BatchDetail SET LastCreatedDate = (SELECT MAX(UpdatedDate) FROM [DW].WorkFlowBI) WHERE BatchLogId = @id and LandingTableName = 'L_WorkFlowBI'

		END
		ELSE
		BEGIN
			/*Import*/
			EXEC [DW].usp_DeltaImportProcess @id
		END


		/*Delete*/
		EXEC [DW].usp_DeltaDeleteProcess @id

		/*Calculation before merge*/
		EXEC [DW].usp_Calculations_BeforeMerge @id

		/*Merge*/
		EXEC [DW].usp_DeltaMergeProcess @id

		/*Calculation after merge*/
		EXEC [DW].usp_Calculations_AfterMerge @id


		UPDATE [DW].BatchLog
		SET Status = 'SUCCESS',BatchEndTime = GETDATE(),Status2 = 'Process Complete'
		WHERE BatchLogId = @id		


		--Run after dw refresh process
		EXEC [DW].[usp_ImportServicingBalanceBI]

		 
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
