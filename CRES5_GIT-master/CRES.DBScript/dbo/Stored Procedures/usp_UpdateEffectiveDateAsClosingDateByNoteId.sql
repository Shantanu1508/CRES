CREATE PROCEDURE [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] 
	@noteID uniqueidentifier,
	@CreatedBy nvarchar(256) = NULL
AS
BEGIN
	SET NOCOUNT ON;
 
	IF EXISTS(Select 1 FROM CRE.NOTE Where NoteID = @noteID AND ClosingDate <> ISNULL(ClosingDateBK,ClosingDate))
	BEGIN

		IF OBJECT_ID('tempdb..#LocalTemp') IS NOT NULL   
		DROP TABLE #LocalTemp  	
		CREATE TABLE #LocalTemp  
		(  
			[NoteID] UNIQUEIDENTIFIER NULL,
			[AccountID] UNIQUEIDENTIFIER,
			[ClosingDate] DateTime NULL,
			[ClosingDateBK] DateTime NULL,
			[EventID] UNIQUEIDENTIFIER,
			[EventTypeID] INT NULL,
			[Min_EffectiveStartDate] DateTime NULL
		)  
		
		INSERT INTO #LocalTemp
		(
			[NoteID],
			[AccountID],
			[ClosingDate],
			[ClosingDateBK],
			[EventID],
			[EventTypeID],
			[Min_EffectiveStartDate]
		)

		SELECT
		NoteID,
		AccountID,
		ClosingDate,
		ClosingDateBK,
		EventID,
		EventTypeID,
		EffectiveStartDate
		FROM (
			SELECT
			n.NoteID,
			acc.AccountID,
			n.ClosingDate,
			n.ClosingDateBK,
			eve.EventID,
			eve.EventTypeID,
			eve.EffectiveStartDate,
			ROW_NUMBER() Over (Partition By eve.accountID,eve.EventTypeID ORDER BY eve.EffectiveStartDate) AS Sno
			FROM [CORE].[Event] eve
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			WHERE acc.isdeleted=0 AND eve.StatusID =1
			AND LEventTypeID.Name IN ('Maturity','FundingSchedule','PIKScheduleDetail','LIBORSchedule','AmortSchedule','RateSpreadSchedule',
			'PrepayAndAdditionalFeeSchedule','StrippingSchedule','FinancingSchedule','PIKSchedule','ServicingFeeSchedule','DefaultSchedule')
			AND ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId THEN 1 ELSE 0 END ) = 1 
			
		)Res WHERE Sno=1
		and res.EffectiveStartDate = ClosingDateBK

		

		UPDATE eve SET  
		eve.EffectiveStartDate= t1.ClosingDate
		FROM [CORE].[Event] eve
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		INNER JOIN #LocalTemp t1
		ON eve.AccountID=t1.AccountID 
		AND eve.EventID = t1.EventID
		AND eve.EventTypeID = t1.EventTypeID
		AND ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 ;
		
		--Update Schedule 
		UPDATE eve SET
		eve.StatusID = 2
		FROM [CORE].[Event] eve
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
		INNER JOIN #LocalTemp temp on temp.AccountID=eve.AccountID AND temp.EventID<>eve.EventID 
		AND temp.EventTypeID = eve.EventTypeID
		WHERE eve.EffectiveStartDate <= temp.ClosingDate
		AND LEventTypeID.Name IN ('Maturity','FundingSchedule','PIKScheduleDetail','LIBORSchedule','AmortSchedule','RateSpreadSchedule',
		'PrepayAndAdditionalFeeSchedule','StrippingSchedule','FinancingSchedule','ServicingFeeSchedule','DefaultSchedule')
		AND ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 

	END
END
