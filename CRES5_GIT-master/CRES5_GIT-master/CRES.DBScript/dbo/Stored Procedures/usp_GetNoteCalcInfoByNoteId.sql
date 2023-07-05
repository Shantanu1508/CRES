--[dbo].[usp_GetNoteCalcInfoByNoteId] '620d9a47-1894-4396-b2ca-d07f68109ba3','c10f3372-0fc2-4861-a9f5-148f1f80804f','b0e6697b-3534-4c09-be0a-04473401ab93'


CREATE Procedure [dbo].[usp_GetNoteCalcInfoByNoteId]    --  '620d9a47-1894-4396-b2ca-d07f68109ba3','c10f3372-0fc2-4861-a9f5-148f1f80804f','b0e6697b-3534-4c09-be0a-04473401ab93'
(  
 @NoteId uniqueidentifier,  
 @ScenarioId uniqueidentifier,  
 @UserID uniqueidentifier  
)  
as   
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
 SELECT   
  ISNULL(npr.[UpdatedBy] ,0) as [UpdatedBy]  
     ,[dbo].[ufn_GetTimeByTimeZone] (npr.[UpdatedDate],@USerID) as [UpdatedDate]
 --,ISNULL(max(npr.[UpdatedDate] ),0) as [UpdatedDate]  
 ,ISNULL(CRL.Name,'') as CalculationStatus  
  
FROM CRE.NotePeriodicCalc npr  
left join Core.CalculationRequests cr on cr.NoteId = npr.NoteID   and cr.AnalysisID =@ScenarioId  
left join [core].[Lookup] CRL On CRL.LookUpID = CR.StatusID  
where npr.NoteID = @NoteId and npr.AnalysisID =@ScenarioId  
and cr.CalcType = 775
group by npr.[UpdatedBy],npr.[UpdatedDate],CRL.Name   
 
 
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
