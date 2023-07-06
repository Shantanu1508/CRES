
CREATE Procedure [dbo].[usp_DeleteTagMasterTransactionEntryClose]
@UserID NVarchar(255),
@PeriodIDs NVarchar(max),
@AnalysisID uniqueidentifier

AS

BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
	BEGIN TRAN

		--Hard delete auto-generated tag
		Delete from cre.TagMaster where TagMasterID in (Select Distinct TagMasterID FROM [CRE].[TransactionEntryClose] WHERE PeriodID is not null and PeriodID in (select value from dbo.fn_Split(@PeriodIDs)))
		DELETE FROM [CRE].[TransactionEntryClose] WHERE PeriodID is not null and PeriodID in (select value from dbo.fn_Split(@PeriodIDs))

	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
	
END
