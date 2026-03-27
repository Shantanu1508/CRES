  
-- Procedure      
--[dbo].[usp_GetNoteIDForCalcFromCalculationRequestsByServerIndex] 1   
  
CREATE PROCEDURE [dbo].[usp_GetNoteIDForCalcFromCalculationRequestsByServerIndex]       
(      
@ServerIndex int=0      
)      
AS      
BEGIN      
     SET NOCOUNT ON;       
      
  DECLARE @CalcBatch UNIQUEIDENTIFIER ;  
   
      
---Creating new temp table--------------------      
IF (OBJECT_ID('tempdb..#tblNoteIDs') IS NOT NULL)      
  BEGIN      
    DROP TABLE #tblNoteIDs      
  END      
      
CREATE TABLE #tblNoteIDs (      
 [NoteID] UNIQUEIDENTIFIER,      
 [RequestTime] datetime,      
 [CalculationRequestID] UNIQUEIDENTIFIER,      
 [UserName] nvarchar(max),      
 [IsRealTime] bit,      
 AnalysisID UNIQUEIDENTIFIER,      
 CalculationModeID [int]       
)      
  
  
  
--------------------------------------------      
       
Declare @lookupidRunning int = (SELECT LookupID from core.Lookup where Name='Running' and ParentID=40);      
Declare @lookupidProcessing int = (SELECT LookupID from core.Lookup where Name='Processing' and ParentID=40);      
Declare @lookupidFailed int = (SELECT LookupID from core.Lookup where Name='Failed' and ParentID=40);      
Declare @lookupidRealTime int = (SELECT LookupID from core.Lookup where Name='Real Time' and ParentID=42 );      
  
Declare @NumberOfRetries int = (Select top 1 [Value] from app.appconfig where [Key] = 'NumberOfCalculationRetries');   
  
  
  
----Update Status to 'Processing' if note running more than 180 min------------      
--Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate() ,NumberOfRetries = (NumberOfRetries + 1)  
--where AccountId in (  

--	SELECT distinct cr.AnalysisID,n.Account_AccountID 
--	FROM Core.CalculationRequests cr  
--	inner join cre.note n on n.Account_AccountID = cr.AccountId  
--	WHERE cr.StatusID = @lookupidRunning and datediff(minute,cr.StartTime, getdate()) > ISNULL(n.CalculationTimeInMin,15)  
--	and cr.CalcType = 775  and CalcEngineType  = 797  
--)      
--and NumberOfRetries < @NumberOfRetries  
--and CalcType = 775  
--and CalcEngineType  = 797  

Update Core.CalculationRequests set Core.CalculationRequests.[StatusID]=@lookupidProcessing
,Core.CalculationRequests.StartTime = getdate() 
,Core.CalculationRequests.NumberOfRetries = (z.NumberOfRetries + 1)
From(
	SELECT distinct cr.AnalysisID,n.Account_AccountID ,NumberOfRetries,CalcType,CalcEngineType
	FROM Core.CalculationRequests cr  
	inner join cre.note n on n.Account_AccountID = cr.AccountId  
	WHERE cr.StatusID = @lookupidRunning and datediff(minute,cr.StartTime, getdate()) > ISNULL(n.CalculationTimeInMin,15)  
	and cr.CalcType = 775  and CalcEngineType  = 797  
)z
Where Core.CalculationRequests.NumberOfRetries < @NumberOfRetries  
and Core.CalculationRequests.CalcType = z.CalcType  
and Core.CalculationRequests.CalcEngineType  = z.CalcEngineType
and Core.CalculationRequests.AccountId  = z.Account_AccountID
and Core.CalculationRequests.AnalysisID  = z.AnalysisID
----=========================================================================


----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------      
--Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate()  ,NumberOfRetries = (NumberOfRetries + 1)  
--where AccountId in (
--SELECT distinct AccountId FROM Core.CalculationRequests WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') and CalcType = 775 and CalcEngineType  = 797
--)      
--and NumberOfRetries < @NumberOfRetries  
--and CalcType = 775  and CalcEngineType  = 797  

