
CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusForDependents]
@NoteID uniqueidentifier,
@AnalysisID uniqueidentifier
 
AS
BEGIN
	update Core.CalculationRequests 
set StatusID =  (select LookupID from Core.Lookup where ParentID=40 and name ='Processing')

where NoteId in(select StripTransferTo from CRE.PayruleSetup  ps 
where ps.StripTransferFrom =@NoteID  and StripTransferTo not in(
 
 select StripTransferTo from CRE.PayruleSetup where StripTransferTo in
 (select StripTransferTo from CRE.PayruleSetup  ps 
where ps.StripTransferFrom =@NoteID  )
and StripTransferFrom !=@NoteID --'00DA9C97-814E-439C-A31B-B438F207FF1A'  
and StripTransferFrom  not in (select NoteId from Core.CalculationRequests  where StatusID =  (select LookupID from Core.Lookup where ParentID=40 and name ='Completed'))

))
AND AnalysisID = @AnalysisID
and CalcType = 775

END


