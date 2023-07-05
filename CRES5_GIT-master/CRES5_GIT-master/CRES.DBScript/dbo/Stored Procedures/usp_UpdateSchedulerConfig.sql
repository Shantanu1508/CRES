
CREATE PROCEDURE [DBO].[usp_UpdateSchedulerConfig] 
(
	@UserID nvarchar(256),
	@SchedulerConfigID int,
	@JobStatus nvarchar(50),
	@RunBy nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	 --Frequency
	 --Hourly,Daily,Weekly,Monthly
	 --@RunBy
	 --System,Manual
	  Declare @Frequency nvarchar(100),@ExecutionTime nvarchar(50),@NextExecutionTime datetime,@NewExecutionTime datetime,@FailureCount int,@currDate datetime
	  select @Frequency = Frequency,@ExecutionTime=ExecutionTime,@NextExecutionTime=ISNULL(NextExecutionTime,getdate()),@FailureCount=isnull(FailureCount,0) from  [App].[SchedulerConfig] where SchedulerConfigID=@SchedulerConfigID
	  if (CONVERT(DATE, @NextExecutionTime) = '1900-01-01')
	  BEGIN
		SET @NextExecutionTime = getdate()
	  END

	  SET @NewExecutionTime = @NextExecutionTime
	  --JobStatus 
	 --Success,Failed, Running
	 
	 --update next execution time based on frequency
	 if (@JobStatus='Success' and @RunBy<>'Manual')
	 BEGIN
	      SET @currDate = getdate()
		  IF(@Frequency='Hourly')
		    BEGIN
				SET @NewExecutionTime = Dateadd(HOUR,1,@currDate)
				SET @ExecutionTime= Format(@currDate,'hh:mm tt')
			END
		 ELSE IF(@Frequency='Daily')
		    BEGIN
				SET @NewExecutionTime = Dateadd(DAY,1,@currDate)
				SET @NewExecutionTime = cast(convert(varchar(10),@NewExecutionTime, 101) + ' '+@ExecutionTime as datetime)
			END
		 ELSE IF (@Frequency='Weekly')
		    BEGIN
			    SET @NewExecutionTime = Dateadd(WEEK,1,@currDate)
				SET @NewExecutionTime = cast(convert(varchar(10),@NewExecutionTime, 101) + ' '+@ExecutionTime as datetime)
			END
		ELSE IF (@Frequency='Monthly')
		    BEGIN
				SET @NewExecutionTime = Dateadd(MONTH,1,@currDate)
				SET @NewExecutionTime = cast(convert(varchar(10),@NewExecutionTime, 101) + ' '+@ExecutionTime as datetime)
			END
	 
	 END
	 ELSE if (@JobStatus='Failed')
	 BEGIN
		--if failed set next excution time 35 minutes ahead so it can run again
		SET @FailureCount+=1
		SET @NewExecutionTime = Dateadd(minute,35,@currDate)
	 END
	UPDATE [App].[SchedulerConfig] Set [JobStatus] = @JobStatus,NextExecutionTime = @NewExecutionTime,FailureCount=@FailureCount,ExecutionTime=@ExecutionTime where SchedulerConfigID=@SchedulerConfigID
END
