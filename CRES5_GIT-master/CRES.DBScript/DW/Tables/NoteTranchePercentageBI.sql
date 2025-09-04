CREATE TABLE [DW].[NoteTranchePercentageBI] (
    [NoteTranchePercentageID]        INT              NULL,
    [CRENoteId]                      NVARCHAR (256)   NULL,
    [SoldDate]                       DATE             NULL,
    [TrancheName]                    NVARCHAR (256)   NULL,
    [PercentofNote]                  DECIMAL (28, 15) NULL,
    [NoteTranchePercentageBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_NoteTranchePercentageBI_AutoID] PRIMARY KEY CLUSTERED ([NoteTranchePercentageBI_AutoID] ASC)
);



