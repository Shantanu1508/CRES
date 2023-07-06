CREATE TABLE [CRE].[NoteAdjustedCommitmentMaster] (
    [NoteAdjustedCommitmentMasterGUID] UNIQUEIDENTIFIER CONSTRAINT [DF__NoteAdjus__NoteA__5A1A5A11] DEFAULT (newid()) NOT NULL,
    [NoteAdjustedCommitmentMasterID]   INT              IDENTITY (1, 1) NOT NULL,
    [DealID]                           UNIQUEIDENTIFIER NOT NULL,
    [Date]                             DATE             NULL,
    [Type]                             INT              NULL,
    [Comments]                         NVARCHAR (256)   NULL,
    [DealAdjustmentHistory]            DECIMAL (28, 15) NULL,
    [AdjustedCommitment]               DECIMAL (28, 15) NULL,
    [TotalCommitment]                  DECIMAL (28, 15) NULL,
    [AggregatedCommitment]             DECIMAL (28, 15) NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL,
    [TotalRequiredEquity]              DECIMAL (28, 15) NULL,
    [TotalAdditionalEquity]            DECIMAL (28, 15) NULL,   
	Rowno int null,
     ExcludeFromCommitmentCalculation    bit             Null,
     [TotalEquityatClosing]             DECIMAL (28, 15) NULL
);
go
ALTER TABLE [cre].[NoteAdjustedCommitmentMaster]
ADD CONSTRAINT PK_NoteAdjustedCommitmentMaster_NoteAdjustedCommitmentMasterID PRIMARY KEY ([NoteAdjustedCommitmentMasterID]);
