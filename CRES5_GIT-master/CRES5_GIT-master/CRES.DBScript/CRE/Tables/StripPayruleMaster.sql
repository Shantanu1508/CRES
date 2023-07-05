CREATE TABLE [CRE].[StripPayruleMaster] (
    [StripPayruleMasterID]            UNIQUEIDENTIFIER CONSTRAINT [DF__StripPayr__Strip__1940BAED] DEFAULT (newid()) NOT NULL,
    [Priority]                        INT              NULL,
    [RuleNameID]                      INT              NULL,
    [RequiresCalculationSequencingID] INT              NULL,
    [CreatedBy]                       NVARCHAR (256)   NULL,
    [CreatedDate]                     DATETIME         NULL,
    [UpdatedBy]                       NVARCHAR (256)   NULL,
    [UpdatedDate]                     DATETIME         NULL,
    CONSTRAINT [PK_StripPayruleMasterID] PRIMARY KEY CLUSTERED ([StripPayruleMasterID] ASC)
);

