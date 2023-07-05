CREATE TABLE [Core].[CalculatorOutputJsonInfo] (
    [CalculatorOutputJsonInfoID] UNIQUEIDENTIFIER CONSTRAINT [DF__Calculato__Calcu__2C538F61] DEFAULT (newid()) NOT NULL,
    [CalculationRequestID]       UNIQUEIDENTIFIER NOT NULL,
    [NoteId]                     UNIQUEIDENTIFIER NOT NULL,
    [AnalysisID]                 UNIQUEIDENTIFIER NULL,
    [FileName]                   NVARCHAR (256)   NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    FileType                     NVARCHAR (20)   NULL,
    [RequestID] NVARCHAR(256) NULL, 
    CONSTRAINT [PK_CoreCalculatorOutputJsonInfo] PRIMARY KEY CLUSTERED ([CalculatorOutputJsonInfoID] ASC)
);

