
CREATE PROCEDURE [DW].[usp_ImportTransaction]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_TransactionBI',GETDATE())

	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


IF EXISTS(Select TransactionID from [dw].[TransactionBI])
BEGIN

Truncate table [DW].[L_TransactionBI]

INSERT INTO [DW].[L_TransactionBI]
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
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
Select
tr.[TransactionID],
tr.[PeriodID],
tr.[RegisterID],
tr.[TransactionTypeID],
tr.[Date],
tr.[Amount],
tr.[IsActual],
tr.[CurrencyID],
rg.[AccountID],
rg.[AnalysisID],
rg.[Name],
rg.[StatusID],
lTransactionType.Name as  [TransactionTypeBI],
lCurrency.Name as  [CurrencyBI],
lStatus.Name as  [StatusBI],
tr.[CreatedBy],
tr.[CreatedDate],
tr.[UpdatedBy],
tr.[UpdatedDate]
FROM CORE.[Transaction] tr
INNER JOIN CORE.Register rg ON tr.RegisterID = rg.RegisterID
LEFT Join Core.Lookup lTransactionType on tr.TransactionTypeID=lTransactionType.LookupID
LEFT Join Core.Lookup lCurrency on tr.CurrencyID=lCurrency.LookupID
LEFT Join Core.Lookup lStatus on rg.StatusID=lStatus.LookupID
	WHERE (tr.CreatedDate > @LastBatchStart 
	and tr.CreatedDate < @CurrentBatchStart) 
	OR 
	(tr.UpdatedDate > @LastBatchStart 
	and tr.UpdatedDate < @CurrentBatchStart)


SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportTransaction - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END
ELSE
BEGIN


Truncate table [DW].[L_TransactionBI]

INSERT INTO [DW].[L_TransactionBI]
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
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
Select
tr.[TransactionID],
tr.[PeriodID],
tr.[RegisterID],
tr.[TransactionTypeID],
tr.[Date],
tr.[Amount],
tr.[IsActual],
tr.[CurrencyID],
rg.[AccountID],
rg.[AnalysisID],
rg.[Name],
rg.[StatusID],
lTransactionType.Name as  [TransactionTypeBI],
lCurrency.Name as  [CurrencyBI],
lStatus.Name as  [StatusBI],
tr.[CreatedBy],
tr.[CreatedDate],
tr.[UpdatedBy],
tr.[UpdatedDate]
FROM CORE.[Transaction] tr
INNER JOIN CORE.Register rg ON tr.RegisterID = rg.RegisterID
LEFT Join Core.Lookup lTransactionType on tr.TransactionTypeID=lTransactionType.LookupID
LEFT Join Core.Lookup lCurrency on tr.CurrencyID=lCurrency.LookupID
LEFT Join Core.Lookup lStatus on rg.StatusID=lStatus.LookupID


SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportTransaction - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END




UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END


