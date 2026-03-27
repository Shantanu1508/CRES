--drop PROCEDURE usp_InsertTransactionEntryLiability
--drop TYPE tblTypeTransactionEntryLiability
CREATE TYPE [dbo].[tblTypeTransactionEntryLiability] AS TABLE(
	[LiabilityAccountID]					UNIQUEIDENTIFIER NULL,
	[LiabilityNoteAccountID]				UNIQUEIDENTIFIER NULL,
	[LiabilityNoteID]									NVARCHAR (256)   NULL,
	[Date]									DATE         NULL,
	[Amount]								DECIMAL (28, 15) NULL,
	[TransactionType]									NVARCHAR (MAX)   NULL,
	[AnalysisID]							UNIQUEIDENTIFIER NULL,
	EndingBalance							DECIMAL (28, 15) NULL,
	AssetAccountID							UNIQUEIDENTIFIER NULL,
	AssetDate								DATE         NULL,
	AssetAmount								DECIMAL (28, 15) NULL,
	AssetTransactionType					NVARCHAR (256)   NULL,
	[UserID]								NVARCHAR (256)   NULL
);