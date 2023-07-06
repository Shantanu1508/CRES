CREATE TABLE [DW].[BerkadiaDataTap] (
    [DealID]            NVARCHAR (256)   NULL,
    [NoteID]            NVARCHAR (256)   NULL,
    [Principal_Balance] DECIMAL (28, 15) NULL,
    [Interest_Rate]     DECIMAL (28, 15) NULL,
    [Next_Pmt_Due_Dt]   DATETIME         NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         DEFAULT (getdate()) NULL
);

