CREATE TABLE [DW].[L_UwCashflowBI] (
    [DealID]                NVARCHAR (256)   NULL,
    [NoteId]                NVARCHAR (256)   NULL,
    [CurrentBalance]        DECIMAL (28, 15) NULL,
    [PeriodEndDate]         DATETIME         NULL,
    [L_UwCashflowBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_UwCashflowBI_AutoID] PRIMARY KEY CLUSTERED ([L_UwCashflowBI_AutoID] ASC)
);



