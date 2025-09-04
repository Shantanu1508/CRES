CREATE PROCEDURE [dbo].[usp_GetBatchCalculationMasterByAnalysisID] 
    @AnalysisID UNIQUEIDENTIFIER,
	@UserID nvarchar(256)
AS
BEGIN
declare @StartTime datetime
SELECT top 1 @StartTime=[StartTime]
  FROM [Core].[BatchCalculationMaster] b left join core.Analysis a
  on b.AnalysisID = a.AnalysisID
  left join app.[User] u on b.UserID=u.UserID
  WHERE ((a.AnalysisID=@AnalysisID and @AnalysisID <> '00000000-0000-0000-0000-000000000000' and @AnalysisID is not null)
  or (@AnalysisID ='00000000-0000-0000-0000-000000000000' or @AnalysisID is null))
  --and [Status]='Completed' or [Status]='EmailSent' and EndTime is not null
  ORDER BY StartTime DESC
  
  SET @StartTime=DATEADD(d,-7,@StartTime)

SELECT [BatchCalculationMasterID]
      ,[BatchCalculationMasterGUID]
      ,a.[AnalysisID]
	  ,a.[Name]
      ,[StartTime]
      ,[EndTime]
      ,[Total]
      ,[TotalCompleted]
	  ,[TotalCanceled]
      ,[TotalFailed]
      ,[BatchType]
      ,b.[UserID]
      ,[Status]
	  ,u.FirstName+ ' '+u.LastName as UserName
  FROM [Core].[BatchCalculationMaster] b left join core.Analysis a
  on b.AnalysisID = a.AnalysisID
  left join app.[User] u on b.UserID=u.UserID
  WHERE ((a.AnalysisID=@AnalysisID and @AnalysisID <> '00000000-0000-0000-0000-000000000000' and @AnalysisID is not null)
  or (@AnalysisID ='00000000-0000-0000-0000-000000000000' or @AnalysisID is null))
  --and [Status]='Completed' or [Status]='EmailSent' and EndTime is not null
  --and cast([StartTime] as date)>=cast(DATEADD(d,-1,[StartTime]) as date)
  and cast([StartTime] as date)>=cast(@StartTime as date)
  ORDER BY StartTime DESC
END
