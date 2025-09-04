CREATE TABLE [DW].[L_BackshopCurrentBalanceBI] (
    [DealID]                            NVARCHAR (256)   NULL,
    [NoteID]                            INT              NULL,
    [CurrentBalance]                    DECIMAL (28, 15) NULL,
    [ImportDate]                        DATE             NULL,
    [L_BackshopCurrentBalanceBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_BackshopCurrentBalanceBI_AutoID] PRIMARY KEY CLUSTERED ([L_BackshopCurrentBalanceBI_AutoID] ASC)
);



