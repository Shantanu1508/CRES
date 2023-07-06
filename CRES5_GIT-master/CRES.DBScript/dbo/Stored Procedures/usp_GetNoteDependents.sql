
CREATE PROCEDURE [dbo].[usp_GetNoteDependents] --'55AB0A8D-80E8-458F-AD93-98946F68CEEE'
	(
	@NoteID varchar(50)
	)
AS

 BEGIN
 	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 select 
StripTransferFrom,
StripTransferTo,
ps.Value,
l1.LookupID,
l1.name

from
CRE.PayruleSetup ps
Left Join Core.Lookup l1 on ps.RuleID=l1.LookupID
where StripTransferFrom = @NoteID
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
