-- Procedure



CREATE Procedure [dbo].[usp_GetNoteCalcInfoByNoteId]  --'5e1f9de5-3a0e-43b4-b33b-d6b85f177b1d','c10f3372-0fc2-4861-a9f5-148f1f80804f','b0e6697b-3534-4c09-be0a-04473401ab93'  
(    
 @NoteId uniqueidentifier,    
 @ScenarioId uniqueidentifier,    
 @UserID uniqueidentifier    
)    
as     
BEGIN    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


 Declare @AccountID UNIQUEIDENTIFIER;
 SET @AccountID = (Select Account_AccountID from cre.note where NoteID = @NoteId)

IF EXISTS(select npc.AccountID from CRE.NotePeriodicCalc npc
Inner join core.account acc on acc.accountid = npc.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid 
where AnalysisID =@ScenarioId  and n.NoteID = @NoteId and acc.AccounttypeID = 1)  
BEGIN  
	Select UpdatedBy,UpdatedDate,CalcEngineTypeText,CalculationStatus,ErrorMessage,accountingclosedate
	From(
		SELECT 
		ISNULL(npr.[UpdatedBy] ,0) as [UpdatedBy]
		,[dbo].[ufn_GetTimeByTimeZone] (npr.[UpdatedDate],@USerID ) as [UpdatedDate]
		,l.name    as CalcEngineTypeText  
		,ISNULL((CASE WHEN CRL.Name = 'SaveDBPending' THEN 'Running' ELSE CRL.Name END),'Completed') as CalculationStatus   
		,cr.ErrorMessage 
		,tbllastclose.LastCloseDate as accountingclosedate
		,ROW_NUMBER() Over (Partition BY npr.AnalysisID,npr.accountid Order by npr.AnalysisID,npr.accountid,npr.[UpdatedDate] desc) rno

		FROM CRE.NotePeriodicCalc npr   
		Inner Join cre.note n on n.Account_AccountID = npr.AccountID
		left join core.lookup l on l.lookupid = npr.CalcEngineType    
		left join Core.CalculationRequests cr on cr.AccountId = n.Account_AccountID and cr.AnalysisID =@ScenarioId  
		left join [core].[Lookup] CRL On CRL.LookUpID = CR.StatusID  
		Left Join(
			Select n.noteid,MAX(CloseDate) LastCloseDate
			from CORE.[Period] p 
			Inner Join cre.deal d on d.dealid = p.dealid
			Inner Join cre.note n on n.dealid = d.dealid
			Where p.isdeleted <> 1 and d.isdeleted <> 1
			Group by n.noteid
		)tbllastclose on tbllastclose.noteid = n.NoteID
 
 
		where n.NoteID = @NoteId
		and npr.AnalysisID =@ScenarioId
		and npr.[month] is not null
 
	)a
	where rno = 1
END  
ELSE  
BEGIN  
IF EXISTS(select AccountId from CORE.CalculationRequests where AnalysisID =@ScenarioId  and AccountId = @AccountID)  
BEGIN  
	select  null as UpdatedBy,null as UpdatedDate,l.name as CalcEngineTypeText  
	,ISNULL((CASE WHEN CRL.Name = 'SaveDBPending' THEN 'Running' ELSE CRL.Name END),'Completed') as CalculationStatus  
	,cr.ErrorMessage 
	,null as  accountingclosedate
	from Core.CalculationRequests cr  
	left join core.lookup l on l.lookupid = cr.CalcEngineType    
	left join [core].[Lookup] CRL On CRL.LookUpID = CR.StatusID  
	Where AnalysisID = @ScenarioId  and AccountId = @AccountID  
END  
ELSE  
BEGIN  
	select  null as UpdatedBy,null as UpdatedDate,null as CalcEngineTypeText,null as CalculationStatus   
END  
   
END

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  