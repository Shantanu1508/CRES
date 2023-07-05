CREATE TABLE [CRE].[FinancingDefaultConfig] (
    [FinancingDefaultConfigID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_FinancingDefaultConfigID] PRIMARY KEY CLUSTERED ([FinancingDefaultConfigID] ASC)
);

