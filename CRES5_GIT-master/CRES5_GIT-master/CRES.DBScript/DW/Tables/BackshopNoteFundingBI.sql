CREATE TABLE [DW].[BackshopNoteFundingBI] (
    [ControlID]          NVARCHAR (100)   NULL,
    [DealName]           NVARCHAR (256)   NULL,
    [FundingDate]        DATE             NULL,
    [NoteID]             NVARCHAR (100)   NULL,
    [ServicerLoanNumber] NVARCHAR (100)   NULL,
    [NoteName]           NVARCHAR (256)   NULL,
    [FinancingSource]    NVARCHAR (256)   NULL,
    [FundingAmount]      DECIMAL (28, 15) NULL,
    [WireConfirm]        NVARCHAR (10)    NULL,
    [FundingPurpose]     NVARCHAR (256)   NULL,
    [RSLIC]              DECIMAL (28, 15) NULL,
    [SNCC]               DECIMAL (28, 15) NULL,
    [PIIC]               DECIMAL (28, 15) NULL,
    [TMR]                DECIMAL (28, 15) NULL,
    [HCC]                DECIMAL (28, 15) NULL,
    [USSIC]              DECIMAL (28, 15) NULL,
    [TMNF]               DECIMAL (28, 15) NULL,
    [HAIH]               DECIMAL (28, 15) NULL
);

