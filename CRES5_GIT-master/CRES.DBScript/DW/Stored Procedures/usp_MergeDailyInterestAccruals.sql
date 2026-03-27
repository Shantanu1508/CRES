CREATE PROCEDURE [DW].[usp_MergeDailyInterestAccruals]
@BatchLogId int
AS
BEGIN
select 1
--SET NOCOUNT ON


--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


--UPDATE [DW].BatchDetail
--	SET
--	BITableName = 'DailyInterestAccrualsBI',
--	BIStartTime = GETDATE()
--	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DailyInterestAccrualsBI'


--IF EXISTS(Select top 1 [DailyInterestAccrualsID] from [DW].[L_DailyInterestAccrualsBI])
--BEGIN

--	Delete ncBI from [DW].[DailyInterestAccrualsBI] ncBI
--	inner join 
--	(
--		Select Distinct NoteID,AnalysisID from [DW].[L_DailyInterestAccrualsBI]

--	)L on L.Noteid = ncBI.Noteid and ncBI.AnalysisID = L.AnalysisID


	
--	INSERT INTO [DW].[DailyInterestAccrualsBI]
--           ([DailyInterestAccrualsID]
--           ,[DailyInterestAccrualsGUID]
--           ,[NoteID]
--           ,[Date]
--           ,[DailyInterestAccrual]
--           ,[AnalysisID]
--           ,[CRENoteID]
--           ,[AnalysisName]
--           ,[CreatedBy]
--           ,[CreatedDate]
--           ,[UpdatedBy]
--           ,[UpdatedDate])
--	Select
--	 te.[DailyInterestAccrualsID]
--	,te.[DailyInterestAccrualsGUID]
--	,te.[NoteID]
--	,te.[Date]
--	,te.[DailyInterestAccrual]
--	,te.[AnalysisID]
--	,te.[CRENoteID]
--	,te.[AnalysisName]
--	,te.[CreatedBy]
--	,te.[CreatedDate]
--	,te.[UpdatedBy]
--	,te.[UpdatedDate]
--	From DW.L_DailyInterestAccrualsBI te



--END


--	DECLARE @RowCount int
--	SET @RowCount = @@ROWCOUNT



--	UPDATE [DW].BatchDetail
--	SET
--	BIEndTime = GETDATE(),
--	BIRecordCount = @RowCount
--	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DailyInterestAccrualsBI'

--	Print(char(9) +'usp_MergeDailyInterestAccruals - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

--		-----------------------------------------------
--	--Truncate table [DW].[L_DailyInterestAccrualsBI]
--	-----------------------------------------------

--SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
GO

