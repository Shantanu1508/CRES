CREATE TYPE [VAL].[tbltype_RateExtension] AS TABLE (
    [MarkedDate]	DATETIME         NULL,
    [Value]			DECIMAL (28, 15) NULL,
    [UserID]		NVARCHAR (256)   NULL);