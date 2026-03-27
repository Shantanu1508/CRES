CREATE PROCEDURE [dbo].[usp_ImportNoteCommitmentfromBackshop]  
AS    
BEGIN    
    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--Declare @LastBatchDate date = (Select CAST(MAX(updatedDate) as date) from [CRE].[NoteCommitment_BS])	
	--Declare @DateDiff_day int = (Select DateDiff(day,@LastBatchDate,CAST(getdate() as date)))

	--IF(@DateDiff_day >= 7)
	--BEGIN
	--	Print('Import Weekly')
	--END
	--ELSE
	--BEGIN
	--	Print('Ignore')
	--	return;
	--END


	Declare @query1 nvarchar(256);
	Declare @query2 nvarchar(max);
	Declare @Finalquery nvarchar(max);

	SET @query1 = N'DECLARE @StartDateTime DATETIME
	DECLARE @EndDateTime DATETIME
	SET @StartDateTime = ''1/1/2015''
	SET @EndDateTime = (DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 4, -1));'

	SET @query2 = N'
	Declare @tblCalendar_Daily as table (DateData Date)
	;WITH DateRange(DateData) AS (
		SELECT @StartDateTime as Date
		UNION ALL
		SELECT DATEADD(d,1,DateData)
		FROM DateRange 
		WHERE DateData < @EndDateTime)

	INSERT INTO @tblCalendar_Daily(DateData)
	SELECT DISTINCT (DateData) DateData  FROM DateRange
	OPTION (MAXRECURSION 0)

	Declare @tblCalendar as table ([Date] Date)
	
	INSERT INTO @tblCalendar ([Date])
	Select DateData 
	From(
		SELECT DISTINCT EOMONTH(DateData) DateData  FROM @tblCalendar_Daily 
		where EOMONTH(DateData) <> EOMONTH(getdate())
		UNION
		SELECT DISTINCT (DateData) DateData FROM @tblCalendar_Daily 
		where DateData >= DATEADD(day,1,EOMONTH(DATEADD(month,-1,GETDATE()))) and DateData <= EOMONTH(getdate())
	)a	

	Declare @tblNoteCommitment_BS as table
	(
		[NoteID]        NVARCHAR (256) NOT NULL,
		[Date]			date NULL,
		[AdjustedCommitment]      decimal(28,15) NULL	
	)
	Declare @dt date 
	IF CURSOR_STATUS(''global'',''Cursordt'')>=-1
	BEGIN
		DEALLOCATE Cursordt
	END
	DECLARE Cursordt CURSOR 
	for(
		Select [Date] from @tblCalendar
	)
	OPEN Cursordt 
	FETCH NEXT FROM Cursordt
	INTO @dt
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @tblNoteCommitment_BS ([NoteID],[Date],[AdjustedCommitment])
		select noteid,@dt as [date],(CASE WHEN [AdjustedCommitment] > 2000000000 THEN 0 ELSE [AdjustedCommitment] END) as AdjustedCommitment 
		from acore.udfCurrentTotalCommitmentGet(@dt,1)					 
	FETCH NEXT FROM Cursordt
	INTO @dt
	END
	CLOSE Cursordt   
	DEALLOCATE Cursordt

	select nt.[NoteID],nt.[Date],nt.[AdjustedCommitment] from @tblNoteCommitment_BS nt
	Inner join (
		SELECT noteid,EOMONTH([AuditAddDate]) EOD_AuditAddDate FROM dbo.tblnote
	)n on n.noteid = nt.noteid
	where nt.[Date] >= n.EOD_AuditAddDate
	'

	IF EXISTS(Select top 1 CRENoteID from [CRE].[NoteCommitment_BS])
	BEGIN
		Declare @max_dt date
		SET @max_dt = (Select DATEADD(year,-1, DATEADD(day,1,EOMONTH(DATEADD(month,-1,GETDATE()))) ) ) 
		
		----(Select DATEADD(day,1,EOMONTH(DATEADD(month,-1,GETDATE()))) ) 
		---- (Select MAX(Date) from [CRE].[NoteCommitment_BS])
	
		SET @query1 = N'DECLARE @StartDateTime DATETIME
		DECLARE @EndDateTime DATETIME
		SET @StartDateTime = '''+CAST(@max_dt as nvarchar(256))+'''
		SET @EndDateTime = (DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 4, -1));'

		Delete from [CRE].[NoteCommitment_BS] where [Date] >= @max_dt
	END


	SET @Finalquery = @query1 + @query2
	---print @Finalquery


	Declare @tblNoteCommitment_BS as table
	(
		[NoteID]        NVARCHAR (256) NOT NULL,
		[Date]			date NULL,
		[AdjustedCommitment]      decimal(28,15) NULL,
		ShardName nvarchar(256) null
	)

	INSERT INTO @tblNoteCommitment_BS ([NoteID],[Date],[AdjustedCommitment],ShardName)	
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @Finalquery


	INSERT INTO [CRE].[NoteCommitment_BS] ([CRENoteID],[Date],[AdjustedCommitment], [CreatedBy],[CreatedDate],[UpdatedBy] ,[UpdatedDate])	
	Select [NoteID],[Date],[AdjustedCommitment]
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as [CreatedBy],getdate() as [CreatedDate],'B0E6697B-3534-4C09-BE0A-04473401AB93' as [UpdatedBy] ,getdate() as [UpdatedDate]
	from @tblNoteCommitment_BS



	Delete From [CRE].[NoteCommitment_BS] where NoteCommitment_BSID in (
		select NoteCommitment_BSID  ---,[Date]--,EOMONTH([Date]) as date_EOMONTH,Datediff(day,[Date],EOMONTH([Date]))
		from [CRE].[NoteCommitment_BS] 
		where date < dateadd(day,1,EOMonth(Dateadd(month,-1,getdate()))) 
		and Datediff(day,[Date],EOMONTH([Date])) <> 0
		--and crenoteid = '2230'
	)




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
