CREATE TYPE [VAL].[tbltype_NoteList] AS TABLE (
    [MarkedDate]                  DATETIME         NULL,
    [CREDealID]                   NVARCHAR (256)   NULL,
    [CREDealName]                 NVARCHAR (256)   NULL,
    [NoteID]                      NVARCHAR (256)   NULL,
    [NoteNominalDMOrPriceForMark] DECIMAL (28, 15) NULL,
    [UserID]                      NVARCHAR (256)   NULL);
GO

