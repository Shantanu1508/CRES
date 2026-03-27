CREATE TABLE [DW].[BackshopCommitmentAdjBI] (
    [LoanNumber]                     NVARCHAR (100)   NULL,
    [DealName]                       NVARCHAR (256)   NULL,
    [NoteID]                         NVARCHAR (100)   NULL,
    [NoteName]                       NVARCHAR (256)   NULL,
    [AdjustmentDate]                 DATE             NULL,
    [AdjustmentAmount]               DECIMAL (28, 15) NULL,
    [BackshopCommitmentAdjBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BackshopCommitmentAdjBI_AutoID] PRIMARY KEY CLUSTERED ([BackshopCommitmentAdjBI_AutoID] ASC)
);



