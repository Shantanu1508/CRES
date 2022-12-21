--[usp_GetAllSchedulerConfig] 0
CREATE PROCEDURE [dbo].[usp_GetAllSchedulerConfig]
 @UserID nvarchar(256),
 @Status int,
 @GroupID int,
 @ConfigFor varchar(50)
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    --Status 1-active ,2-inactive from lookup,0-return both active and inactive
	if (@ConfigFor='Scheduler')
	BEGIN
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
		where (([Status]= @Status and @Status<>0) or  @Status=0)
		and  ((GroupID= @GroupID and @GroupID<>0) or  @GroupID=0)
		and FailureCount<5
		and isnull([JobStatus],'Success') not in ('Running')
		and (([NextexecutionTime]<=getdate() and @Status<>0) or  @Status=0)
		order by ISNULL(SortOrder,0),CreatedDate
	END
	ELSE 
	BEGIN
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
		order by ISNULL(SortOrder,0),CreatedDate
	END
	
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
