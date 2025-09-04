
CREATE PROCEDURE [dbo].[usp_CopyNoteEntityPercentage]
	@CRENoteIDFrom nvarchar(256),
	@CRENoteIDTo nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

Declare @CRENoteID_CopyFrom nvarchar(256) = @CRENoteIDFrom
Declare @CRENoteID_CopyTo nvarchar(256) = @CRENoteIDTo

Declare @NoteID_CopyFrom UNIQUEIDENTIFIER
Declare @NoteID_CopyTo UNIQUEIDENTIFIER

SET @NoteID_CopyFrom = (Select noteid from cre.note where CRENoteID = @CRENoteID_CopyFrom)
SET @NoteID_CopyTo = (Select noteid from cre.note where CRENoteID = @CRENoteID_CopyTo)


---------------------------------------

Delete from CRE.NoteTranchePercentage where CRENoteId = @CRENoteID_CopyTo

INSERT INTO CRE.NoteTranchePercentage(CRENoteId,TrancheName,PercentofNote)
Select @CRENoteID_CopyTo,TrancheName,PercentofNote
from CRE.NoteTranchePercentage nt
Inner join cre.note n on n.CRENoteID = nt.CRENoteId
Inner join cre.Entity et on et.EntityName = nt.TrancheName
where n.crenoteid = @CRENoteID_CopyFrom


Delete from [CRE].[NoteEntityAllocation] where noteid = @NoteID_CopyTo

INSERT INTO CRE.[NoteEntityAllocation](EntityID,noteid,PctAllocation)
Select et.EntityID,@NoteID_CopyTo,PercentofNote
from CRE.NoteTranchePercentage nt
Inner join cre.note n on n.CRENoteID = nt.CRENoteId
Inner join cre.Entity et on et.EntityName = nt.TrancheName
where n.crenoteid = @CRENoteID_CopyFrom



---Select * from cre.Entity
Select * from CRE.NoteTranchePercentage where CRENoteId = @CRENoteID_CopyTo
Select * from [CRE].[NoteEntityAllocation] where noteid = @NoteID_CopyTo


END


