CREATE TABLE [CRE].[TransactionEntry] (
    [TransactionEntryID]                  UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__Trans__075714DC] DEFAULT (newid()) NOT NULL,
    [Date]                                DATETIME         NULL,
    [Amount]                              DECIMAL (28, 15) NULL,
    [Type]                                NVARCHAR (MAX)   NULL,
    [CreatedBy]                           NVARCHAR (256)   NULL,
    [CreatedDate]                         DATETIME         NULL,
    [UpdatedBy]                           NVARCHAR (256)   NULL,
    [UpdatedDate]                         DATETIME         NULL,
    [TransactionEntryAutoID]              INT              IDENTITY (1, 1) NOT NULL,
    [AnalysisID]                          UNIQUEIDENTIFIER NULL,
    [FeeName]                             NVARCHAR (256)   NULL,
    [StrCreatedBy]                        NVARCHAR (256)   NULL,
    [GeneratedBy]                         NVARCHAR (256)   NULL,
    [TransactionDateByRule]               DATE             NULL,
    [TransactionDateServicingLog]         DATE             NULL,
    [RemitDate]                           DATE             NULL,
    [FeeTypeName]                         NVARCHAR (256)   NULL,
    [Comment]                             NVARCHAR (MAX)   NULL,
    [PaymentDateNotAdjustedforWorkingDay] DATETIME         NULL,
    [PurposeType]                         NVARCHAR (256)   NULL,
    [Cash_NonCash]                        NVARCHAR (256)   NULL,
    [IOTermEndDate]                       DATE             NULL,
    [LIBORPercentage]                     DECIMAL (28, 15) NULL,
    [SpreadPercentage]                    DECIMAL (28, 15) NULL,
    [PIKInterestPercentage]               DECIMAL (28, 15) NULL,
    [PIKLiborPercentage]                  DECIMAL (28, 15) NULL,
    [NonCommitmentAdj]                    NVARCHAR (10)    NULL,
    [AllInCouponRate]                     DECIMAL (28, 15) NULL,
    [accountingclosedate]                 DATE             NULL,
    [AdjustmentType]                      NVARCHAR (256)   NULL,
    [IndexDeterminationDate]              DATETIME         NULL,
    [AccountId]                           UNIQUEIDENTIFIER NULL,
    EndingBalance		DECIMAL (28, 15) NULL,
    DecodeName nvarchar(256) null,
    Flag nvarchar(256),
    [ParentAccountId]                           UNIQUEIDENTIFIER NULL,
    BalloonRepayAmount decimal(28,15),
    IndexValue  decimal(28,15),
	SpreadValue  decimal(28,15),
	OriginalIndex  decimal(28,15),
    CalcType       INT    null,

    DealAccountId UNIQUEIDENTIFIER
    CONSTRAINT [PK_TransactionEntryAutoID] PRIMARY KEY CLUSTERED ([TransactionEntryAutoID] ASC),
    CONSTRAINT [FK_TransactionEntry_Account_AccountID] FOREIGN KEY ([AccountId]) REFERENCES [Core].[Account] ([AccountID])
);





GO
ALTER TABLE [CRE].[TransactionEntry] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO
CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntry_67744DE156B187E67EAACCD78DF84D89]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [AccountID] ASC, [Date] ASC)
    INCLUDE([Amount], [FeeName], [Type]);


GO
CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntry_C1B11EC5A1F89BFB9B19FDFE7AA18E31]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [AccountID] ASC, [TransactionDateByRule] ASC)
    INCLUDE([Amount], [Date], [FeeName], [RemitDate], [TransactionDateServicingLog], [Type]);

