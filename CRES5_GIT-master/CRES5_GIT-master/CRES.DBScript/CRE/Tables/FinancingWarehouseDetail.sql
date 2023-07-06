CREATE TABLE [CRE].[FinancingWarehouseDetail] (
    [FinancingWarehouseDetailID]              UNIQUEIDENTIFIER CONSTRAINT [DF__Financing__Finan__3B40CD36] DEFAULT (newid()) NOT NULL,
    [FinancingWarehouse_FinancingWarehouseID] UNIQUEIDENTIFIER NOT NULL,
    [StartDate]                               DATE             NULL,
    [EndDate]                                 DATE             NULL,
    [Value]                                   DECIMAL (28, 15) NULL,
    [CreatedBy]                               NVARCHAR (256)   NULL,
    [CreatedDate]                             DATETIME         NULL,
    [UpdatedBy]                               NVARCHAR (256)   NULL,
    [UpdatedDate]                             DATETIME         NULL,
    CONSTRAINT [PK_FinancingWarehouseDetailID] PRIMARY KEY CLUSTERED ([FinancingWarehouseDetailID] ASC),
    CONSTRAINT [FK_FinancingWarehouseDetail_FinancingWarehouse_FinancingWarehouseID] FOREIGN KEY ([FinancingWarehouse_FinancingWarehouseID]) REFERENCES [CRE].[FinancingWarehouse] ([FinancingWarehouseID])
);

