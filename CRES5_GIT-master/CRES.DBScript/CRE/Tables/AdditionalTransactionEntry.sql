CREATE TABLE [CRE].[AdditionalTransactionEntry] (
    [AdditionalTransactionEntryGUID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[AdditionalTransactionEntryID]        INT            IDENTITY (1, 1) NOT NULL,
    [AccountId]                           UNIQUEIDENTIFIER NULL,
    [Date]                                DATETIME         NULL,
    [Amount]                              DECIMAL (28, 15) NULL,
    [Type]                                NVARCHAR (MAX)   NULL,
	[AnalysisID]                          UNIQUEIDENTIFIER NULL,
	[Comment]                             NVARCHAR (MAX)   NULL,
	EndingBalance						  DECIMAL (28, 15) NULL,
    [CreatedBy]                           NVARCHAR (256)   NULL,
    [CreatedDate]                         DATETIME         NULL,
    [UpdatedBy]                           NVARCHAR (256)   NULL,
    [UpdatedDate]                         DATETIME         NULL,
    [DealAccountId]                         UNIQUEIDENTIFIER NULL,
    [AssetAccountID]                        UNIQUEIDENTIFIER NULL,
    LiabilityTypeID                         UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_AdditionalTransactionEntryAutoID] PRIMARY KEY CLUSTERED (AdditionalTransactionEntryID ASC),
    CONSTRAINT [FK_AdditionalTransactionEntry_Account_AccountID] FOREIGN KEY ([AccountId]) REFERENCES [Core].[Account] ([AccountID])
);


