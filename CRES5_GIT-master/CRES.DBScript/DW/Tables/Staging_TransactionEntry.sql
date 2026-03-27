CREATE TABLE [DW].[Staging_TransactionEntry] (
    [TransactionEntryID] UNIQUEIDENTIFIER NOT NULL,
    [NoteID]             UNIQUEIDENTIFIER NULL,
    [CRENoteID]          NVARCHAR (256)   NULL,
    [Date]               DATETIME         NULL,
    [Amount]             DECIMAL (28, 15) NULL,
    [Type]               NVARCHAR (128)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [AnalysisID]         UNIQUEIDENTIFIER NULL,
    [FeeName]            NVARCHAR (256)   NULL,
    [StrCreatedBy]       NVARCHAR (256)   NULL,
    [GeneratedBy]        NVARCHAR (256)   NULL,

    [TransactionDateByRule]       DATE             NULL,
    [TransactionDateServicingLog] DATE             NULL,
    [RemitDate]                   DATE             NULL,
    [FeeTypeName]                 NVARCHAR (256)   NULL,
    [Comment]                     NVARCHAR (MAX)   NULL,
	[PaymentDateNotAdjustedforWorkingDay]                        DATETIME         NULL,
    IndexDeterminationDate  date,
    [AllInCouponRate]       DECIMAL(28, 15) NULL,
    IndexValue              DECIMAL(28, 15) NULL,
	SpreadValue             DECIMAL(28, 15) NULL,
	OriginalIndex           DECIMAL(28, 15) NULL,
    CONSTRAINT [PK_TransactionEntryIDStaging] PRIMARY KEY CLUSTERED ([TransactionEntryID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iStaging_TransactionEntry_NoteID_Date_Type]
    ON [DW].[Staging_TransactionEntry]([NoteID] ASC, [Date] ASC, [Type] ASC);


GO
CREATE NONCLUSTERED INDEX [nci_wi_Staging_TransactionEntry_22601ED3AD7FC92A6EE229EBD9073828]
    ON [DW].[Staging_TransactionEntry]([AnalysisID] ASC, [Type] ASC, [NoteID] ASC)
    INCLUDE([Amount]);

