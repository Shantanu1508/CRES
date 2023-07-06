

CREATE PROCEDURE [dbo].[usp_CreateNewBatchLogIDForVSTOAsyncCalc]
 @UserName nvarchar(256)
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
	BEGIN TRY 
		Declare @BatchLogID int;	
 
		INSERT INTO [CRE].[BatchLogAsyncCalcVSTO](BatchName,BatchStartTime,StartedBy,Status)
		VALUES ('VSTOAsyncCalc',GETDATE(),@UserName,'Process Running')

		SET @BatchLogID = @@IDENTITY

		Select @BatchLogID as BatchLogID

	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT,@ErrorProc NVARCHAR(4000)

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE(),@ErrorProc = ERROR_PROCEDURE();

		UPDATE [IO].[BatchLogAsyncCalcVSTO]
		SET Status =  'Process Incomplete',
			BatchEndTime = GETDATE(),
			ErrorMessage = @ErrorMessage + 'Occurred in ' + @ErrorProc
		WHERE [BatchLogAsyncCalcVSTOID] = @BatchLogID

		RAISERROR (@ErrorMessage, -- Message text.
			@ErrorSeverity, -- Severity.
			@ErrorState -- State.
			);

	END CATCH
	
	
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
