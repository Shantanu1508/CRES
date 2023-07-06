CREATE TABLE [CRE].[TransactionEntryCloseArchive] (
    [TransactionEntryCloseArchiveID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]                         UNIQUEIDENTIFIER NOT NULL,
    [Date]                           DATETIME         NULL,
    [Amount]                         DECIMAL (28, 15) NULL,
    [Type]                           NVARCHAR (MAX)   NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [TransactionEntryCloseAutoID]    INT              NULL,
    [AnalysisID]                     UNIQUEIDENTIFIER NULL,
    [FeeName]                        NVARCHAR (256)   NULL,
    [PeriodID]                       UNIQUEIDENTIFIER NULL,
    [PeriodCloseEnd]                 DATE             NULL,
    [TagMasterID]                    UNIQUEIDENTIFIER NULL,
    [StrCreatedBy]                   NVARCHAR (256)   NULL,
    [TransactionDateByRule]          DATE             NULL,
    [TransactionDateServicingLog]    DATE             NULL,
    [RemitDate]                      DATE             NULL,
    CONSTRAINT [PK_TransactionEntryCloseArchiveID] PRIMARY KEY CLUSTERED ([TransactionEntryCloseArchiveID] ASC)
);

