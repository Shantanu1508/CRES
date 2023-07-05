CREATE TABLE [CRE].[DealTransaction] (
    [DealTransactionID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Deal_DealID]       UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    CONSTRAINT [PK_DealTransactionID] PRIMARY KEY CLUSTERED ([DealTransactionID] ASC),
    CONSTRAINT [FK_DealTransaction_Deal_DealID] FOREIGN KEY ([Deal_DealID]) REFERENCES [CRE].[Deal] ([DealID])
);

