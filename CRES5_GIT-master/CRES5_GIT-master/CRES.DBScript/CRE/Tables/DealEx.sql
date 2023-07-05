CREATE TABLE [CRE].[DealEx] (
    [DealExID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Deal_DealID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_DealExID] PRIMARY KEY CLUSTERED ([DealExID] ASC),
    CONSTRAINT [FK_DealEx_Deal_DealID] FOREIGN KEY ([Deal_DealID]) REFERENCES [CRE].[Deal] ([DealID])
);

