CREATE TABLE [DW].[TransactionEntryBI] (
    [TransactionEntryID]                  UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                              UNIQUEIDENTIFIER NULL,
    [CRENoteID]                           NVARCHAR (256)   NULL,
    [Date]                                DATETIME         NULL,
    [Amount]                              DECIMAL (28, 15) NULL,
    [Type]                                NVARCHAR (128)   NULL,
    [CreatedBy]                           NVARCHAR (256)   NULL,
    [CreatedDate]                         DATETIME         NULL,
    [UpdatedBy]                           NVARCHAR (256)   NULL,
    [UpdatedDate]                         DATETIME         NULL,
    [TransactionEntryAutoID]              INT              NOT NULL,
    [AnalysisID]                          UNIQUEIDENTIFIER NULL,
    [AnalysisName]                        NVARCHAR (256)   NULL,
    [FeeName]                             NVARCHAR (256)   NULL,
    [DealName]                            NVARCHAR (256)   NULL,
    [CreDealID]                           NVARCHAR (256)   NULL,
    [TransactionDateByRule]               DATE             NULL,
    [TransactionDateServicingLog]         DATE             NULL,
    [RemitDate]                           DATE             NULL,
    [PaymentDateNotAdjustedforWorkingDay] DATETIME         NULL,
    [PurposeType]                         NVARCHAR (256)   NULL,
    [Cash_NonCash]                        NVARCHAR (256)   NULL,
    [AccountID]                           UNIQUEIDENTIFIER NULL,
    [AccountTypeID]                       INT              NULL,
    [AccountTypeBI]                       NVARCHAR (256)   NULL,
    AllInCouponRate                       DECIMAL (28, 15) NULL,
    [accountingclosedate]                 DATE             NULL,
    [AdjustmentType]                      NVARCHAR (256)   NULL,
    [IndexDeterminationDate]              DATETIME         NULL,
    EndingBalance		                  DECIMAL (28, 15) NULL,
    DecodeName                            nvarchar(256) null,
    Flag                                  nvarchar(256),
    [ParentAccountId]                     UNIQUEIDENTIFIER NULL,
    BalloonRepayAmount                    decimal(28,15),
    IndexValue                            decimal(28,15),
    SpreadValue                           decimal(28,15),
    OriginalIndex                         decimal(28,15)
    CONSTRAINT [PK_TransactionEntryAutoID] PRIMARY KEY CLUSTERED ([TransactionEntryAutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntryBI_811609E1DD7F671F3CECA5028F0FB4D4]
    ON [DW].[TransactionEntryBI]([AnalysisID] ASC, [NoteID] ASC, [CRENoteID] ASC, [Date] ASC, [Type] ASC);

