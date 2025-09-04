CREATE TABLE [DW].[FeeFunctionsDefinitionBI] (
    [FunctionName]                    NVARCHAR (256) NULL,
    [FunctionType]                    NVARCHAR (256) NULL,
    [PaymentFrequency]                NVARCHAR (256) NULL,
    [AccrualBasis]                    NVARCHAR (256) NULL,
    [AccrualStartDate]                NVARCHAR (256) NULL,
    [AccrualPeriod]                   NVARCHAR (256) NULL,
    [FeeFunctionsDefinitionBI_AutoID] INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FeeFunctionsDefinitionBI_AutoID] PRIMARY KEY CLUSTERED ([FeeFunctionsDefinitionBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iFeeFunctionsDefinitionBI_FunctionName]
    ON [DW].[FeeFunctionsDefinitionBI]([FunctionName] ASC);

