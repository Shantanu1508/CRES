
create PROCEDURE dbo.[usp_GetAllNotes] 

AS
BEGIN
SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	SELECT distinct n.NoteID			  
			  , n.CRENoteID from cre.note n 
			inner join cre.TranscationReconciliation tr on tr.NoteID =n.NoteID
			where tr.PostedDate  is null 

			  
		--	select * from cre.TranscationReconciliation

END
