
CREATE PROCEDURE [dbo].[usp_UpdateM61EngineCalcStatusForLiability]       
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
    
      
  IF EXISTS(Select CalculationRequestID from Core.CalculationRequestsLiability where RequestID = @RequestID)      
  BEGIN      
  Declare @analysisID UNIQUEIDENTIFIER;    
  DECLARE @ObjectID nvarchar(256);    
  
  SET @ObjectID = (Select AnalysisID from Core.CalculationRequestsLiability where RequestID = @RequestID)      
  SET @analysisID = (Select AnalysisID from Core.CalculationRequestsLiability where RequestID = @RequestID)    
    
    
  Declare @calc_statusid int;           
         
  ---INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call start');    
            
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
    
   --INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Processing');    
    
   Update Core.CalculationRequestsLiability SET [StatusID] = @calc_statusid , ErrorMessage=@ErrorMessage  ---,StartTime = getdate()    
   where RequestID = @RequestID     
      
  END      
    
  IF(@calc_statusid = 267)   --Running      
  BEGIN      
   SET @ret_status =  'Running'    
    
   --INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Running');    
    
   --Running      
   Update Core.CalculationRequestsLiability SET StartTime =getdate(),[StatusID] = @calc_statusid, ErrorMessage=@ErrorMessage     
   where RequestID = @RequestID and StartTime is null    
      
  END     
  
 IF(@calc_statusid = 266)   --Completed       
 BEGIN      
  SET @ret_status =  'Completed'      
  Update Core.CalculationRequestsLiability SET [StatusID] = 266, ErrorMessage=@ErrorMessage ,ActualCompletionTime =getdate()     ---,EndTime =getdate()
  where RequestID = @RequestID  
    
 END      
    
 IF(@calc_statusid = 265)   --Failed      
 BEGIN      
  SET @ret_status =  'Failed'    
    
  ----INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP usp_UpdateM61EngineCalcStatus call -- Failed');    
    
  --Failed      
  Update Core.CalculationRequestsLiability SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage ,ActualCompletionTime =getdate()   
  where RequestID = @RequestID     
      
  -- set all dependent note as Fail      
  IF((Select COUNT(CalculationRequestID) from Core.CalculationRequestsLiability where RequestID = @RequestID) = 1)    
  BEGIN      
   Update Core.CalculationRequestsLiability SET [StatusID] = @calc_statusid,StartTime = getdate(), EndTime = getdate()  , ErrorMessage='Excluded from the calculation as parent note failed to calculate.'    
   where  AnalysisID = @analysisID    
   and AccountId in      
   (      
    SELECT AccountId FROM Core.CalculationRequestsLiability      
    WHERE  AnalysisID = @analysisID    
    and AccountId In (
        Select Account_AccountID from cre.note where NoteID in (
            select p.StripTransferTo from CRE.PayruleSetup p  
            where p.StripTransferFrom in (
                    Select n.NoteId from Core.CalculationRequestsLiability cr Inner Join cre.note n on n.Account_AccountID = cr.AccountId where RequestID = @RequestID and AnalysisID = @analysisID and CalcType = 775
                )  
            )      
            and CalcType = 775  
        )
   )      
   and CalcType = 775    
  END      
 END      
    
   
 END    
    
 Select @ret_status as ret_status    
      
      
END
