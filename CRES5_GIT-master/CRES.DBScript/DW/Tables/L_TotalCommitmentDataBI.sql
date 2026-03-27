CREATE TABLE [DW].[L_TotalCommitmentDataBI] (
    [NoteID]                         UNIQUEIDENTIFIER NULL,
    [CRENoteID]                      NVARCHAR (256)   NULL,
    [Date]                           DATE             NULL,
    [Type]                           INT              NULL,
    [TypeBI]                         NVARCHAR (256)   NULL,
    [value]                          DECIMAL (28, 15) NULL,
    [NoteAdjustedTotalCommitment]    DECIMAL (28, 15) NULL,
    [NoteTotalCommitment]            DECIMAL (28, 15) NULL,
    [Rowno]                          INT              NULL,
    [CREDealID]                      NVARCHAR (256)   NULL,
    [dealid]                         UNIQUEIDENTIFIER NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [L_TotalCommitmentDataBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_TotalCommitmentDataBI_AutoID] PRIMARY KEY CLUSTERED ([L_TotalCommitmentDataBI_AutoID] ASC)
);






