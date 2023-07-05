
CREATE PROCEDURE [dbo].[usp_DeleteSizerDocuments] 
@crenoteid nvarchar(256)

AS
BEGIN

delete from CRE.SizerDocuments where ObjectID= (select NoteID from CRE.Note where CRENoteID=@crenoteid) and ObjectTypeID=(select LookupID from Core.Lookup where ParentID=27  and name ='note') 

END

