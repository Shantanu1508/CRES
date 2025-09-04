CREATE TYPE [dbo].[TableTypeLiabilityNoteAssetMapping] AS TABLE (
LiabilityNoteId            nvarchar(256) NULL,
DealAccountId                     UNIQUEIDENTIFIER NULL,
LiabilityNoteAccountId            UNIQUEIDENTIFIER NULL,
AssetAccountId                    UNIQUEIDENTIFIER NULL
);