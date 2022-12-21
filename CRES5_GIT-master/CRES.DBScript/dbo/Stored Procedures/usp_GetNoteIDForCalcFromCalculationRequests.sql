



-- Procedure
CREATE PROCEDURE [dbo].[usp_GetNoteIDForCalcFromCalculationRequests] 
AS
BEGIN
     SET NOCOUNT ON; 



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

----Update Status to 'Processing' if note running more than 180 min------------
Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate()
where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidRunning and datediff(minute,StartTime, getdate()) > 180 and CalcType = 775 )
and CalcType = 775

----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------
Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate()
where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') and CalcType = 775 )
and CalcType = 775
------------------------------------------------------------------------------


IF( (Select COUNT(NoteID) from Core.CalculationRequests with(nolock)  WHERE [StatusID]=@lookupidRunning and CalcType = 775) < 20)
BEGIN



 --INSERT Top 30 notes into temp table
 TRUNCATE TABLE #tblNoteIDs

 INSERT INTO #tblNoteIDs
 SELECT NoteID,RequestTime,[CalculationRequestID],[UserName],1 as [IsRealTime],AnalysisID,ISNULL(CalculationModeID,507) CalculationModeID From Core.CalculationRequests
 WHERE [StatusID]=@lookupidProcessing and PriorityID = @lookupidRealTime and CalcType = 775
 ORDER BY RequestTime ASC

 INSERT INTO #tblNoteIDs
 SELECT TOP 30 NoteID,RequestTime,[CalculationRequestID],[UserName],0 as [IsRealTime],AnalysisID,ISNULL(CalculationModeID,507) CalculationModeID From Core.CalculationRequests
 WHERE [StatusID]=@lookupidProcessing and PriorityID <> @lookupidRealTime and CalcType = 775
 ORDER BY RequestTime ASC
---------------------------------------

--Send all 'Processing' note to calculater web service.
Select NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,CalculationModeText
From(
	 SELECT Distinct TOP 30 NoteID,CalculationRequestID,UserName,AnalysisID,CalculationModeID ,lClacMode.name as CalculationModeText,[IsRealTime]
	 FROM #tblNoteIDs t
	 left join core.Lookup lClacMode on lClacMode.LookupID = t.CalculationModeID
	 
 )a
 Order By a.IsRealTime desc   
-----------------------------------

 ----Update Status to 'Running' after send to calculater web service.
 --Update Core.CalculationRequests set [StatusID]=@lookupidRunning , StartTime = getdate()
 --where NoteID in (SELECT distinct NoteID FROM #tblNoteIDs)

  --Update Status to 'Running' after send to calculater web service.
 Update Core.CalculationRequests  SET  Core.CalculationRequests.StatusID = @lookupidRunning , StartTime = getdate()
 from
 (
	SELECT distinct NoteID,AnalysisID FROM #tblNoteIDs
 )T
 where Core.CalculationRequests.NoteID = T.NoteID and Core.CalculationRequests.AnalysisID = T.AnalysisID
 and Core.CalculationRequests.CalcType = 775


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


---- set Note: 5167, 5168 status as failed
--IF EXISTS(select NoteID from Core.CalculationRequests where NoteID = 'EE207C93-06FF-42AA-93EA-5785B1343E47'  )	
--	begin
--		UPDATE  Core.CalculationRequests SET StatusID = 265, ErrorMessage = 'Calculation failed due to- Value was either too large or too small for a Decimal.'  WHERE NoteID = 'EE207C93-06FF-42AA-93EA-5785B1343E47' ;			
--	end 

--IF EXISTS(select NoteID from Core.CalculationRequests where NoteID = '9A8AD8E1-0166-4D7E-AABD-EE2F4FAE5B74'  )	
--	begin
--		UPDATE  Core.CalculationRequests SET StatusID = 265 , ErrorMessage = 'Calculation failed due to- Value was either too large or too small for a Decimal.'  WHERE NoteID = '9A8AD8E1-0166-4D7E-AABD-EE2F4FAE5B74' ;			
--	end 

--IF EXISTS(select NoteID from Core.CalculationRequests where NoteID = '25BF3FC6-353A-44C2-A36D-3DDF0F2303CF'  )	
--	begin
--		UPDATE  Core.CalculationRequests SET StatusID = 265 , ErrorMessage = 'Calculation failed due to- Value was either too large or too small for a Decimal.' WHERE NoteID = '25BF3FC6-353A-44C2-A36D-3DDF0F2303CF' ;			
--	end 




END



