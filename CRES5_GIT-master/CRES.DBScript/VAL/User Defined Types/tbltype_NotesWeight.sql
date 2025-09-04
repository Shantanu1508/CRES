CREATE TYPE [VAL].[tbltype_NotesWeight] AS TABLE (
    [MarkedDate]   DATETIME         NULL,
    [PropertyType] NVARCHAR (256)   NULL,
    [Header]       NVARCHAR (256)   NULL,
    [SortOrder]    INT              NULL,
    [Value]        DECIMAL (28, 15) NULL,
    [UserID]       NVARCHAR (256)   NULL);

