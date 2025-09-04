CREATE View dbo.vw_Transaction_NPC_AllScenario
AS


Select NoteKey,NoteID,DATE,Amount,Type,AnalysisID,Scenario,DealName,DealID,NoteName
from transactionentry   
where AccountTypeID = 1

UNION ALL

Select NoteKey,NoteID,DATE,Amount,Type,AnalysisID,Scenario,DealName,DealID,NoteName
from [dbo].[vw_NPC_AllScenarios_Unpivot]