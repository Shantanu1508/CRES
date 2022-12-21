CREATE TYPE [dbo].[tblPrepayallocationsoutput] AS TABLE (
    [noteid]     VARCHAR (256)    NULL,
    [minmultdue] DECIMAL (28, 15) NULL,
    [prepaydt]   DATE             NULL);
GO

