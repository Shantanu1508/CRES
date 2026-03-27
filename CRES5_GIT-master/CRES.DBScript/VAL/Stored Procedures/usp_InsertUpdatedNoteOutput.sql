
CREATE PROCEDURE [VAL].[usp_InsertUpdatedNoteOutput]
(
	@tbltype_NoteOutput [val].[tbltype_NoteOutput] READONLY 

	--@NoteID	nvarchar(256)
	--,@DealID	nvarchar(256)
	--,@CalculationStatus	int
	--,@LastCalculatedOn	datetime
	--,@DealMarkPrice_Clean	decimal(28,15)
	--,@DealGAAPPrice_Clean	decimal(28,15)
	--,@DealMark_Clean	decimal(28,15)
	--,@DealUPB	decimal(28,15)
	--,@DealCommitment	decimal(28,15)
	--,@DealGAAPBasis_Dirty	decimal(28,15)
	--,@DealYieldatGAAPBasis	decimal(28,15)
	--,@DealMarkYield	decimal(28,15)
	--,@CalculatedDealAccruedRate	decimal(28,15)
	--,@DealGAAPDM_gtrFLR_Index	decimal(28,15)
	--,@DealMarkDM_gtrFLR_Index	decimal(28,15)
	--,@DealDuration_onCommitment	decimal(28,15)
	--,@GrossFloorValuefromGrid	decimal(28,15)
	--,@UserID	nvarchar(256)	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_NoteOutput))



	Delete from [VAL].[NoteOutput] where noteid in (
		Select Distinct n.noteid from cre.Note n
		Inner join @tbltype_NoteOutput t on t.noteid = n.CRENoteID		
	)
	and MarkedDateMasterID = @MarkedDateMasterID




	INSERT INTO [VAL].[NoteOutput]
	(
	MarkedDateMasterID
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
	@MarkedDateMasterID
	,n.NoteID
	,d.DealID
	,lCalculationStatus.Lookupid 
	,getdate() as LastCalculatedOn

	,nout.NoteMarkPriceClean
	,nout.NoteGAAPPriceClean
	,nout.NoteMarkClean
	,nout.NoteUPB
	,nout.NoteCommitment
	,nout.NoteBasisDirty
	,nout.NoteYieldatGAAPBasis
	,nout.NoteMarkYield
	,nout.CalculatedNoteAccruedRate
	,nout.NoteGAAPDMIndex
	,nout.NoteMarkDMgtrFLRIndex
	,nout.NoteDurationonCommitment

	,nout.UserID
	,getdate()
	,nout.UserID
	,getdate()
	From @tbltype_NoteOutput nout
	Inner join cre.note n on n.crenoteid = nout.noteid
	Inner join cre.Deal d on d.CREdealid = nout.DealID
	left Join core.lookup lCalculationStatus on lCalculationStatus.name = nout.CalculationStatus and parentid = 40



	
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
