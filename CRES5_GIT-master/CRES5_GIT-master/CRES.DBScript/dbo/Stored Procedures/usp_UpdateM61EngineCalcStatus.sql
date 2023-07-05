-- Procedure  
-- Procedure  
--[dbo].[usp_UpdateM61EngineCalcStatus]   'c2815a87f2e0415f87d93fdd0bd9a636',2,''  
  
  
CREATE PROCEDURE [dbo].[usp_UpdateM61EngineCalcStatus]     
(        
  @RequestID nvarchar(256),    
  @Status int,    
  @ErrorMessage nvarchar(MAX)    
)        
         
AS        
BEGIN        
      
SET NOCOUNT ON;        
    
	Declare @ret_status nvarchar(256);  
	SET @ret_status =  'RequestID_not_exists'  
  
    
	 IF EXISTS(Select CalculationRequestID from Core.CalculationRequests where RequestID = @RequestID)    
	 BEGIN    
		Declare @analysisID UNIQUEIDENTIFIER;  
		DECLARE @ObjectID nvarchar(256);  

		SET @ObjectID = (Select AnalysisID from Core.CalculationRequests where RequestID = @RequestID)    
		SET @analysisID = (Select AnalysisID from Core.CalculationRequests where RequestID = @RequestID)  
  
  
		Declare @calc_statusid int;         
       
		INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call start');  
          
		--Failed= -2, -1    
		--Completed = 2    
		--Running = 1    
		--Processing = 0    
		--Dependents = ??    
  
    
  
		--Failed    
		IF(@Status < 0)    
		BEGIN       
			SET @calc_statusid = 265    
		END    
    
		--Completed    
		IF(@Status = 2)    
		BEGIN  
			SET @calc_statusid = 266    
		END    
    
		--Running    
		IF(@Status = 1)    
		BEGIN   
			SET @calc_statusid = 267    
		END    
     
		--Processing    
		IF(@Status = 0)    
		BEGIN   
			SET @calc_statusid = 292    
		END    
     
		----Dependents    
		--IF(@Status = 5)    
		--BEGIN    
			-- SET @calc_statusid = 326    
		--END    
     
		IF(@calc_statusid = 292)    --Processing    
		BEGIN    
			SET @ret_status =  'Processing'  
  
			INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Processing');  
  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid , ErrorMessage=@ErrorMessage  ---,StartTime = getdate()  
			where RequestID = @RequestID   
    
		END    
  
		IF(@calc_statusid = 267)   --Running    
		BEGIN    
			SET @ret_status =  'Running'  
  
			INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Running');  
  
			--Running    
			Update Core.CalculationRequests SET StartTime =getdate(),[StatusID] = @calc_statusid, ErrorMessage=@ErrorMessage   
			where RequestID = @RequestID and StartTime is null  
    
		END   

	IF(@calc_statusid = 266)   --Completed     
	BEGIN    
		SET @ret_status =  'Completed'  
  
		INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Completed');  
  
		--Completed    
		Update Core.CalculationRequests SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage   
		where RequestID = @RequestID   
  
		
		/*
			commented for stripping issue in child note 
			now setting all dependent note as Processing in "usp_InsertUpdatePayruleDistributions_v1" script
		*/

		--DECLARE @PriorityID INT  
		--SELECT  @PriorityID =  PriorityID FROM Core.CalculationRequests   
		--where RequestID = @RequestID   
  
		---- set all dependent note as Processing    
		--IF((Select COUNT(CalculationRequestID) from Core.CalculationRequests where RequestID = @RequestID) = 1)  
		--BEGIN    
		--	SET @ret_status = @ret_status +'_UpdateDependent';  
  
		--	Update Core.CalculationRequests SET [StatusID] = 292 ,StartTime = null,Endtime = null , PriorityID = @PriorityID  
		--	where  AnalysisID = @analysisID  
		--	and noteid in (    
		--		SELECT NoteId FROM CORE.CalculationRequests    
		--		WHERE AnalysisID = @analysisID  
		--		and NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom in (Select NoteId from Core.CalculationRequests where RequestID = @RequestID and AnalysisID = @analysisID and CalcType = 775) )  
		--		and [StatusID] = 326  
		--		and CalcType = 775         
		--	)    
		--	and CalcType = 775        
		--END   
		 
	END    
  
	IF(@calc_statusid = 265)   --Failed    
	BEGIN    
		SET @ret_status =  'Failed'  
  
		INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Failed');  
  
		--Failed    
		Update Core.CalculationRequests SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage   
		where RequestID = @RequestID   
    
		-- set all dependent note as Fail    
		IF((Select COUNT(CalculationRequestID) from Core.CalculationRequests where RequestID = @RequestID) = 1)  
		BEGIN    
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,StartTime = getdate(), EndTime = getdate()  , ErrorMessage=@ErrorMessage  
			where  AnalysisID = @analysisID  
			and noteid in    
			(    
				SELECT NoteId FROM CORE.CalculationRequests    
				WHERE  AnalysisID = @analysisID  
				and NoteId In (select p.StripTransferTo from CRE.PayruleSetup p  where p.StripTransferFrom in (Select NoteId from Core.CalculationRequests where RequestID = @RequestID and AnalysisID = @analysisID and CalcType = 775)  )    
				and CalcType = 775         
			)    
			and CalcType = 775  
		END    
	END    
  
 
	END  
  
	Select @ret_status as ret_status  
    
    
END  