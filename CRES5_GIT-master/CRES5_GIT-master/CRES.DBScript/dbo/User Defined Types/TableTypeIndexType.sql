CREATE TYPE [dbo].[TableTypeIndexType] AS TABLE (
    [Date]             DATE             NULL,
    [Name]             NVARCHAR (256)   NULL,
    [Publication_Time] TIME (7)         NULL,
    [Value]            DECIMAL (28, 15) NULL);

