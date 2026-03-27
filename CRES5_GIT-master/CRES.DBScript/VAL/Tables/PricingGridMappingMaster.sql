CREATE TABLE [VAL].[PricingGridMappingMaster] (
    [PricingGridMappingMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [MarkedDateMasterID]         INT            NULL,
    [DealTypeName]               NVARCHAR (256) NULL,
    [DealTypeMapping]            NVARCHAR (256) NULL,
    [CreatedBy]                  NVARCHAR (256) NULL,
    [CreatedDate]                DATETIME       NULL,
    [UpdateBy]                   NVARCHAR (256) NULL,
    [UpdatedDate]                DATETIME       NULL,
    CONSTRAINT [PK_PricingGridMappingMaster_PricingGridMappingMasterID] PRIMARY KEY CLUSTERED ([PricingGridMappingMasterID] ASC),
    CONSTRAINT [FK_PricingGridMappingMaster_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);

