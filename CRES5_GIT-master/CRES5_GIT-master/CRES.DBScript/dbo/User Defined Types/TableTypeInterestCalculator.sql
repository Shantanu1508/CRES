CREATE TYPE [dbo].[TableTypeInterestCalculator] AS TABLE (
    [NoteID]           UNIQUEIDENTIFIER NULL,
    [AccrualStartDate] DATE             NULL,
    [AccrualEndDate]   DATE             NULL,
    [PaymentDate]      DATE             NULL,
    [BeginningBalance] DECIMAL (28, 15) NULL,
    [AnalysisID]       UNIQUEIDENTIFIER NULL);

