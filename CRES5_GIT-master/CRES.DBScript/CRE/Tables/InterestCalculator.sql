CREATE TABLE [CRE].[InterestCalculator] (
    [InterestCalculatorID]     UNIQUEIDENTIFIER CONSTRAINT [DF__InterestC__Inter__24B26D99] DEFAULT (newid()) NOT NULL,
    [InterestCalculatorAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]                   UNIQUEIDENTIFIER NOT NULL,
    [AccrualStartDate]         DATE             NULL,
    [AccrualEndDate]           DATE             NULL,
    [PaymentDate]              DATE             NULL,
    [BeginningBalance]         DECIMAL (28, 15) NULL,
    [AnalysisID]               UNIQUEIDENTIFIER NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_InterestCalculatorAutoID] PRIMARY KEY CLUSTERED ([InterestCalculatorAutoID] ASC)
);

