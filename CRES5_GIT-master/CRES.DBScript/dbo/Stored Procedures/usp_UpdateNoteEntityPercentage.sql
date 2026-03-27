
CREATE PROCEDURE [dbo].[usp_UpdateNoteEntityPercentage]
	@CRENoteID nvarchar(256),
	@EntityName nvarchar(256),
	@Percentage decimal(28,15)
AS
BEGIN
	SET NOCOUNT ON;


Declare @NoteID UNIQUEIDENTIFIER
Declare @EntityID int

SET @NoteID = (Select noteid from cre.note where CRENoteID = @CRENoteID)
SET @EntityID = (Select EntityID from cre.Entity where EntityName = @EntityName)
---------------------------------------

Update CRE.NoteTranchePercentage set PercentofNote = @Percentage where CRENoteId = @CRENoteID and TrancheName =  @EntityName
Update CRE.[NoteEntityAllocation] set PctAllocation = @Percentage where NoteId = @NoteID and EntityID =  @EntityID



---Select * from cre.Entity
Select * from CRE.NoteTranchePercentage where CRENoteId = @CRENoteID
Select * from [CRE].[NoteEntityAllocation] where noteid = @NoteID


END


