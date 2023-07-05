-- Procedure





CREATE PROCEDURE [dbo].[usp_GetMarketPriceByNoteID]  --'3419','b0e6697b-3534-4c09-be0a-04473401ab93'
(
@NoteId nvarchar(256),
@UserID nvarchar(256)
)
AS
BEGIN
	SELECT NoteID,CAST(Date as Date) as [Date],Value From CRE.NoteAttributesbyDate WHERE NoteID = (SELECT CRENoteID FROM CRE.Note WHERE NoteID = @NoteId)
	order by date desc
END
	
	
