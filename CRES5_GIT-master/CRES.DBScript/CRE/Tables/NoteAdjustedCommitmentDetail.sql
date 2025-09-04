CREATE TABLE [CRE].[NoteAdjustedCommitmentDetail] (
    [NoteAdjustedCommitmentDetailID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteAdjustedCommitmentMasterID] INT              NULL,
    [NoteID]                         UNIQUEIDENTIFIER NULL,
    [Value]                          DECIMAL (28, 15) NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [Type]                           INT              NULL,
    [DealID]                         UNIQUEIDENTIFIER NULL,
    [NoteTotalCommitment]            DECIMAL (28, 15) NULL,
    [NoteAdjustedTotalCommitment]    DECIMAL (28, 15) NULL,
    [NoteAggregatedTotalCommitment]  DECIMAL (28, 15) NULL,
    [Rowno]                          INT              NULL,
    CONSTRAINT [PK_NoteAdjustedCommitmentDetail_NoteAdjustedCommitmentDetailID] PRIMARY KEY CLUSTERED ([NoteAdjustedCommitmentDetailID] ASC)
);


GO
ALTER TABLE [CRE].[NoteAdjustedCommitmentDetail] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



go



