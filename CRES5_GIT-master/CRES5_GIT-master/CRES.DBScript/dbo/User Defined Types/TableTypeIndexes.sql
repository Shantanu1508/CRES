CREATE TYPE [dbo].[TableTypeIndexes] AS TABLE (
    [Date]       DATE             NULL,
    [Name]       NVARCHAR (MAX)   NULL,
    [Value]      DECIMAL (28, 15) NULL,
    [AnalysisID] UNIQUEIDENTIFIER NULL);

