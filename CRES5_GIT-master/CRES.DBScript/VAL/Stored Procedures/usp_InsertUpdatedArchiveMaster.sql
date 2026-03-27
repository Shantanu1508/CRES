
CREATE PROCEDURE [VAL].[usp_InsertUpdatedArchiveMaster]
(
	@MarkedDate	Date,
	@UserID nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	Declare @ArchiveMasterID int;
	Declare @ArchiveMasterID_Old int;
	Declare @ArchiveMasterID_New int;


	IF EXISTS(Select top 1 DealOutputID from [VAL].[DealOutput] where MarkedDateMasterID = @MarkedDateMasterID)
	BEGIN

		IF EXISTS(Select ArchiveMasterID from [VAL].[ArchiveMaster] where MarkedDateMasterID = @MarkedDateMasterID and isdeleted <> 1)
		BEGIN
			--If MarkedDate already exists
			SET @ArchiveMasterID_Old = (Select ArchiveMasterID from [VAL].[ArchiveMaster] where MarkedDateMasterID = @MarkedDateMasterID and isdeleted <> 1)
			Update [VAL].[ArchiveMaster] SET Isdeleted = 1,UpdatedBy =@UserID,Updateddate = getdate() where ArchiveMasterID = @ArchiveMasterID_Old


			INSERT INTO [VAL].[ArchiveMaster](MarkedDateMasterID,Isdeleted,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
			VALUES(@MarkedDateMasterID,0,@UserID,getdate(),@UserID,getdate())

			SET @ArchiveMasterID_New = (Select ArchiveMasterID from [VAL].[ArchiveMaster] where MarkedDateMasterID = @MarkedDateMasterID and isdeleted <> 1)


			INSERT INTO [VAL].[DealOutputArchive]
			(ArchiveMasterID
			,[DealID]
			,[CalculationStatus]
			,[LastCalculatedon]
			,[PayoffExtended]
			,[DealMarkPriceClean]
			,[DealGAAPPriceClean]
			,[DealMarkClean]
			,[DealUPB]
			,[DealCommitment]
			,[DealGAAPBasisDirty]
			,[DealYieldatParClean]
			,[DealYieldatGAAPBasis]
			,[DealMarkYield]
			,[CalculatedDealAccruedRate]
			,[DealGAAPDM_GtrFLR_Index]
			,[DealMarkDM_GtrFLR_Index]
			,[DealDuration_OnCommitment]
			,[GrossFloorValuefromGrid]
			,[GrossValue_UsageScalar]
			,[DollarValueofFloorinMark]
			,[PointvalueofFloorinMark]
			,[Term]
			,[Strike]
			,[MktStrike]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate])
			Select 
			@ArchiveMasterID_New
			,[DealID]
			,[CalculationStatus]
			,[LastCalculatedon]
			,[PayoffExtended]
			,[DealMarkPriceClean]
			,[DealGAAPPriceClean]
			,[DealMarkClean]
			,[DealUPB]
			,[DealCommitment]
			,[DealGAAPBasisDirty]
			,[DealYieldatParClean]
			,[DealYieldatGAAPBasis]
			,[DealMarkYield]
			,[CalculatedDealAccruedRate]
			,[DealGAAPDM_GtrFLR_Index]
			,[DealMarkDM_GtrFLR_Index]
			,[DealDuration_OnCommitment]
			,[GrossFloorValuefromGrid]
			,[GrossValue_UsageScalar]
			,[DollarValueofFloorinMark]
			,[PointvalueofFloorinMark]
			,[Term]
			,[Strike]
			,[MktStrike]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate]
			From [VAL].[DealOutputArchive]
			where ArchiveMasterID = @ArchiveMasterID_Old	

			INSERT INTO [VAL].[NoteOutputArchive]
			(ArchiveMasterID
			,NoteID
			,DealID
			,CalculationStatus
			,LastCalculatedOn	
			,NoteMarkPriceClean
			,NoteGAAPPriceClean
			,NoteMarkClean
			,NoteUPB
			,NoteCommitment
			,NoteBasisDirty
			,NoteYieldatGAAPBasis
			,NoteMarkYield
			,CalculatedNoteAccruedRate
			,NoteGAAPDMIndex
			,NoteMarkDMgtrFLRIndex
			,NoteDurationonCommitment	
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate])
			Select 
			@ArchiveMasterID_New
			,NoteID
			,DealID
			,CalculationStatus
			,LastCalculatedOn	
			,NoteMarkPriceClean
			,NoteGAAPPriceClean
			,NoteMarkClean
			,NoteUPB
			,NoteCommitment
			,NoteBasisDirty
			,NoteYieldatGAAPBasis
			,NoteMarkYield
			,CalculatedNoteAccruedRate
			,NoteGAAPDMIndex
			,NoteMarkDMgtrFLRIndex
			,NoteDurationonCommitment	
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate]
			from [VAL].[NoteOutputArchive]
			where ArchiveMasterID = @ArchiveMasterID_Old

			
			Delete From [VAL].[DealOutputArchive] where ArchiveMasterID = @ArchiveMasterID_New and DealID in (Select Distinct DealID from [VAL].[DealOutput] where MarkedDateMasterID = @MarkedDateMasterID)
			Delete From [VAL].[NoteOutputArchive] where ArchiveMasterID = @ArchiveMasterID_New and NoteID in (Select Distinct NoteID from [VAL].[NoteOutput] where MarkedDateMasterID = @MarkedDateMasterID)

			INSERT INTO [VAL].[DealOutputArchive]
			(ArchiveMasterID
			,[DealID]
			,[CalculationStatus]
			,[LastCalculatedon]
			,[PayoffExtended]
			,[DealMarkPriceClean]
			,[DealGAAPPriceClean]
			,[DealMarkClean]
			,[DealUPB]
			,[DealCommitment]
			,[DealGAAPBasisDirty]
			,[DealYieldatParClean]
			,[DealYieldatGAAPBasis]
			,[DealMarkYield]
			,[CalculatedDealAccruedRate]
			,[DealGAAPDM_GtrFLR_Index]
			,[DealMarkDM_GtrFLR_Index]
			,[DealDuration_OnCommitment]
			,[GrossFloorValuefromGrid]
			,[GrossValue_UsageScalar]
			,[DollarValueofFloorinMark]
			,[PointvalueofFloorinMark]
			,[Term]
			,[Strike]
			,[MktStrike]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate])
			Select 
			@ArchiveMasterID_New
			,[DealID]
			,[CalculationStatus]
			,[LastCalculatedon]
			,[PayoffExtended]
			,[DealMarkPriceClean]
			,[DealGAAPPriceClean]
			,[DealMarkClean]
			,[DealUPB]
			,[DealCommitment]
			,[DealGAAPBasisDirty]
			,[DealYieldatParClean]
			,[DealYieldatGAAPBasis]
			,[DealMarkYield]
			,[CalculatedDealAccruedRate]
			,[DealGAAPDM_GtrFLR_Index]
			,[DealMarkDM_GtrFLR_Index]
			,[DealDuration_OnCommitment]
			,[GrossFloorValuefromGrid]
			,[GrossValue_UsageScalar]
			,[DollarValueofFloorinMark]
			,[PointvalueofFloorinMark]
			,[Term]
			,[Strike]
			,[MktStrike]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate]
			From VAL.DealOutput
			where MarkedDateMasterID = @MarkedDateMasterID

			INSERT INTO [VAL].[NoteOutputArchive]
			(ArchiveMasterID
			,NoteID
			,DealID
			,CalculationStatus
			,LastCalculatedOn	
			,NoteMarkPriceClean
			,NoteGAAPPriceClean
			,NoteMarkClean
			,NoteUPB
			,NoteCommitment
			,NoteBasisDirty
			,NoteYieldatGAAPBasis
			,NoteMarkYield
			,CalculatedNoteAccruedRate
			,NoteGAAPDMIndex
			,NoteMarkDMgtrFLRIndex
			,NoteDurationonCommitment	
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate])
			Select 
			@ArchiveMasterID_New
			,NoteID
			,DealID
			,CalculationStatus
			,LastCalculatedOn	
			,NoteMarkPriceClean
			,NoteGAAPPriceClean
			,NoteMarkClean
			,NoteUPB
			,NoteCommitment
			,NoteBasisDirty
			,NoteYieldatGAAPBasis
			,NoteMarkYield
			,CalculatedNoteAccruedRate
			,NoteGAAPDMIndex
			,NoteMarkDMgtrFLRIndex
			,NoteDurationonCommitment	
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate]
			from [VAL].[NoteOutput]
			where MarkedDateMasterID = @MarkedDateMasterID


			Delete From [VAL].[DealOutputArchive] where ArchiveMasterID = @ArchiveMasterID_Old
			Delete From [VAL].[NoteOutputArchive] where ArchiveMasterID = @ArchiveMasterID_Old



		END	
		ELSE
		BEGIN

			INSERT INTO [VAL].[ArchiveMaster](MarkedDateMasterID,Isdeleted,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
			VALUES(@MarkedDateMasterID,0,@UserID,getdate(),@UserID,getdate())

			SET @ArchiveMasterID = (Select ArchiveMasterID from [VAL].[ArchiveMaster] where MarkedDateMasterID = @MarkedDateMasterID and isdeleted <> 1)

			INSERT INTO [VAL].[DealOutputArchive]
			(ArchiveMasterID
			,[DealID]
			,[CalculationStatus]
			,[LastCalculatedon]
			,[PayoffExtended]
			,[DealMarkPriceClean]
			,[DealGAAPPriceClean]
			,[DealMarkClean]
			,[DealUPB]
			,[DealCommitment]
			,[DealGAAPBasisDirty]
			,[DealYieldatParClean]
			,[DealYieldatGAAPBasis]
			,[DealMarkYield]
			,[CalculatedDealAccruedRate]
			,[DealGAAPDM_GtrFLR_Index]
			,[DealMarkDM_GtrFLR_Index]
			,[DealDuration_OnCommitment]
			,[GrossFloorValuefromGrid]
			,[GrossValue_UsageScalar]
			,[DollarValueofFloorinMark]
			,[PointvalueofFloorinMark]
			,[Term]
			,[Strike]
			,[MktStrike]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate])
			Select 
			@ArchiveMasterID
			,[DealID]
			,[CalculationStatus]
			,[LastCalculatedon]
			,[PayoffExtended]
			,[DealMarkPriceClean]
			,[DealGAAPPriceClean]
			,[DealMarkClean]
			,[DealUPB]
			,[DealCommitment]
			,[DealGAAPBasisDirty]
			,[DealYieldatParClean]
			,[DealYieldatGAAPBasis]
			,[DealMarkYield]
			,[CalculatedDealAccruedRate]
			,[DealGAAPDM_GtrFLR_Index]
			,[DealMarkDM_GtrFLR_Index]
			,[DealDuration_OnCommitment]
			,[GrossFloorValuefromGrid]
			,[GrossValue_UsageScalar]
			,[DollarValueofFloorinMark]
			,[PointvalueofFloorinMark]
			,[Term]
			,[Strike]
			,[MktStrike]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate]
			From VAL.DealOutput
			where MarkedDateMasterID = @MarkedDateMasterID

			INSERT INTO [VAL].[NoteOutputArchive]
			(ArchiveMasterID
			,NoteID
			,DealID
			,CalculationStatus
			,LastCalculatedOn	
			,NoteMarkPriceClean
			,NoteGAAPPriceClean
			,NoteMarkClean
			,NoteUPB
			,NoteCommitment
			,NoteBasisDirty
			,NoteYieldatGAAPBasis
			,NoteMarkYield
			,CalculatedNoteAccruedRate
			,NoteGAAPDMIndex
			,NoteMarkDMgtrFLRIndex
			,NoteDurationonCommitment	
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate])
			Select 
			@ArchiveMasterID
			,NoteID
			,DealID
			,CalculationStatus
			,LastCalculatedOn	
			,NoteMarkPriceClean
			,NoteGAAPPriceClean
			,NoteMarkClean
			,NoteUPB
			,NoteCommitment
			,NoteBasisDirty
			,NoteYieldatGAAPBasis
			,NoteMarkYield
			,CalculatedNoteAccruedRate
			,NoteGAAPDMIndex
			,NoteMarkDMgtrFLRIndex
			,NoteDurationonCommitment	
			,[CreatedBy]
			,[CreatedDate]
			,[UpdateBy]
			,[UpdatedDate]
			from [VAL].[NoteOutput]
			where MarkedDateMasterID = @MarkedDateMasterID

		END

	END

	



 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
