-- Procedure
CREATE PROCEDURE [dbo].[usp_DeleteNoteTransactionDetail] 
(
	@NoteTransactionDetailID UNIQUEIDENTIFIER,
	@NoteID UNIQUEIDENTIFIER

)
AS
BEGIN

Declare @UpdatedBy varchar(256)

Select @UpdatedBy=UpdatedBy from cre.NoteTransactionDetail 
where 
NoteTransactionDetailID= @NoteTransactionDetailID and
 NoteID=@NoteID

Delete from cre.NoteTransactionDetail 
where NoteTransactionDetailID= @NoteTransactionDetailID
and NoteID= @NoteID




	--Recalc note
	declare @TableTypeCalculationRequests TableTypeCalculationRequests
	
	insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
	Select NoteId,'Processing',@UpdatedBy,'Real Time',an.AnalysisID ,775
	From Cre.Note,core.Analysis an
	where NoteID =@NoteID
	and an.name = 'Default'
	
	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy 






END
