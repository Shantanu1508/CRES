
--[dbo].[usp_InsertUpdatedNoteWiseEndingBalance]	'5e1f9de5-3a0e-43b4-b33b-d6b85f177b1d','5e1f9de5-3a0e-43b4-b33b-d6b85f177b1d'

CREATE PROCEDURE [dbo].[usp_InsertUpdatedNoteWiseEndingBalance]
(
	@NoteID UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
Declare @AnalysisID UNIQUEIDENTIFIER;
Declare @CRENoteID nvarchar(256);
Declare @Sum_EndingBalance decimal(28,15);

SET @AnalysisID = (Select AnalysisID from core.Analysis where name = 'Default')

Select @CRENoteID = n.crenoteid,@Sum_EndingBalance = SUM(nc.EndingBalance) 		     
from cre.noteperiodicCalc nc																   
inner join cre.note n on n.noteid = nc.noteid
where nc.[Month] is not null and AnalysisID = @AnalysisID
and nc.NoteID = @NoteID
Group by n.noteid,n.crenoteid


Update [CRE].[NoteWiseEndingBalance] set [SUM_EndingBalance] = @Sum_EndingBalance ,updatedby = null,updateddate = getdate()
Where NoteId = @NoteID

IF @@ROWcount = 0
BEGIN
	INSERT INTO [CRE].[NoteWiseEndingBalance]([NoteId],[CRENoteID],[SUM_EndingBalance],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	VALUES(@NoteID,@CRENoteID,@Sum_EndingBalance,null,getdate(),null,getdate())
END



 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
