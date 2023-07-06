-- Procedure

CREATE PROCEDURE [DW].[usp_ImportDailyInterestAccruals]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_DailyInterestAccrualsBI',GETDATE())

		DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)

	Declare @L_DailyInterestAccrualsID int;
	SET @L_DailyInterestAccrualsID = (Select ISNULL(MAX([DailyInterestAccrualsID]),0) From DW.DailyInterestAccrualsBI)



	Truncate table [DW].[L_DailyInterestAccrualsBI]

	INSERT INTO [DW].[L_DailyInterestAccrualsBI]
           ([DailyInterestAccrualsID]
           ,[DailyInterestAccrualsGUID]
           ,[NoteID]
           ,[Date]
           ,[DailyInterestAccrual]
           ,[AnalysisID]
           ,[CRENoteID]
           ,[AnalysisName]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	Select
	 te.[DailyInterestAccrualsID]
	,te.[DailyInterestAccrualsGUID]
	,te.[NoteID]
	,te.[Date]
	,te.[DailyInterestAccrual]
	,te.[AnalysisID]
	,n.[CRENoteID]
	,an.name [AnalysisName]
	,te.[CreatedBy]
	,te.[CreatedDate]
	,te.[UpdatedBy]
	,te.[UpdatedDate]
	From cre.DailyInterestAccruals te
	inner join cre.note n on n.noteid = te.noteid
	left join core.Analysis an on an.AnalysisID = te.AnalysisID
	WHERE te.[DailyInterestAccrualsID] > @L_DailyInterestAccrualsID
	
	
	--WHERE te.[DailyInterestAccrualsID] in 
	--(
	--	Select Distinct [DailyInterestAccrualsID] From(
	--		Select	[DailyInterestAccrualsID],[CreatedDate],[UpdatedDate]	From cre.DailyInterestAccruals
	--		EXCEPT
	--		Select	[DailyInterestAccrualsID],[CreatedDate],[UpdatedDate]	From DW.DailyInterestAccrualsBI
	--	)a
	--)

	--where DailyInterestAccrualsAutoID > (Select ISNULL(MAX(DailyInterestAccrualsAutoID),0) from [DW].[DailyInterestAccrualsBI])	
	

SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportDailyInterestAccruals - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


