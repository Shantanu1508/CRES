
CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatus]--  'EE1EAE55-C8D9-4B79-94AF-3EC6DC7F6211','EE1EAE55-C8D9-4B79-94AF-3EC6DC7F6211','Running','StartTime',''

@NoteID uniqueidentifier,
@StatusText nvarchar(256),
@AnalysisID uniqueidentifier
AS
BEGIN

SET NOCOUNT ON;		

update 
 Core.CalculationRequests set 
StatusID = (Select lookupid from CORE.Lookup where name = @StatusText and ParentID = 40)
where NoteID=@NoteID AND AnalysisID=@AnalysisID

END
