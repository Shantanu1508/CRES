CREATE PROCEDURE [DW].[usp_MergeLiabilityNoteAssetMapping]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON

UPDATE [DW].BatchDetail SET
BITableName = 'LiabilityNoteAssetMappingBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_LiabilityNoteAssetMappingBI'


Delete From [DW].[LiabilityNoteAssetMappingBI] where LiabilityNoteAccountId in (Select [LiabilityNoteAccountId] From [DW].[L_LiabilityNoteAssetMappingBI])


INSERT INTO [DW].[LiabilityNoteAssetMappingBI]
([LiabilityNoteAssetMappingID]
,[LiabilityNoteAssetMappingGuid]
,[DealAccountId]
,[DealID]
,[LiabilityNoteAccountId]
,[AssetAccountId]
,[NoteID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])
Select 
[LiabilityNoteAssetMappingID]
,[LiabilityNoteAssetMappingGuid]
,[DealAccountId]
,[DealID]
,[LiabilityNoteAccountId]
,[AssetAccountId]
,[NoteID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
From [DW].[L_LiabilityNoteAssetMappingBI]



DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_LiabilityNoteAssetMappingBI'

Print(char(9) +'usp_MergeLiabilityNoteAssetMapping - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END