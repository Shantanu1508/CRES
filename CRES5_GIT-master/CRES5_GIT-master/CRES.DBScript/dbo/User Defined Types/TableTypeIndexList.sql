CREATE TYPE [dbo].[TableTypeIndexList] AS TABLE (
    [Date]              DATE             NULL,
    [Name]              NVARCHAR (MAX)   NULL,
    [Value]             DECIMAL (28, 15) NULL,
    [IndexesMasterGuid] UNIQUEIDENTIFIER NULL);

