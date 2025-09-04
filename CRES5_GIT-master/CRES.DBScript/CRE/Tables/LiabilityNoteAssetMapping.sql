CREATE TABLE [CRE].[LiabilityNoteAssetMapping] (
    [LiabilityNoteAssetMappingID]   INT              IDENTITY (1, 1) NOT NULL,
    [LiabilityNoteAssetMappingGuid] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DealAccountId]                 UNIQUEIDENTIFIER NULL,
    [LiabilityNoteAccountId]        UNIQUEIDENTIFIER NULL,
    [AssetAccountId]                UNIQUEIDENTIFIER NULL,
    [CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    CONSTRAINT [PK_LiabilityNoteAssetMapping_LiabilityNoteAssetMappingID] PRIMARY KEY CLUSTERED ([LiabilityNoteAssetMappingID] ASC)
);


GO
ALTER TABLE [CRE].[LiabilityNoteAssetMapping] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);

