--Drop TYPE [dbo].[TableAdjustedTotalCommitment] 

CREATE TYPE [dbo].[TableAdjustedTotalCommitment] AS TABLE (
    [NoteAdjustedCommitmentMasterID] INT              NULL,
    [DealID]                         UNIQUEIDENTIFIER NULL,
    [Date]                           DATE             NULL,
    [Type]                           INT              NULL,
    [Rownumber]                      INT              NULL,
    [DealAdjustmentHistory]          DECIMAL (28, 15) NULL,
    [AdjustedCommitment]             DECIMAL (28, 15) NULL,
    [TotalCommitment]                DECIMAL (28, 15) NULL,
    [AggregatedCommitment]           DECIMAL (28, 15) NULL,
    [Comments]                       NVARCHAR (256)   NULL,
    [NoteID]                         UNIQUEIDENTIFIER NULL,
    [Amount]                         DECIMAL (28, 15) NULL,
    [NoteAdjustedTotalCommitment]    DECIMAL (28, 15) NULL,
    [NoteAggregatedTotalCommitment]  DECIMAL (28, 15) NULL,
    [NoteTotalCommitment]            DECIMAL (28, 15) NULL,
    [TotalRequiredEquity]            DECIMAL (28, 15) NULL,
	[TotalAdditionalEquity]          DECIMAL (28, 15) NULL,
    [TotalEquityatClosing]             DECIMAL (28, 15) NULL
    );

