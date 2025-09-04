
CREATE PROCEDURE [VAL].[usp_InsertUpdatedNoteMatrixData]
(
	@tbltype_NoteMatrixData [val].[tbltype_NoteMatrixData] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_NoteMatrixData))


	IF EXISTS(Select top 1 DealID from @tbltype_NoteMatrixData)
	BEGIN
		Delete from [VAL].[NoteMatrixData] where MarkedDateMasterID = @MarkedDateMasterID

		INSERT INTO [VAL].[NoteMatrixData](
		MarkedDateMasterID
		,NoteMatrixSheetName
		,DealID
		,DealGroupID
		,NoteID
		,DealName
		,NoteName
		,Commitment
		,InitialFunding
		,CurrentMaturity_Date
		,OriginationFee
		,ExtensionFee1
		,ExtensionFee2
		,ExtensionFee3
		,ExitFee
		,ProductType
		,AcoreOrig		
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate])	

		select @MarkedDateMasterID
		,NoteMatrixSheetName
		,DealID
		,DealGroupID
		,NoteID
		,DealName
		,NoteName
		,Commitment
		,InitialFunding
		,CurrentMaturity_Date
		,OriginationFee
		,ExtensionFee1
		,ExtensionFee2
		,ExtensionFee3
		,ExitFee
		,ProductType
		,AcoreOrig	
		,UserID
		,getdate()
		,UserID
		,getdate()
		From @tbltype_NoteMatrixData

	END


 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
