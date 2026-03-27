CREATE TABLE [DW].[BackshopNoteBI] (
    [LoanNumber]                     NVARCHAR (256)   NULL,
    [DealName]                       NVARCHAR (256)   NULL,
    [NoteID]                         NVARCHAR (256)   NULL,
    [NoteName]                       NVARCHAR (256)   NULL,
    [ServicerLoanNumber]             NVARCHAR (256)   NULL,
    [FundingDate]                    DATE             NULL,
    [PastFunding]                    DECIMAL (28, 15) NULL,
    [FutureFunding]                  DECIMAL (28, 15) NULL,
    [InitialLoanAmount]              DECIMAL (28, 15) NULL,
    [TotalCommitmentAmount]          DECIMAL (28, 15) NULL,
    [TotalCurrentAdjustedCommitment] DECIMAL (28, 15) NULL,
    [CurrentBalance]                 DECIMAL (28, 15) NULL,
    [FinancingSource]                NVARCHAR (256)   NULL,
    [RSLIC]                          DECIMAL (28, 15) NULL,
    [SNCC]                           DECIMAL (28, 15) NULL,
    [PIIC]                           DECIMAL (28, 15) NULL,
    [TMR]                            DECIMAL (28, 15) NULL,
    [HCC]                            DECIMAL (28, 15) NULL,
    [USSIC]                          DECIMAL (28, 15) NULL,
    [TMNF]                           DECIMAL (28, 15) NULL,
    [HAIH]                           DECIMAL (28, 15) NULL,
    [TotalParticipation]             DECIMAL (28, 15) NULL,
    [BackshopNoteBI_AutoID]          INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BackshopNoteBI_AutoID] PRIMARY KEY CLUSTERED ([BackshopNoteBI_AutoID] ASC)
);



