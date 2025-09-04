CREATE TABLE [DW].[L_LiabilityNoteAssetMappingBI](
	[LiabilityNoteAssetMappingID] [int] NOT NULL,
	[LiabilityNoteAssetMappingGuid] [uniqueidentifier] NOT NULL,
	[DealAccountId] [uniqueidentifier] NULL,
	[DealID] [uniqueidentifier] NULL,
	[LiabilityNoteAccountId] [uniqueidentifier] NULL,
	[AssetAccountId] [uniqueidentifier] NULL,
	[NoteID] [nvarchar] (256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL
)