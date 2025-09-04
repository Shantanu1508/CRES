--drop PROCEDURE usp_InsertTransactionEntryLiabilityForFee
--drop TYPE tblTypeTransactionEntryLiabilityForFee
CREATE TYPE [dbo].[tblTypeTransactionEntryLiabilityForFee] AS TABLE(
	[LiabilityAccountID]					UNIQUEIDENTIFIER NULL,
	[LiabilityTypeID]						UNIQUEIDENTIFIER NULL,
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
	[UserID]								NVARCHAR (256)   NULL,
	CalcType								INT NULL,
	[AllInCouponRate]                 DECIMAL (28, 15) NULL,
    [SpreadValue]                     DECIMAL(28,15) NULL,
	[OriginalIndex]                   DECIMAL(28,15) NULL,
	[FeeName]                             NVARCHAR (256)   NULL
);