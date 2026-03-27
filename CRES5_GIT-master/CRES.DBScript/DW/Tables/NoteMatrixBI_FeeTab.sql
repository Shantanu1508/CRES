CREATE TABLE [DW].[NoteMatrixBI_FeeTab] (
	[NoteMatrixBI_FeeTab_AutoID]  INT  IDENTITY (1, 1) NOT NULL,
    [DealID]        NVARCHAR (256)   NULL,
    [DealGroupID]   NVARCHAR (256)   NULL,
    [NoteID]        NVARCHAR (256)   NULL,
    [Pri]           INT              NULL,
    [DealName]      NVARCHAR (256)   NULL,
    [NoteName]      NVARCHAR (256)   NULL,
	[ExitFee1]		Decimal(28,15),
    [CreatedDate]	DATETIME NULL, 
    SheetName nvarchar(256)
    CONSTRAINT [PK_NoteMatrixBI_FeeTab_NoteMatrixBI_FeeTab_AutoID] PRIMARY KEY CLUSTERED (NoteMatrixBI_FeeTab_AutoID ASC)
);


GO