Update Core.CalculationRequests set Core.CalculationRequests.[StatusID]=@lookupidProcessing
,Core.CalculationRequests.StartTime = getdate() 
,Core.CalculationRequests.NumberOfRetries = (z.NumberOfRetries + 1)
From(
	SELECT distinct cr.AnalysisID,n.Account_AccountID ,NumberOfRetries,CalcType,CalcEngineType
	FROM Core.CalculationRequests cr  
	inner join cre.note n on n.Account_AccountID = cr.AccountId  
	WHERE cr.StatusID = @lookupidFailed 
	and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') 
	and cr.CalcType = 775  and CalcEngineType  = 797  
)z
Where Core.CalculationRequests.NumberOfRetries < @NumberOfRetries  
and Core.CalculationRequests.CalcType = z.CalcType  
and Core.CalculationRequests.CalcEngineType  = z.CalcEngineType
and Core.CalculationRequests.AccountId  = z.Account_AccountID
and Core.CalculationRequests.AnalysisID  = z.AnalysisID
----=========================================================================



-----Note failed to calculate, forcefully closed after 3 retries
--Update Core.CalculationRequests set [StatusID]=@lookupidFailed ,  StartTime = getdate() ,EndTime = getdate(),ErrorMessage = 'Note failed to calculate, forcefully closed after 3 retries'  
--where AccountId in (  
-- --SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidRunning and datediff(minute,StartTime, getdate()) > 15   
-- SELECT distinct n.Account_AccountID FROM Core.CalculationRequests cr  
-- inner join cre.note n on n.Account_AccountID = cr.AccountId  
-- WHERE cr.StatusID = @lookupidRunning and datediff(minute,cr.StartTime, getdate()) > ISNULL(n.CalculationTimeInMin,15)  
--    and cr.CalcType = 775  and CalcEngineType  = 797  
--)      
--and NumberOfRetries = @NumberOfRetries  
--and CalcType = 775  
--and CalcEngineType  = 797

Update Core.CalculationRequests set Core.CalculationRequests.[StatusID]=@lookupidFailed
,Core.CalculationRequests.StartTime = getdate() 
,EndTime = getdate()
,ErrorMessage = 'Note failed to calculate, forcefully closed after 3 retries'  
From(
	SELECT distinct cr.AnalysisID,n.Account_AccountID ,NumberOfRetries,CalcType,CalcEngineType
	FROM Core.CalculationRequests cr  
	inner join cre.note n on n.Account_AccountID = cr.AccountId  
	WHERE  cr.StatusID = @lookupidRunning and datediff(minute,cr.StartTime, getdate()) > ISNULL(n.CalculationTimeInMin,15)  
	and cr.CalcType = 775  and CalcEngineType  = 797  
)z
Where Core.CalculationRequests.NumberOfRetries = @NumberOfRetries  
and Core.CalculationRequests.CalcType = z.CalcType  
and Core.CalculationRequests.CalcEngineType  = z.CalcEngineType
and Core.CalculationRequests.AccountId  = z.Account_AccountID
and Core.CalculationRequests.AnalysisID  = z.AnalysisID
------------------------------------------------------------------------------      
      
      
IF( (Select COUNT(AccountId) from Core.CalculationRequests with(nolock)  WHERE [StatusID]=@lookupidRunning and ServerIndex=@ServerIndex and CalcType = 775 and CalcEngineType  = 797) < 20 )      
BEGIN      
   
 -- for manage & track single script call related notes  
 SET @CalcBatch = NEWID();  
      
 TRUNCATE TABLE #tblNoteIDs  
   
 ----Select 10 Real time note and Update Status to 'Running' before send to calculater web service.  
 UPDATE Core.CalculationRequests  SET Core.CalculationRequests.StatusID = @lookupidRunning , StartTime = getdate(),ServerIndex=@ServerIndex, CalcBatch = @CalcBatch  
 WHERE CalculationRequestID IN  
 (  
 SELECT TOP 10 CalculationRequestID From Core.CalculationRequests     
 WHERE [StatusID]=@lookupidProcessing and PriorityID = @lookupidRealTime    and CalcType = 775   and CalcEngineType  = 797  
 ORDER BY RequestTime ASC      
 )  
 and CalcEngineType  = 797 
  
 ----Select Processing notes and Update Status to 'Running' before send to calculater web service.  
 UPDATE Core.CalculationRequests  SET Core.CalculationRequests.StatusID = @lookupidRunning , StartTime = getdate(),ServerIndex=@ServerIndex, CalcBatch = @CalcBatch  
 WHERE CalculationRequestID IN  
 (  
 SELECT TOP 30 CalculationRequestID From Core.CalculationRequests      
 WHERE [StatusID]=@lookupidProcessing and ( PriorityID <> @lookupidRealTime OR PriorityID IS NULL)   
 and CalcType = 775   and CalcEngineType  = 797  
 ORDER BY RequestTime ASC   
 )  
 and CalcEngineType  = 797 
  
 -- insert into #tblNoteIDs for apply join on selected notes  
 INSERT INTO #tblNoteIDs     
 SELECT n.NoteID,RequestTime,[CalculationRequestID],[UserName],1 as [IsRealTime],AnalysisID,CalculationModeID   
 From Core.CalculationRequests  cr
 Inner Join cre.note n on n.Account_AccountID = cr.AccountId
 WHERE CalcBatch = @CalcBatch and CalcType = 775  
 and CalcEngineType  = 797  
  
  
