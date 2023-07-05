CREATE TABLE [DW].[FeeFunctionsDefinitionBI] (
    [FunctionName]     NVARCHAR (256) NULL,
    [FunctionType]     NVARCHAR (256) NULL,
    [PaymentFrequency] NVARCHAR (256) NULL,
    [AccrualBasis]     NVARCHAR (256) NULL,
    [AccrualStartDate] NVARCHAR (256) NULL,
    [AccrualPeriod]    NVARCHAR (256) NULL
);


GO
CREATE NONCLUSTERED INDEX [iFeeFunctionsDefinitionBI_FunctionName]
    ON [DW].[FeeFunctionsDefinitionBI]([FunctionName] ASC);

