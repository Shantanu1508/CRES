CREATE TABLE [IO].[L_ManualTransactionVSTO] (
    [ManualTransactionVSTOID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]                  NVARCHAR (256)   NULL,
    [NoteName]                NVARCHAR (256)   NULL,
    [DueDate]                 DATETIME         NULL,
    [TransactionDate]         DATETIME         NULL,
    [RemitDate]               DATETIME         NULL,
    [Value]                   DECIMAL (28, 15) NULL,
    [TransactionTypeID]       INT              NULL,
    [ServicerMasterID]        INT              NULL,
    [Status]                  NVARCHAR (256)   NULL,
    [Comment]                 NVARCHAR (MAX)   NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    CONSTRAINT [PK_ManualTransactionVSTOID] PRIMARY KEY CLUSTERED ([ManualTransactionVSTOID] ASC)
);

