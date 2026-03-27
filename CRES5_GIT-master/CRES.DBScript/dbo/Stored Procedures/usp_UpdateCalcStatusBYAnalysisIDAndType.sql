  
CREATE PROCEDURE [dbo].[usp_UpdateCalcStatusBYAnalysisIDAndType]  -- 'c10f3372-0fc2-4861-a9f5-148f1f80804f','Pause'  
(  
	@AnalysisID UNIQUEIDENTIFIER,  
	@Type nvarchar(100),
	@CreatedBy NVARCHAR(256)
)   
AS  
BEGIN   
    
	if(@Type='Pause')  
	BEGIN        
		INSERT INTO [CORE].[CalculationRequests_Hold] (NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalculationModeID,[CalcType])    
		Select NoteId,'Processing',UserName,lApplication.[Name],lPriority.[Name],AnalysisID as AnalysisID,CalculationModeID,775 from Core.CalculationRequests CR 
		INNER JOIN Cre.Note N ON N.Account_AccountID = CR.AccountID
		left join core.Lookup lPriority on cr.PriorityID =lPriority.LookupID
		left join core.Lookup lApplication on cr.ApplicationID =lApplication.LookupID     
		where CR.AnalysisId = @AnalysisID and (CR.StatusID in (292,735,326) OR (CR.StatusID in (267) and CR.CalcEngineType=798))
	
		/*update  Core.CalculationRequests   
			set StatusID =899  
			where analysisid =@AnalysisID  and StatusID in (292,735)  		

			-- Dependents status
		  update  Core.CalculationRequests   
			set StatusID =900  
			where analysisid =@AnalysisID  and StatusID in (326)  	

			  update  Core.CalculationRequests   
			set StatusID =736  
			where analysisid =@AnalysisID  and StatusID in (267) and CalcEngineType=798
		*/
		Delete From  Core.CalculationRequests where analysisid =@AnalysisID  and (StatusID in (292,735,326) OR (StatusID in (267) and CalcEngineType=798))
	END  
  
	if(@Type='Resume')  
	BEGIN    
		
		Declare @TableTypeCalculationRequests_new TableTypeCalculationRequests
    
		Delete from @TableTypeCalculationRequests_new    
		
		INSERT INTO @TableTypeCalculationRequests_new (NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalculationModeID,[CalcType])    
		
		SELECT CRH.NoteId,CRH.StatusText,CRH.UserName,CRH.ApplicationText,CRH.PriorityText,CRH.AnalysisID,CRH.CalculationModeID,CRH.CalcType 
		FROM [CORE].[CalculationRequests_Hold] CRH WHERE analysisid =@AnalysisID

		UNION
		--Insert child note if not in calculation request table    
		SELECT DISTINCT StripTransferFrom,CRH.StatusText,CRH.UserName,CRH.ApplicationText,CRH.PriorityText,CRH.AnalysisID,CRH.CalculationModeID,CRH.CalcType
		FROM CRE.PayruleSetup ps INNER JOIN [CORE].[CalculationRequests_Hold] CRH on CRH.noteid = ps.StripTransferTo WHERE analysisid = @AnalysisID
		
		Exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests_new,@CreatedBy,@CreatedBy

		/*update  Core.CalculationRequests   
		set StatusID =292  
		where analysisid =@AnalysisID  
		and StatusID in (899,736)    

		-- Dependents status
		update  Core.CalculationRequests   
		set StatusID =326  
		where analysisid =@AnalysisID  
		and StatusID in (900)  
		*/

		Delete from [CORE].[CalculationRequests_Hold] where analysisId = @AnalysisID
	END  

	if(@Type='Cancel')  
	BEGIN    
		Delete From  Core.CalculationRequests where analysisid =@AnalysisID  		
	END 
  
END  
  
