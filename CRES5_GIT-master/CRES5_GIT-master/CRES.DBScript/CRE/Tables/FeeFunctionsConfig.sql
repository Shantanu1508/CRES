CREATE TABLE [CRE].[FeeFunctionsConfig] (
    [FunctionNameID]     INT              IDENTITY (1, 1) NOT NULL,
    [FunctionGuID]       UNIQUEIDENTIFIER CONSTRAINT [DF__FeeFuncti__Funct__62E4AA3C] DEFAULT (newid()) NOT NULL,
    [FunctionNameText]   NVARCHAR (256)   NULL,
    [FunctionTypeID]     INT              NULL,
    [PaymentFrequencyID] INT              NULL,
    [AccrualBasisID]     INT              NULL,
    [AccrualStartDateID] INT              NULL,
    [AccrualPeriodID]    INT              NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    CONSTRAINT [PK_FunctionNameID] PRIMARY KEY CLUSTERED ([FunctionNameID] ASC)
);

