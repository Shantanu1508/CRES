CREATE TYPE [dbo].[TableTypeBerkadiaDataTap] AS TABLE (
    [DealID]            NVARCHAR (256)   NULL,
    [NoteID]            NVARCHAR (256)   NULL,
    [Principal_Balance] DECIMAL (28, 15) NULL,
    [Interest_Rate]     DECIMAL (28, 15) NULL,
    [Next_Pmt_Due_Dt]   DATETIME         NULL);

