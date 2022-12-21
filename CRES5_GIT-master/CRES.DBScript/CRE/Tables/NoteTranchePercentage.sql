CREATE TABLE [CRE].[NoteTranchePercentage] (
    [NoteTranchePercentageID] INT              IDENTITY (1, 1) NOT NULL,
    [CRENoteId]               NVARCHAR (256)   NULL,
    [SoldDate]                DATE             NULL,
    [TrancheName]             NVARCHAR (256)   NULL,
    [PercentofNote]           DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_NoteTranchePercentageID] PRIMARY KEY CLUSTERED ([NoteTranchePercentageID] ASC)
);

