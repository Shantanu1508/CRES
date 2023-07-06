CREATE TABLE [CRE].[NoteFinancing] (
    [NoteFinancingID]                         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [FinancingWarehouse_FinancingWarehouseID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]                               NVARCHAR (256)   NULL,
    [CreatedDate]                             DATETIME         NULL,
    [UpdatedBy]                               NVARCHAR (256)   NULL,
    [UpdatedDate]                             DATETIME         NULL,
    CONSTRAINT [PK_NoteFinancingID] PRIMARY KEY CLUSTERED ([NoteFinancingID] ASC),
    CONSTRAINT [FK_NoteFinancing_FinancingWarehouse_FinancingWarehouseID] FOREIGN KEY ([FinancingWarehouse_FinancingWarehouseID]) REFERENCES [CRE].[FinancingWarehouse] ([FinancingWarehouseID])
);

