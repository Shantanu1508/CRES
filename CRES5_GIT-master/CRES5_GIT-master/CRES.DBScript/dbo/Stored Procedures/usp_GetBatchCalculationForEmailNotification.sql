CREATE PROCEDURE [dbo].[usp_GetBatchCalculationForEmailNotification] 
	@UserID nvarchar(256)
AS
BEGIN

declare @tBatchCalculationMaster table
(
	[BatchCalculationMasterID] int,
	[BatchCalculationMasterGUID] uniqueidentifier,
	[AnalysisID] [uniqueidentifier] ,
	[Name] [varchar](50),
	[StartTime] [datetime] ,
	[EndTime] [datetime] ,
	[Total] [int] ,
	[TotalCompleted] [int] ,
	[TotalFailed] [int] ,
	[BatchType] [varchar](50) ,
	[UserID] [uniqueidentifier] ,
	[Status] [varchar](50)
)

insert into @tBatchCalculationMaster 
SELECT [BatchCalculationMasterID]
      ,[BatchCalculationMasterGUID]
      ,a.[AnalysisID]
	  ,a.[Name]
      ,[StartTime]
      ,[EndTime]
      ,[Total]
      ,[TotalCompleted]
      ,[TotalFailed]
      ,[BatchType]
      ,[UserID]
      ,[Status]
  FROM [Core].[BatchCalculationMaster] b left join core.Analysis a
  on b.AnalysisID = a.AnalysisID
  WHERE [BatchType] in ('AllWithTag','All') and [Status]='Completed'
  ORDER BY StartTime DESC

  Update [Core].[BatchCalculationMaster] SET [Status]='EmailSent' where BatchCalculationMasterID in 
  (
    select BatchCalculationMasterID from @tBatchCalculationMaster
  )

SELECT [BatchCalculationMasterID]
      ,[BatchCalculationMasterGUID]
      ,[AnalysisID]
	  ,[Name]
      ,[StartTime]
      ,[EndTime]
      ,[Total]
      ,[TotalCompleted]
      ,[TotalFailed]
      ,[BatchType]
      ,b.[UserID]
	  ,u.Email
	  ,u.FirstName+ ' '+u.LastName as UserName
      ,'00000000-0000-0000-0000-000000000000' as DealID
      ,[Status] from @tBatchCalculationMaster b left join app.[User] u on b.UserID=u.UserID

END
