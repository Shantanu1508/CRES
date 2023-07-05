------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetNoteIDAndAnalysisID]	  --2307
 
 @crenoteID nvarchar(256)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
      
select NoteID ,
(select AnalysisID from Core.Analysis where Name ='Default' )as  AnalysisID
from CRE.note where CRENoteID=@crenoteID
 

 
END


