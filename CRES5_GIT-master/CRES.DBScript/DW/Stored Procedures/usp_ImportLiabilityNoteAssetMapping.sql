CREATE PROCEDURE [DW].[usp_ImportLiabilityNoteAssetMapping]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_LiabilityNoteAssetMappingBI',GETDATE())

	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


IF EXISTS(Select [LiabilityNoteAssetMappingID] from [dw].[LiabilityNoteAssetMappingBI])
BEGIN

Truncate table [DW].[L_LiabilityNoteAssetMappingBI]

INSERT INTO [DW].[L_LiabilityNoteAssetMappingBI]
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
 LN.[LiabilityNoteAssetMappingID]
,LN.[LiabilityNoteAssetMappingGuid]
,LN.[DealAccountId]
,D.[DealID]
,LN.[LiabilityNoteAccountId]
,LN.[AssetAccountId]
,N.[CRENoteID]
,LN.[CreatedBy]
,LN.[CreatedDate]
,LN.[UpdatedBy]
,LN.[UpdatedDate]

FROM CRE.LiabilityNoteAssetMapping LN
LEFT Join Cre.Deal D ON D.AccountID = LN.DealAccountID
LEFT Join Cre.Note N ON N.Account_AccountID = LN.AssetAccountID
WHERE (LN.CreatedDate > @LastBatchStart and LN.CreatedDate < @CurrentBatchStart) 
OR (LN.UpdatedDate > @LastBatchStart and LN.UpdatedDate < @CurrentBatchStart)

SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportLiabilityNoteAssetMapping - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END
ELSE
BEGIN

Truncate table [DW].[L_LiabilityNoteAssetMappingBI]
INSERT INTO [DW].[L_LiabilityNoteAssetMappingBI]
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
 LN.[LiabilityNoteAssetMappingID]
,LN.[LiabilityNoteAssetMappingGuid]
,LN.[DealAccountId]
,D.[DealID]
,LN.[LiabilityNoteAccountId]
,LN.[AssetAccountId]
,N.[CRENoteID]
,LN.[CreatedBy]
,LN.[CreatedDate]
,LN.[UpdatedBy]
,LN.[UpdatedDate]

FROM CRE.LiabilityNoteAssetMapping LN
LEFT Join Cre.Deal D ON D.AccountID = LN.DealAccountID
LEFT Join Cre.Note N ON N.Account_AccountID = LN.AssetAccountID

SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportLiabilityNoteAssetMapping - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END

UPDATE [DW].BatchDetail SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id

END