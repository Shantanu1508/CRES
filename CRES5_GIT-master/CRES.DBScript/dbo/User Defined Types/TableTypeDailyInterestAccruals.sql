CREATE TYPE [dbo].[TableTypeDailyInterestAccruals] AS TABLE (
    [NoteID]               UNIQUEIDENTIFIER NULL,
    [Date]                 DATE             NULL,
    [DailyInterestAccrual] DECIMAL (28, 15) NULL,
    [EndingBalance]        DECIMAL (28, 15) NULL,
    [AnalysisID]           UNIQUEIDENTIFIER NULL);

