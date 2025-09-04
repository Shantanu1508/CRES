CREATE PROCEDURE [VAL].[usp_InsertUpdatedNoteList]
(
	@tbltype_NoteList [val].[tbltype_NoteList] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_NoteList))

	Delete from [VAL].[NoteList] Where MarkedDateMasterID=@MarkedDateMasterID;
	
	INSERT INTO [VAL].[NoteList]([MarkedDateMasterID],[CREDealID],[CREDealName],[NoteID],[NoteNominalDMOrPriceForMark],[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	Select @MarkedDateMasterID,[CREDealID],[CREDealName],[NoteID],[NoteNominalDMOrPriceForMark],UserID,getdate(),UserID,getdate() From @tbltype_NoteList;

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

