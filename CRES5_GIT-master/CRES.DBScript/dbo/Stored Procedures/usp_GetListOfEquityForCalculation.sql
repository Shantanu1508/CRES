CREATE PROCEDURE [dbo].[usp_GetListOfEquityForCalculation]    
       
AS          
BEGIN          
 SET NOCOUNT ON;          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
  
 Declare @countMax int = 20   ;  
 --Declare @Running int = (select COUNT(*) from Core.AutomationRequests where StatusID=267 and AutomationType = 853);  
 Declare @Running int = (select COUNT(*) from Core.CalculationRequestsLiability where StatusID=267)       
 
  
 Declare @count int = 0;  
 set @count = @countMax-@Running;  
      

 --Select top (@count) * from  Core.AutomationRequests  where  StatusID =292 

 
 SELECT top (@count) [CalculationRequestID]
      ,[RequestTime]
      ,[StatusID]
      ,[UserName]
      ,[ApplicationID]
      ,[StartTime]
      ,[EndTime]
      ,[ServerName]
      ,[PriorityID]
      ,[ErrorMessage]
      ,[ErrorDetails]
      ,[ServerIndex]
      ,[AnalysisID]
      ,[CalculationModeID]
      ,[CalcBatch]
      ,[NumberOfRetries]
      ,[DealID]
      ,[RequestID]
      ,[CalcType]
      ,[CalcEngineType]
      ,[jsonpicktime]
      ,[RequestID_Time]
      ,[ActualCompletionTime]
      ,[AccountId]
      ,[UseActuals]
      ,[RequestFrom]
  FROM [Core].[CalculationRequestsLiability]
  WHERE  StatusID =292 



          
  
          
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
END 