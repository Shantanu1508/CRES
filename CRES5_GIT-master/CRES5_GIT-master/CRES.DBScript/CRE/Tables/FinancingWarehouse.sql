CREATE TABLE [CRE].[FinancingWarehouse] (
    [FinancingWarehouseID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Account_AccountID]    UNIQUEIDENTIFIER NOT NULL,
    [IsRevolving]          INT              NULL,
    [OriginationFee]       DECIMAL (28, 15) NULL,
    [TotalConstraint]      DECIMAL (28, 15) NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    CONSTRAINT [PK_FinancingWarehouseID] PRIMARY KEY CLUSTERED ([FinancingWarehouseID] ASC),
    CONSTRAINT [FK_FinancingWarehouse_Account_AccountID] FOREIGN KEY ([Account_AccountID]) REFERENCES [Core].[Account] ([AccountID])
);

