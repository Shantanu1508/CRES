CREATE TABLE [CRE].[TransactionEntry] (
    [TransactionEntryID]                  UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__Trans__075714DC] DEFAULT (newid()) NOT NULL,
    [NoteID]                              UNIQUEIDENTIFIER NOT NULL,
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
    CONSTRAINT [PK_TransactionEntryAutoID] PRIMARY KEY CLUSTERED ([TransactionEntryAutoID] ASC),
    CONSTRAINT [FK_TransactionEntry_Note_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);


GO
ALTER TABLE [CRE].[TransactionEntry] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO
CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntry_67744DE156B187E67EAACCD78DF84D89]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [NoteID] ASC, [Date] ASC)
    INCLUDE([Amount], [FeeName], [Type]);


GO
CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntry_C1B11EC5A1F89BFB9B19FDFE7AA18E31]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [NoteID] ASC, [TransactionDateByRule] ASC)
    INCLUDE([Amount], [Date], [FeeName], [RemitDate], [TransactionDateServicingLog], [Type]);

