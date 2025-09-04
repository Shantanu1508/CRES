--[dbo].[usp_InsertUpdateMissingIndexList] '80DF3B15-8E57-4A13-94BE-C10489461A89',777,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
--[dbo].[usp_InsertUpdateMissingIndexList] '80DF3B15-8E57-4A13-94BE-C10489461A89',837,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
--[dbo].[usp_InsertUpdateMissingIndexList] '80DF3B15-8E57-4A13-94BE-C10489461A89',838,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
CREATE PROCEDURE [dbo].[usp_InsertUpdateMissingIndexList] 
(
	@IndexesMasterGuid UNIQUEIDENTIFIER,
	@IndexTypeID int,
	@UserID nvarchar(256)
)
AS
BEGIN

	SET NOCOUNT ON;

IF((Select DATENAME(WEEKDAY,Getdate())) = 'Wednesday')
BEGIN

	IF OBJECT_ID('tempdb..#temp_DateRange') IS NOT NULL         
		DROP TABLE #temp_DateRange


	DECLARE @StartDateTime DATE
	DECLARE @EndDateTime DATE

	SET @StartDateTime = '2023-08-01'
	SET @EndDateTime = getdate()-1;

	WITH DateRange(DateData) AS 
	(
		SELECT @StartDateTime as Date
		UNION ALL
		SELECT DATEADD(d,1,DateData)
		FROM DateRange 
		WHERE DateData < @EndDateTime
	)
	SELECT * into #temp_DateRange
	FROM DateRange
	OPTION (MAXRECURSION 0)

	IF OBJECT_ID('tempdb..#temp_Index_MissingDates') IS NOT NULL         
		DROP TABLE #temp_Index_MissingDates

	Select * into #temp_Index_MissingDates
	From(
		Select cal.dateData as Calender_Date,ind.IndexesMasterID,ind.IndexType,ind.IndexesName,ind.IndexTypeText,ind.IndexTable_Date
		from #temp_DateRange cal
		Left Join(
			Select im.IndexesMasterID,i.IndexType, im.IndexesName,lindextype.name as IndexTypeText,i.Date as IndexTable_Date
			from core.IndexesMaster im
			Inner join core.indexes i on i.IndexesMasterID = im.IndexesMasterid
			left join core.lookup lindextype on lindextype.lookupid = i.IndexType
			Where im.IndexesMasterGuid = @IndexesMasterGuid
			and i.IndexType = @IndexTypeID

		)ind on ind.IndexTable_Date = cal.dateData
		Where ind.IndexTable_Date is null
	
	)z




	IF OBJECT_ID('tempdb..#temp_Index_MissingDates_Inserting') IS NOT NULL         
		DROP TABLE #temp_Index_MissingDates_Inserting

	CREATE TABLE #temp_Index_MissingDates_Inserting(
		Calender_Date date,
		IndexTypeText nvarchar(256),
		Value decimal(28,15),
		IndexesMasterGuid UNIQUEIDENTIFIER ,
		CopyFrom_Date date
	)



	IF EXISTS(Select top 1 * from #temp_Index_MissingDates)
	BEGIN
	
		INSERT INTO #temp_Index_MissingDates_Inserting(Calender_Date,IndexTypeText,Value,IndexesMasterGuid ,CopyFrom_Date)	
		Select mi.Calender_Date
		,curr_index.IndexTypeText
		,curr_index.Value
		,curr_index.IndexesMasterGuid
		,curr_index.IndexTable_Date as CopyFrom_Date
		from #temp_Index_MissingDates mi
		Outer Apply(
			Select top 1 im.IndexesMasterGuid, im.IndexesMasterID,i.IndexType, im.IndexesName,lindextype.name as IndexTypeText,i.Date as IndexTable_Date,i.value
			from core.IndexesMaster im
			Inner join core.indexes i on i.IndexesMasterID = im.IndexesMasterid
			left join core.lookup lindextype on lindextype.lookupid = i.IndexType
			Where im.IndexesMasterGuid = @IndexesMasterGuid
			and i.IndexType = @IndexTypeID
			and i.date <= mi.Calender_Date
			Order by i.Date desc
		)curr_index
		Where curr_index.Value is not null

	
		Declare @L_tblindexes [TableTypeIndexList]
		INSERT INTO @L_tblindexes
		Select Calender_Date,IndexTypeText,Value,IndexesMasterGuid From #temp_Index_MissingDates_Inserting


		exec [dbo].[usp_InsertUpdateIndexList] @L_tblindexes,@UserID,@UserID

	END


	Select * from #temp_Index_MissingDates_Inserting


END
ELSE
BEGIN
	IF OBJECT_ID('tempdb..#temp_Index_MissingDates_Inserting1') IS NOT NULL         
		DROP TABLE #temp_Index_MissingDates_Inserting1

	CREATE TABLE #temp_Index_MissingDates_Inserting1(
		Calender_Date date,
		IndexTypeText nvarchar(256),
		Value decimal(28,15),
		IndexesMasterGuid UNIQUEIDENTIFIER ,
		CopyFrom_Date date
	)

	Select * from #temp_Index_MissingDates_Inserting1
END




END