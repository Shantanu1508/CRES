
CREATE PROCEDURE dbo.sp_NoteFundingsDeleteByNoteIdPIK
    @NoteId int	
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
@stmt = N'acore.sp_NoteFundingsDeleteByNoteIdPIK @NoteId', 
@params = N'@NoteId int',
@NoteId = @NoteId

END

