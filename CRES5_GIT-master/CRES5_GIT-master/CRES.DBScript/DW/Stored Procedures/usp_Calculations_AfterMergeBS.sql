
CREATE PROCEDURE [DW].[usp_Calculations_AfterMergeBS]
	@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON;

	Print('usp_Calculations_AfterMergeBS - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	
	UPDATE DW.BatchLog
	SET Status = 'POST-CALCULATIONS',
	LogText = 'Post Calculation Start: ' +  CONVERT(VARCHAR,GETDATE(),8) + CHAR(13) + CHAR(10)
	WHERE BatchLogId = @BatchLogId


	Exec [DW].[usp_UpdateAMUserInDeal]

	--Auto approve note wise maturity extentions
	Exec [dbo].[usp_UpdateMaturityExtentionsToApprove] 

	Declare @tbltemp as Table(
	NoteID int null,
	TotalCommitment decimal(28,15)  NULL ,
	TotalCurrentAdjustedCommitment decimal(28,15)  NULL ,
	PastFunding decimal(28,15)  NULL ,
	FutureFunding decimal(28,15)  NULL,
	ShardName nvarchar(max)  NULL  
	)


	DECLARE @query nvarchar(MAX) = N'
	Select n.NoteId,ISNULL(vw_AcctNote.TotalCommitment,0) as TotalCommitment,
	ISNULL(vw_AcctNote.TotalCurrentAdjustedCommitment,0) as TotalCurrentAdjustedCommitment,
	ISNULL(tblPastFunding.PastFunding,0) as PastFunding,
	ISNULL(tblFutureFunding.FutureFunding,0) as FutureFunding
	from tblNote n
	left join [acore].[vw_AcctNote] vw_AcctNote on vw_AcctNote.NoteID = n.noteid
	left join (
		Select 
		NoteId_F,
		ISNULL(SUM(FundingAmount),0) as  FutureFunding
		from tblNoteFunding F_FF
		where F_FF.FundingDate > getdate() and FundingAmount > 0
		group by NoteId_F
	)tblFutureFunding on tblFutureFunding.NoteId_F = n.NoteId
	left join (
		Select 
		NoteId_F,
		ISNULL(SUM(FundingAmount),0) as  PastFunding
		from tblNoteFunding F_FF
		where  F_FF.FundingDate <= getdate() and FundingAmount > 0
		group by NoteId_F
	)tblPastFunding on tblPastFunding.NoteId_F = n.NoteId'

	INSERT INTO @tbltemp (NoteID,TotalCommitment,TotalCurrentAdjustedCommitment,PastFunding,FutureFunding,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query


	Update dw.UwNoteBI SET 
	dw.UwNoteBI.TotalCommitment = a.TotalCommitment,
	dw.UwNoteBI.TotalCurrentAdjustedCommitment = a.TotalCurrentAdjustedCommitment,
	dw.UwNoteBI.PastFunding = a.PastFunding,
	dw.UwNoteBI.FutureFunding = a.FutureFunding
	FROM (
		Select NoteID,TotalCommitment,TotalCurrentAdjustedCommitment,PastFunding,FutureFunding from @tbltemp
	)a
	where dw.UwNoteBI.NoteID = a.NoteID 


	----Update backshop current balance in noteperiodic calc "BSCurrentBalance"  --40 sec
	Update DW.noteperiodiccalcBI set DW.noteperiodiccalcBI.BSCurrentBalance = a.CurrentBalance
	From(
		Select BSCash.noteid as crenoteid,BSCash.PeriodEndDate,BSCash.CurrentBalance
		from [DW].[UwCashflowBI] BSCash
		where BSCash.PeriodEndDate >= DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)
	)a
	Where DW.noteperiodiccalcBI.crenoteid = a.crenoteid
	and DW.noteperiodiccalcBI.PeriodEndDate = a.PeriodEndDate
	and DW.noteperiodiccalcBI.PeriodEndDate >= DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)
	--======================================================================

	EXEC [DW].[usp_ImportReconciliationDetail]
	
	--It will used quartly only
	--Exec [DW].[usp_ImportNotePeriodicCalcByEntity]	 
	--Exec [DW].[usp_ImportTransactionByEntity] 
	--Exec [DW].[usp_ImportNotePeriodicCalcByEntity_All]

	--It will used only for realized loan
	----exec [DW].[usp_ImportRealizedDataIntoTransactionEntryBI_Realized]


	IF EXISTS(Select BatchLogId  from dw.BatchLog WHERE BatchLogId = @BatchLogId and [LogType] is null) --do not exec for [LogType] = 'ClickedFromButton'
	BEGIN

		exec [dbo].[usp_ClearLog] 

		--Export Failed FF to backsop
		--exec [dbo].[usp_AutoExportFutureFundingToBackshop] 

		--Change Task Status from Open-Process if startdate = today
		exec [dbo].[usp_ChangeTaskStatus] 
		exec [dbo].[usp_QueueNotesForCalculationIfDWoutofSync]

		exec [dbo].[usp_ImportIntoUserNotificationArchive]
		


		--Delete, soft deleted tag's data
		IF EXISTS(Select TagMasterID from cre.TagMaster where IsDeleted = 1)
		BEGIN
			Delete from cre.TransactionEntryClose where TagMasterID in (Select TagMasterID from cre.TagMaster where IsDeleted = 1)
			Delete from cre.TagMaster where IsDeleted = 1
		END
		--Delete periodic close deleted data
		IF EXISTS(Select PeriodID from core.Period where IsDeleted = 1)
		BEGIN
			Delete from core.PeriodCloseArchive where PeriodID in (Select PeriodID from core.Period where IsDeleted = 1)
			Delete from core.Period where IsDeleted = 1
		END

		----===========================================================
		--Delete record where EffectiveStartDate = null
		IF EXISTS(Select eventID from core.event where EventTypeID = 10 and EffectiveStartDate is null)
		BEGIN
			Delete from core.FundingSchedule where eventId in (Select eventID from core.event where EventTypeID = 10 and EffectiveStartDate is null )  
			Delete from core.event where EventTypeID = 10 and  EffectiveStartDate is null 
		END


		Declare @tbl_eventID as Table (eventid UNIQUEIDENTIFIER null)
		INSERT INTO @tbl_eventID(eventid)
		Select eventid from (  
			Select e.eventid,e.accountid,(Select count(FundingScheduleID) from core.fundingschedule ff where ff.eventid = e.eventid) cnt  
			from core.event e 
			where eventtypeid = 10 
			and statusid = 1
		)a  
		where a.cnt = 0 

		IF EXISTS(Select eventid from @tbl_eventID)
		BEGIN
			Delete from core.event where eventid in (Select eventid from @tbl_eventID)
		END 
		------===========================================================

		--Delete records from landing table
		Delete from io.out_Futurefunding where CAST(ExportTimeStamp as date) < (Select CAST((MAX(ExportTimeStamp) - 7) as date) from io.out_Futurefunding)
	
		---delete scenario's data from output tables
		exec [dbo].[usp_DeleteScenarioDataFromTables]
	END


	UPDATE DW.BatchLog
	SET LogText = LogText + ', Post Calculation End: ' +  CONVERT(VARCHAR,GETDATE(),8) + CHAR(13) + CHAR(10)
	WHERE BatchLogId = @BatchLogId


END
