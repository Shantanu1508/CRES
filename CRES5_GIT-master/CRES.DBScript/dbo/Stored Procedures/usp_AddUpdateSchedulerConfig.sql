
CREATE PROCEDURE [DBO].[usp_AddUpdateSchedulerConfig] 
(
	@UserID nvarchar(256),
	@XMLSchedulerConfig XML
)
AS
BEGIN
	SET NOCOUNT ON;
 declare @tSchedulerConfig table
  (
	[SchedulerConfigID] [int] NULL,
	[SchedulerName] nvarchar(256) null,
	[APIname] nvarchar(500) null,
	[Description] nvarchar(max) null,
	[ObjectTypeID] nvarchar(256) null,
	[ObjectID] int null,
	[ExecutionTime] nvarchar(50),
	[NextexecutionTime] datetime null,
	[Frequency] nvarchar(256) null,
	[Status] int default 0,
	[JobStatus] nvarchar(256) null,
	[IsEnableDayLightSaving] int null,
	[Timezone] nvarchar(256) null,
	[FailureCount] int null

	)
 declare @tSchedulerConfigToBeUpdate table
  (
      ID int identity(1,1),
	 [SchedulerConfigID] [int]
  )
  declare @tSchedulerConfigToBeInsert table
  (
      ID int identity(1,1),
	 [SchedulerConfigID] [int]
  )
 declare @CurrCount int = 1,@tempScheduleConfigID int,@TotalCountUpdate int,@TotalCountinsert int
	
	INSERT INTO @tSchedulerConfig 
		SELECT 
		 Pers.value('(SchedulerConfigID)[1]', 'int')
		,Pers.value('(SchedulerName)[1]', 'nvarchar(256)')
		,Pers.value('(APIname)[1]', 'nvarchar(256)')
		,Pers.value('(Description)[1]', 'nvarchar(max)')
		,nullif(Pers.value('(ObjectTypeID)[1]', 'nvarchar(256)'),'')
		,nullif(Pers.value('(ObjectID)[1]', 'int'),0)
		,Pers.value('(ExecutionTime)[1]', 'nvarchar(256)')
		,nullif(CONVERT(DATE, Pers.value('(NextexecutionTime)[1]', 'datetime')), '1900-01-01')
		,Pers.value('(Frequency)[1]', 'nvarchar(256)')
		,Pers.value('(Status)[1]', 'int')
		,Pers.value('(JobStatus)[1]', 'nvarchar(256)')
		,Pers.value('(IsEnableDayLightSaving)[1]', 'int')
		,Pers.value('(Timezone)[1]', 'nvarchar(256)')
		,Pers.value('(FailureCount)[1]', 'int')

	FROM @XMLSchedulerConfig.nodes('/ArrayOfSchedulerConfigDataContract/SchedulerConfigDataContract') as t(Pers)
	--find out rows needs to be update
	insert into @tSchedulerConfigToBeUpdate
	select SchedulerConfigID from 
	(
	select SchedulerConfigID,SchedulerName,APIname,ExecutionTime,Frequency,[Status] from @tSchedulerConfig
	EXCEPT
	select SchedulerConfigID,SchedulerName,APIname,ExecutionTime,Frequency,[Status] from app.SchedulerConfig
	) as tbl
	
	
	
	--update config table
	update app.SchedulerConfig 
	set SchedulerName = tblupdate.SchedulerName,APIname=tblupdate.APIname,ExecutionTime=tblupdate.ExecutionTime
	,Frequency=tblupdate.Frequency,[Status]=tblupdate.[Status],UpdatedDate=getdate()
	from
	(
	 select su.SchedulerConfigID,SchedulerName,APIname,ExecutionTime,Frequency,[Status] from @tSchedulerConfig  sc join @tSchedulerConfigToBeUpdate su on 
	 sc.SchedulerConfigID =su.SchedulerConfigID
	) tblupdate
	where app.SchedulerConfig.SchedulerConfigID=tblupdate.SchedulerConfigID
	
	--update next execution time
	SELECT @TotalCountUpdate = count(1) from @tSchedulerConfigToBeUpdate
	WHILE (@CurrCount<=@TotalCountUpdate)
	 BEGIN
		select @tempScheduleConfigID=SchedulerConfigID from @tSchedulerConfigToBeUpdate where ID=@CurrCount
			
			exec [usp_UpdateSchedulerConfig] '',@tempScheduleConfigID,'Success',''
		SET @CurrCount+=1
	END
	--insert new config
	INSERT INTO App.SchedulerConfig
	(
	[SchedulerName],
	[APIname],
	[Description],
	[ObjectTypeID],
	[ObjectID],
	[ExecutionTime],
	[NextexecutionTime],
	[Frequency],
	[Status],
	[JobStatus],
	[IsEnableDayLightSaving],
	[Timezone],
	[FailureCount],
	CreatedBy,
    CreatedDate,
    UpdatedBy,
    UpdatedDate
	)
	OUTPUT inserted.SchedulerConfigID INTO @tSchedulerConfigToBeInsert(SchedulerConfigID)
	select 
	[SchedulerName],
	[APIname],
	[Description],
	[ObjectTypeID],
	[ObjectID],
	[ExecutionTime],
	[NextexecutionTime],
	[Frequency],
	[Status],
	[JobStatus],
	[IsEnableDayLightSaving],
	[Timezone],
	[FailureCount],
	'System',
    getdate(),
    'System',
    getdate()
	from @tSchedulerConfig where (SchedulerConfigID=0 or SchedulerConfigID=null)

	
	--update next execution time for newly added rows
	set @CurrCount=1
	SELECT @TotalCountinsert = count(1) from @tSchedulerConfigToBeInsert
	WHILE (@CurrCount<=@TotalCountinsert)
	 BEGIN
		select @tempScheduleConfigID=SchedulerConfigID from @tSchedulerConfigToBeInsert where ID=@CurrCount
			exec [usp_UpdateSchedulerConfig] '',@tempScheduleConfigID,'Success'
		SET @CurrCount+=1
	END
END
