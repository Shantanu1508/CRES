-- Procedure


CREATE PROCEDURE [dbo].[usp_DeleteMarketPriceByNoteID] 
(
	@Tablenotemarketprice [TableNoteMarketPrice] READONLY,
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON;

 DELETE FROM CRE.NoteAttributesbyDate WHERE [NoteID] IN (SELECT [NoteID] FROM @Tablenotemarketprice) 
										and CAST([Date] as Date) IN (SELECT CAST([Date] as Date) FROM @Tablenotemarketprice)


END
