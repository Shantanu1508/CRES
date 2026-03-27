CREATE TABLE [VAL].[PricingGrid] (
    [PricingGridID]      INT              IDENTITY (1, 1) NOT NULL,
    [MarkedDateMasterID] INT              NULL,
    [PropertyType]       NVARCHAR (256)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdateBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [DealType]           NVARCHAR (256)   NULL,
    [AnoteLTV]           DECIMAL (28, 15) NULL,
    [AnoteSpread]        DECIMAL (28, 15) NULL,
    [ABwholeLoanLTV]     DECIMAL (28, 15) NULL,
    [ABwholeLoanSpread]  DECIMAL (28, 15) NULL,
    [EquityLTV]          DECIMAL (28, 15) NULL,
    [EquityYield]        DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_PricingGrid_PricingGridID] PRIMARY KEY CLUSTERED ([PricingGridID] ASC),
    CONSTRAINT [FK_PricingGrid_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);
GO

