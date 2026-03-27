CREATE TABLE [VAL].[PricingGridFeeAssumptions] (
    [PricingGridFeeAssumptionsID] INT              IDENTITY (1, 1) NOT NULL,
    [MarkedDateMasterID]          INT              NULL,
    [ValueType]                   NVARCHAR (256)   NULL,
    [Nonconstruction]             DECIMAL (28, 15) NULL,
    [Construction]                DECIMAL (28, 15) NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdateBy]                    NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    CONSTRAINT [PK_PricingGridFeeAssumptions_PricingGridFeeAssumptionsID] PRIMARY KEY CLUSTERED ([PricingGridFeeAssumptionsID] ASC),
    CONSTRAINT [FK_PricingGridFeeAssumptions_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);

