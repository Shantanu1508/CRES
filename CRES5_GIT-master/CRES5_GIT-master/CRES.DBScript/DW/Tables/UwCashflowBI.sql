CREATE TABLE [DW].[UwCashflowBI] (
    [DealID]           NVARCHAR (256)   NULL,
    [NoteId]           NVARCHAR (256)   NULL,
    [CurrentBalance]   DECIMAL (28, 15) NULL,
    [PeriodEndDate]    DATETIME         NULL,
    [UwCashflowAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_UwCashflowAutoID] PRIMARY KEY CLUSTERED ([UwCashflowAutoID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iUwCashflowBI_DealID]
    ON [DW].[UwCashflowBI]([DealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iUwCashflowBI_DealID_NoteId]
    ON [DW].[UwCashflowBI]([DealID] ASC, [NoteId] ASC);


GO
CREATE NONCLUSTERED INDEX [iUwCashflowBI_NoteId]
    ON [DW].[UwCashflowBI]([NoteId] ASC);

