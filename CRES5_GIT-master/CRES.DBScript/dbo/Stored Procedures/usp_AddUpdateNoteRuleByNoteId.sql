
--[dbo].[usp_GetNoteByNoteId]  'fc977090-a4d7-4360-be52-faefab844745','fc977090-a4d7-4360-be52-faefab844745'
CREATE PROCEDURE [dbo].[usp_AddUpdateNoteRuleByNoteId] 
(
    @NoteId Varchar(500),
	@UserID UNIQUEIDENTIFIER,
	@NoteRule nvarchar(2000)
)
	
AS
BEGIN

   SET NOCOUNT ON;
   UPDATE CRE.Note SET NoteRule=@NoteRule where NoteID=@NoteId
END
