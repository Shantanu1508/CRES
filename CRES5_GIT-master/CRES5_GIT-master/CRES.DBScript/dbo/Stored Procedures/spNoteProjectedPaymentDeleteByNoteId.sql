CREATE PROCEDURE dbo.spNoteProjectedPaymentDeleteByNoteId
    @NoteId int
	
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
@stmt = N'acore.spNoteProjectedPaymentDeleteByNoteId @NoteId', 
@params = N'@NoteId int',
@NoteId = @NoteId

END
GO

