CREATE TABLE [DW].[BackshopCurrentBalanceBI] (
    [DealID]         NVARCHAR (256)   NULL,
    [NoteID]         INT              NULL,
    [CurrentBalance] DECIMAL (28, 15) NULL,
    [ImportDate]     DATE             NULL
);


GO
CREATE NONCLUSTERED INDEX [iBackshopCurrentBalanceBI_DealID]
    ON [DW].[BackshopCurrentBalanceBI]([DealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iBackshopCurrentBalanceBI_NoteID]
    ON [DW].[BackshopCurrentBalanceBI]([NoteID] ASC);

