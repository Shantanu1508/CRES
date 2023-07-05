CREATE TYPE [dbo].[TableTypeExceptions] AS TABLE (
    [ObjectID]        UNIQUEIDENTIFIER NULL,
    [ObjectTypeText]  NVARCHAR (256)   NULL,
    [FieldName]       NVARCHAR (256)   NULL,
    [Summary]         NVARCHAR (MAX)   NULL,
    [ActionLevelText] NVARCHAR (256)   NULL);

