CREATE TABLE [CRE].[TransactionEntryLiability] (
    [TransactionEntryLiabilityID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [TransactionEntryLiabilityAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [LiabilityAccountID]              UNIQUEIDENTIFIER NULL,
    [LiabilityNoteAccountID]          UNIQUEIDENTIFIER NULL,
    [LiabilityNoteID]                 NVARCHAR (256)   NULL,
    [Date]                            DATE             NULL,
    [Amount]                          DECIMAL (28, 15) NULL,
    [TransactionType]                 NVARCHAR (MAX)   NULL,
    [AnalysisID]                      UNIQUEIDENTIFIER NULL,
    [EndingBalance]                   DECIMAL (28, 15) NULL,
    [AssetAccountID]                  UNIQUEIDENTIFIER NULL,
    [AssetDate]                       DATE             NULL,
    [AssetAmount]                     DECIMAL (28, 15) NULL,
    [AssetTransactionType]            NVARCHAR (256)   NULL,
    [CreatedBy]                       NVARCHAR (256)   NULL,
    [CreatedDate]                     DATETIME         NULL,
    [UpdatedBy]                       NVARCHAR (256)   NULL,
    [UpdatedDate]                     DATETIME         NULL,
    [ParentAccountId]                 UNIQUEIDENTIFIER NULL,
    [Flag]                            NVARCHAR (256)   NULL,
    [CalcType]                        int null,
    [AllInCouponRate]                 DECIMAL (28, 15) NULL,
    [SpreadValue]                     DECIMAL(28,15) NULL,
	[OriginalIndex]                   DECIMAL(28,15) NULL,
    CONSTRAINT [PK_TransactionEntryLiabilityAutoID] PRIMARY KEY CLUSTERED ([TransactionEntryLiabilityAutoID] ASC),
    CONSTRAINT [FK_TransactionEntryLiability_LiabilityAccountID] FOREIGN KEY ([LiabilityAccountID]) REFERENCES [Core].[Account] ([AccountID])
);


GO
ALTER TABLE [CRE].[TransactionEntryLiability] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



GO
CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntryLiability_AnalysisID_AccountID]
    ON [CRE].[TransactionEntryLiability]([AnalysisID] ASC, [LiabilityAccountID] ASC, [Date] ASC)
    INCLUDE([Amount], [TransactionType]);


