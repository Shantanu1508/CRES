
CREATE PROCEDURE [VAL].[usp_InsertUpdateNotesWeight]
(
	@tbltype_NotesWeight [val].[tbltype_NotesWeight] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_NotesWeight))

	Delete from [VAL].[NotesWeight] Where MarkedDateMasterID=@MarkedDateMasterID;

	INSERT INTO [VAL].[NotesWeight](MarkedDateMasterID,PropertyType,Header,SortOrder,[Value],[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,PropertyType,Header,SortOrder,[Value],UserID,getdate(),UserID,getdate()
	From @tbltype_NotesWeight

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END