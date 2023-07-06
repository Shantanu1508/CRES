
--[dbo].[usp_ExportFutureFundingToBackshop] '2165','admin_dev'

CREATE PROCEDURE [dbo].[usp_ExportFutureFundingToBackshop] --'5290','admin_qa'
(
	@NoteId nvarchar(256),
	@userName nvarchar(256)
)
AS
BEGIN


BEGIN TRY
--BEGIN TRAN
--======================================================

	DECLARE @query nvarchar(256) = N'Select COUNT(noteid) from [acore].[vw_AcctNote] where Noteid = '''+@NoteId+''''
	DECLARE @NoteCount TABLE (Cnt int,ShardName nvarchar(max))
	INSERT INTO @NoteCount (Cnt,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', @stmt = @query


	IF ((Select cnt from @NoteCount) > 0) --Check if note exists in backshop database
	BEGIN
		BEGIN TRY
			--Invoke the backshop procedure "[acore].[sp_NoteFundingsDeleteByNoteId]" on Backshop to delete Funding Schedule data for the note
			exec sp_NoteFundingsDeleteByNoteId @NoteId
			exec spNoteProjectedPaymentDeleteByNoteId @NoteId
	

			--Invoke the procedure "dbo.spNoteFundingsSave" on Backshop to export the "Most Recent" funding schedule from out_FutureFunding table. Update the status="Exported" & ExportTimeStamp in out_FutureFunding.
			Declare @CRENoteID [nvarchar](MAX)
			Declare @FundingDate Date 
			Declare @FundingAmount decimal(28,12)
			Declare @Comments [nvarchar](MAX)
			Declare @FundingPurpose [nvarchar](MAX)
			Declare @AuditUserName [nvarchar](MAX)
			Declare @ExportTimeStamp DATETIME 
			Declare @Status [nvarchar](MAX)
			Declare @Applied bit
			Declare @WireConfirm bit
			Declare @DrawFundingId [nvarchar](MAX)
			Declare @WF_CurrentStatus [nvarchar](256)
			Declare @GeneratedByText [nvarchar](256)
			


			---==Cursor for FF================
			IF CURSOR_STATUS('global','CursorFF')>=-1
			BEGIN
				DEALLOCATE CursorFF
			END

			DECLARE CursorFF CURSOR 
			for
			(
				Select [CRENoteID]
				,[FundingDate]
				,[FundingAmount]
				,[Comments]
				,[FundingPurpose]
				,[AuditUserName]
				,[ExportTimeStamp]
				,[Status] 
				,[Applied]
				,[WireConfirm] 
				,DrawFundingId 
				,WF_CurrentStatus
				,GeneratedByText 
				from [IO].[out_FutureFunding] where [CRENoteID] = @NoteId and [AuditUserName] = @userName and ISNULL(IsProjectedPaydown,0) <> 1
			)


			OPEN CursorFF 

			FETCH NEXT FROM CursorFF
			INTO @CRENoteID,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@AuditUserName,@ExportTimeStamp,@Status,@Applied,@WireConfirm,@DrawFundingId,@WF_CurrentStatus,@GeneratedByText

			WHILE @@FETCH_STATUS = 0
			BEGIN
				--Call Backshop FF save procedure (@FundingID,@NoteId_F,@Applied,@FundingDate,@FundingAmount,@Comments,@FundingPurposeCD_F,@FundingDrawId,@FundingExpense,@ExpenseComments,@WireConfirm,@AuditUserName)

				exec spNoteFundingsSave -1,@CRENoteID,@Applied,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@DrawFundingId,NUll,NUll,@WireConfirm,@AuditUserName,@WF_CurrentStatus,Null,@GeneratedByText
			
			FETCH NEXT FROM CursorFF
			INTO @CRENoteID,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@AuditUserName,@ExportTimeStamp,@Status,@Applied,@WireConfirm,@DrawFundingId,@WF_CurrentStatus,@GeneratedByText
			END
			CLOSE CursorFF   
			DEALLOCATE CursorFF	

			UPDATE [IO].[out_FutureFunding] set [Status] = 'Exported' where [CRENoteID] = @NoteId and [AuditUserName] = @userName and ISNULL(IsProjectedPaydown,0) <> 1
			---================================


			---==Cursor for FF paydown================
			IF CURSOR_STATUS('global','CursorFF_Pydn')>=-1
			BEGIN
				DEALLOCATE CursorFF_Pydn
			END

			DECLARE CursorFF_Pydn CURSOR 
			for
			(
				Select [CRENoteID]
				,[FundingDate]
				,[FundingAmount]
				,[Comments]
				,[FundingPurpose]
				,[AuditUserName]
				,[ExportTimeStamp]
				,[Status] 
				,[Applied]
				,[WireConfirm] 
				,DrawFundingId 
				,WF_CurrentStatus 
				,GeneratedByText
				from [IO].[out_FutureFunding] where [CRENoteID] = @NoteId and [AuditUserName] = @userName and IsProjectedPaydown = 1
			)


			OPEN CursorFF_Pydn 

			FETCH NEXT FROM CursorFF_Pydn
			INTO @CRENoteID,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@AuditUserName,@ExportTimeStamp,@Status,@Applied,@WireConfirm,@DrawFundingId,@WF_CurrentStatus,@GeneratedByText

			WHILE @@FETCH_STATUS = 0
			BEGIN
				--Call Backshop FF paydown save procedure 

				exec spNoteProjectedPaymentSave -1,@CRENoteID,@FundingDate,@FundingAmount,@FundingPurpose,@Comments,0,0,@AuditUserName,@GeneratedByText
			
			FETCH NEXT FROM CursorFF_Pydn
			INTO @CRENoteID,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@AuditUserName,@ExportTimeStamp,@Status,@Applied,@WireConfirm,@DrawFundingId,@WF_CurrentStatus,@GeneratedByText
			END
			CLOSE CursorFF_Pydn   
			DEALLOCATE CursorFF_Pydn	

			UPDATE [IO].[out_FutureFunding] set [Status] = 'Exported' where [CRENoteID] = @NoteId and [AuditUserName] = @userName and IsProjectedPaydown = 1
			---================================


		END TRY
		BEGIN CATCH
			UPDATE [IO].[out_FutureFunding] set [Status] = 'ExportFailed' where [CRENoteID] = @NoteId and [AuditUserName] = @userName
		END CATCH


	END
	ELSE
	BEGIN
		UPDATE [IO].[out_FutureFunding] set [Status] = 'Not Exists in [acore].[vw_AcctNote]' where [CRENoteID] = @NoteId and [AuditUserName] = @userName
	END

--======================================================
--COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	Select @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();


	--IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  
	  ---usp_ExportFutureFundingToBackshop
	Declare @DealID UNIQUEIDENTIFIER
	SET @DealID = (Select top 1 dealid from cre.Note where CRENoteID = @NoteId)
	exec [dbo].[usp_InsertErrorLogFromDB] 'ExportFutureFunding-sql',@ErrorMessage,@DealID,'usp_ExportFutureFundingToBackshop',@userName

END CATCH



END



