
CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusForDependents]
@NoteID uniqueidentifier,
@AnalysisID uniqueidentifier
 
AS
BEGIN
	
	
update Core.CalculationRequests 
set StatusID =  (select LookupID from Core.Lookup where ParentID=40 and name ='Processing')
where AccountId in (
	
	Select Account_AccountID from cre.Note Where NoteID in (	
		select StripTransferTo 
		from CRE.PayruleSetup  ps 
		where ps.StripTransferFrom =@NoteID  
		and StripTransferTo not in
		( 
			select StripTransferTo 
			from CRE.PayruleSetup where StripTransferTo in (select StripTransferTo from CRE.PayruleSetup  ps where ps.StripTransferFrom =@NoteID  )
			and StripTransferFrom !=@NoteID --'00DA9C97-814E-439C-A31B-B438F207FF1A'  
			and StripTransferFrom  not in 
			(
				select n.NoteId from Core.CalculationRequests cr
				Inner Join core.Account acc on acc.AccountID = cr.AccountId
				Inner JOin cre.Note n on n.Account_AccountID = acc.AccountID
				where cr.StatusID =  (select LookupID from Core.Lookup where ParentID=40 and name ='Completed')
			)
		)
	)

)
AND AnalysisID = @AnalysisID
and CalcType = 775

END


