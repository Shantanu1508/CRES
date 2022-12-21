CREATE TABLE [IO].[IN_ServicingTransaction] (
    [IN_ServicingTransactionID] UNIQUEIDENTIFIER CONSTRAINT [DF__IN_Servic__IN_Se__047AA831] DEFAULT (newid()) NOT NULL,
    [NoteID]                    NVARCHAR (256)   NULL,
    [TransactionType]           NVARCHAR (256)   NULL,
    [TransactionDate]           DATE             NULL,
    [DateDue]                   DATE             NULL,
    [PrincipalPayment]          DECIMAL (28, 15) NULL,
    [InterestPayment]           DECIMAL (28, 15) NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    CONSTRAINT [PK_IN_ServicingTransactionID] PRIMARY KEY CLUSTERED ([IN_ServicingTransactionID] ASC)
);

