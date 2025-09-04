CREATE TABLE [DW].[BackshopCurrentBalanceBI] (
    [DealID]                          NVARCHAR (256)   NULL,
    [NoteID]                          INT              NULL,
    [CurrentBalance]                  DECIMAL (28, 15) NULL,
    [ImportDate]                      DATE             NULL,
    [BackshopCurrentBalanceBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BackshopCurrentBalanceBI_AutoID] PRIMARY KEY CLUSTERED ([BackshopCurrentBalanceBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iBackshopCurrentBalanceBI_DealID]
    ON [DW].[BackshopCurrentBalanceBI]([DealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iBackshopCurrentBalanceBI_NoteID]
    ON [DW].[BackshopCurrentBalanceBI]([NoteID] ASC);

