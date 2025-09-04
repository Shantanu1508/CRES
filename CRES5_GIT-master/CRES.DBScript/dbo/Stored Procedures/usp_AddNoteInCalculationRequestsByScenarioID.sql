CREATE PROCEDURE [dbo].[usp_AddNoteInCalculationRequestsByScenarioID] 
@ScenarioID Uniqueidentifier = null,
@UserID Uniqueidentifier = null,
@ApplicationText nvarchar(256) =null
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
Declare @calculationRequest [TableTypeCalculationRequests] 

declare @cashflowEngineId int;
Select @cashflowEngineId=lookupid from core.Lookup where ParentID=47 and Name='Default'


INSERT INTO @calculationRequest (NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalcType)		
SELECT 
distinct n.[NoteId],
'Processing' as StatusText,
@UserID as UserName,
@ApplicationText as ApplicationText,
'Batch' as PriorityText,
@ScenarioID as AnalysisID,
775 as CalcType
from  CRE.Note n
left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID = @ScenarioID	
left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
inner join cre.Deal d on n.DealId = d.DealId
left join Core.Lookup l ON cr.[StatusID]=l.LookupID
left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
where  
n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)
and ac.IsDeleted=0
and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')
and cr.CalcType = 775


--=======================================
EXEC [dbo].[usp_QueueNotesForCalculation] 	@calculationRequest,@UserID,@UserID, NULL, NULL, 'Scenario'
--=======================================	
	
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END



