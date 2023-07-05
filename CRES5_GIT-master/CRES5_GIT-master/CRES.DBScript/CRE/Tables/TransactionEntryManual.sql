CREATE TABLE [CRE].[TransactionEntryManual] (
    [TransactionEntryID]          INT              IDENTITY (1, 1) NOT NULL,
    [TransactionEntryGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__Trans__70747ADB] DEFAULT (newid()) NOT NULL,
    [NoteID]                      UNIQUEIDENTIFIER NOT NULL,
    [Date]                        DATETIME         NULL,
    [Amount]                      DECIMAL (28, 15) NULL,
    [Type]                        NVARCHAR (MAX)   NULL,
    [StrCreatedBy]                NVARCHAR (256)   NULL,
    [GeneratedBy]                 NVARCHAR (256)   NULL,
    [TransactionDateByRule]       DATE             NULL,
    [TransactionDateServicingLog] DATE             NULL,
    [RemitDate]                   DATE             NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [Cash_NonCash] NVARCHAR(256) NULL, 
    CONSTRAINT [PK_TransactionEntryManual_TransactionEntryID] PRIMARY KEY CLUSTERED ([TransactionEntryID] ASC),
    CONSTRAINT [FK_TransactionEntryManual_Note_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

