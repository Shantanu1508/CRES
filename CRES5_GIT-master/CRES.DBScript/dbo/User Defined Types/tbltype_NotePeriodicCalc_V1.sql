CREATE TYPE [dbo].[tbltype_NotePeriodicCalc_V1] AS TABLE (
    [Date]             DATE             NULL,
    [Note]             NVARCHAR (100)   NULL,
    [initbal]          DECIMAL (28, 15) NULL,
    [endbal]           DECIMAL (28, 15) NULL,
    [schprin]          DECIMAL (28, 15) NULL,
    [funding_fundpydn] DECIMAL (28, 15) NULL);
GO

