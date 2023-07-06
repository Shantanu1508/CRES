
--[usp_GetSchedulerConfigByID] '',1
CREATE PROCEDURE [dbo].[usp_GetSchedulerConfigByID]
 @UserID nvarchar(256),
 @SchedulerConfigID int
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    --Status 1-active ,2-inactive from lookup,0-return both active and inactive
	SELECT 
	[SchedulerConfigID]
	,[SchedulerName]
	,[APIname] 
	,[Description] 
	,[ObjectTypeID]
	,[ObjectID]
	,[ExecutionTime]
	,[NextexecutionTime]
	,[Frequency]
	,[Status]
	,[JobStatus]
	,[IsEnableDayLightSaving]
	,[Timezone]
	,[FailureCount]
	,[GroupID] 
	,[ServerIndex]
	,[SortOrder]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	FROM App.SchedulerConfig
	where [SchedulerConfigID]=@SchedulerConfigID
	and isnull([JobStatus],'Success') not in ('Running')
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