-- Select and return Notes for calc process  
Select NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,CalculationModeText        
from(      
  SELECT  NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,lClacMode.name as CalculationModeText ,[IsRealTime]      
  FROM #tblNoteIDs t        
  left join core.Lookup lClacMode on lClacMode.LookupID = t.CalculationModeID        
)a       
Order By a.IsRealTime desc        
-----------------------------------      
   
  ------------------Testing CODE for check duplicate note fetching-------------------  
-- INSERT INTO TestCalNoteIDs (NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,CalculationModeText , [IsRealTime], ServerIndex, CalcBatch , RequestTime)  
--  Select NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,CalculationModeText  , [IsRealTime]  , @ServerIndex , @CalcBatch , GETDATE()  
--from(    
--  SELECT  NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,lClacMode.name as CalculationModeText ,[IsRealTime]    
--  FROM #tblNoteIDs t      
--  left join core.Lookup lClacMode on lClacMode.LookupID = t.CalculationModeID      
--)a     
--Order By a.IsRealTime desc    
  -------------------------------------------------------  
     
      
 Update Core.BatchCalculationDetail SET       
 StatusID = @lookupidRunning,      
 StartTime=getdate()      
 from      
 (      
 SELECT distinct NoteID,AnalysisID FROM #tblNoteIDs      
 )T      
 where Core.BatchCalculationDetail.NoteID = T.NoteID and Core.BatchCalculationDetail.BatchCalculationMasterID in       
 (select BatchCalculationMasterID from Core.BatchCalculationMaster where AnalysisID=t.AnalysisID)      
 and Core.BatchCalculationDetail.StartTime is null      
      
      
 --OLD      
 --Update Status to 'Running' after send to calculater web service.      
 --Update Core.CalculationRequests set [StatusID]=@lookupidRunning , StartTime = getdate()      
 --where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidProcessing)      
      
END     
END      
      
      
---- Testing Table for check duplicate note fetching  
  
--CREATE TABLE TestCalNoteIDs (    
-- TestCalNoteID INT IDENTITY(1,1) PRIMARY KEY,  
-- [NoteID] UNIQUEIDENTIFIER,    
-- [RequestTime] datetime,    
-- [CalculationRequestID] UNIQUEIDENTIFIER,    
-- [UserName] nvarchar(max),    
-- [IsRealTime] bit,    
-- AnalysisID UNIQUEIDENTIFIER,    
-- CalculationModeID [int] ,  
-- CalculationModeText VARCHAR(1000),  
-- ServerIndex int,  
-- CalcBatch  UNIQUEIDENTIFIER NULL  
--)       