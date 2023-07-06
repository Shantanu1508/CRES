

CREATE PROCEDURE [DW].[usp_MergeTransaction]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'TransactionBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TransactionBI'


MERGE [DW].TransactionBI TB
USING [DW].L_TransactionBI LTB
ON TB.TransactionID = LTB.TransactionID
WHEN MATCHED THEN
UPDATE 
SET 
TB.[TransactionID] = LTB.[TransactionID],
TB.[PeriodID] = LTB.[PeriodID],
TB.[RegisterID] = LTB.[RegisterID],
TB.[TransactionTypeID] = LTB.[TransactionTypeID],
TB.[Date] = LTB.[Date],
TB.[Amount] = LTB.[Amount],
TB.[IsActual] = LTB.[IsActual],
TB.[CurrencyID] = LTB.[CurrencyID],
TB.[AccountID] = LTB.[AccountID],
TB.[AnalysisID] = LTB.[AnalysisID],
TB.[Name] = LTB.[Name],
TB.[StatusID] = LTB.[StatusID],
TB.[TransactionTypeBI] = LTB.[TransactionTypeBI],
TB.[CurrencyBI] = LTB.[CurrencyBI],
TB.[StatusBI] = LTB.[StatusBI],
TB.[ImportBIDate] = GETDATE(),
TB.[CreatedBy] = LTB.[CreatedBy],
TB.[CreatedDate] = LTB.[CreatedDate],
TB.[UpdatedBy] = LTB.[UpdatedBy],
TB.[UpdatedDate] = LTB.[UpdatedDate]
WHEN NOT MATCHED THEN
	
	INSERT 
	([TransactionID]
           ,[PeriodID]
           ,[RegisterID]
           ,[TransactionTypeID]
           ,[Date]
           ,[Amount]
           ,[IsActual]
           ,[CurrencyID]
           ,[AccountID]
           ,[AnalysisID]
           ,[Name]
           ,[StatusID]
           ,[TransactionTypeBI]
           ,[CurrencyBI]
           ,[StatusBI]
		   ,[ImportBIDate]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	VALUES (
	LTB.[TransactionID],
	LTB.[PeriodID],
	LTB.[RegisterID],
	LTB.[TransactionTypeID],
	LTB.[Date],
	LTB.[Amount],
	LTB.[IsActual],
	LTB.[CurrencyID],
	LTB.[AccountID],
	LTB.[AnalysisID],
	LTB.[Name],
	LTB.[StatusID],
	LTB.[TransactionTypeBI],
	LTB.[CurrencyBI],
	LTB.[StatusBI],
	GETDATE(),
	LTB.[CreatedBy],
	LTB.[CreatedDate],
	LTB.[UpdatedBy],
	LTB.[UpdatedDate]
);


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TransactionBI'

Print(char(9) +'usp_MergeTransaction - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

