CREATE TYPE [VAL].[tbltype_ValueDeclineByPropertyType] AS TABLE (
    [MarkedDate]   DATETIME         NULL,
    [PropertyType] NVARCHAR (256)   NULL,
    [ValueDecline] DECIMAL (28, 15) NULL,
    [UserID]       NVARCHAR (256)   NULL);

