
CREATE TABLE [CRE].[NoteCommitment_BS] (
    [NoteCommitment_BSID]    INT            IDENTITY (1, 1) NOT NULL,
    [CRENoteID]        NVARCHAR (256) NOT NULL,
    [Date]       date NULL,
    [AdjustedCommitment]      DECIMAL(28,15) NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL
    
    CONSTRAINT [PK_NoteCommitment_BSID] PRIMARY KEY CLUSTERED (NoteCommitment_BSID ASC)
);
GO
ALTER TABLE [CRE].[NoteCommitment_BS] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO
