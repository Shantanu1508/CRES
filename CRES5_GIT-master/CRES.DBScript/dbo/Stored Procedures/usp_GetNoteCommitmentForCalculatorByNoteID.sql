CREATE PROCEDURE [dbo].[usp_GetNoteCommitmentForCalculatorByNoteID]
	@NoteID uniqueidentifier 
AS  
BEGIN  

 SET NOCOUNT ON;  

	SELECT Date,l.Name as Type,ISNULL(ndc.Value,0) as Amount,NoteAdjustedTotalCommitment as [TotalCommitmentAdjustment],
		   NoteTotalCommitment as [TotalCommitment],ndc.Rowno 
	from cre.NoteAdjustedCommitmentDetail ndc
	left join cre.NoteAdjustedCommitmentMaster nm on nm.NoteAdjustedCommitmentMasterID = ndc.NoteAdjustedCommitmentMasterID
	left join core.lookup l on l.LookupID = nm.Type
	where NoteID = @NoteID
	order by date asc
 
END
