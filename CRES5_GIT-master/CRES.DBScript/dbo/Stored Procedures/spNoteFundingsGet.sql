
CREATE PROCEDURE dbo.spNoteFundingsGet
    @FundingId int,
	@NoteId_F int,
	@Applied bit
AS
BEGIN

SET NOCOUNT ON;

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', 
@stmt = N'dbo.spNoteFundingsGet @FundingId, @NoteId_F, @Applied', 
@params = N'@FundingId int,@NoteId_F int,@Applied bit',
@FundingId = @FundingId, @NoteId_F = @NoteId_F,@Applied=@Applied

END
