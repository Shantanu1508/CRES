
   

CREATE PROCEDURE [dbo].[usp_ImportServicingDataFromLandingToServicingLog] -- 'vbalapure','wellfargosheet'
 @CreatedBy nvarchar(max),
 @FileName  nvarchar(max),
 @OriginalFileName nvarchar(max),
 @storagetype nvarchar(50),
 @StartDate Date,
 @EndDate Date
AS
BEGIN



--Get Min and Max date
DECLARE @MinDate date;
DECLARE @MaxDate date;
DECLARE @ServicerWellsFargo int = (Select LookupID from core.lookup where name = 'Wells Fargo' and parentid = 62);
DECLARE @Active int = (Select LookupID from core.lookup where name = 'Active' and parentid = 1);
DECLARE @LookupIDPrincipalReceived int = (Select LookupID from core.lookup where name = 'Principal Received' and parentid = 39);
DECLARE @LookupIDInterestReceived int = (Select LookupID from core.lookup where name = 'Interest Received' and parentid = 39);
DECLARE @IN_ServicingTrLogInfoID int;
DECLARE @LookupIDIN_ServicingTrLogInfo int = (Select LookupID from core.lookup where name = 'IN_ServicingTrLogInfo' and parentid = 27);
DECLARE @storagetypeid int = (Select LookupID from core.lookup where name = @storagetype and parentid = 63);

--Update servicer to wells fargo in note
UPDATE CRE.note set Servicer = @ServicerWellsFargo where crenoteid in (SELECT distinct NoteID FROM [IO].[IN_ServicingTransaction]) 

--Set StartDate and end date
SET @MinDate = @StartDate;
SET @MaxDate = @EndDate;


----Delete previous servicing data
--SELECT @MinDate = MIN(tdate),@MaxDate = MAX(tdate) 
--FROM(
--	SELECT TransactionDate AS tdate FROM [IO].[IN_ServicingTransaction] where DateDue <> '01/01/1900'
--	--UNION ALL
--	--SELECT DateDue AS tdate FROM [IO].[IN_ServicingTransaction] where DateDue <> '01/01/1900'
--) AS tbl


----Delete data from NoteTransactionDetail between Min and Max date for note
--DELETE FROM [Cre].NoteTransactionDetail WHERE CAst(TransactionDate as date) between @MinDate and @MaxDate 
--and NoteID in 
--(
--	Select NoteID from cre.note n
--	inner join core.Account acc on n.account_accountid = acc.accountid
--	where acc.StatusID = @Active and Servicer = @ServicerWellsFargo 
--	and crenoteid in (SELECT distinct NoteID FROM [IO].[IN_ServicingTransaction]) 
--)



-----Save NoteTransactionDetail----------------------------
Declare @CreNoteID nvarchar(MAX)
DECLARE @NoteMinDate date;
DECLARE @NoteMaxDate date;
 
IF CURSOR_STATUS('global','CursorNoteTr')>=-1
BEGIN
	DEALLOCATE CursorNoteTr
END

DECLARE CursorNoteTr CURSOR 
for
(
	Select NoteId,MIN(Transactiondate) minDate,MAX(Transactiondate) maxDate from  [IO].[IN_ServicingTransaction] group by NoteId
)


OPEN CursorNoteTr 

FETCH NEXT FROM CursorNoteTr
INTO @CreNoteID,@NoteMinDate,@NoteMaxDate

WHILE @@FETCH_STATUS = 0
BEGIN

	--Delete data from NoteTransactionDetail between Min and Max date for note
	DELETE FROM [Cre].NoteTransactionDetail WHERE NoteID in (Select NoteID from cre.note where crenoteid = @CreNoteID) and CAst(TransactionDate as date) between @NoteMinDate and @NoteMaxDate 
	

FETCH NEXT FROM CursorNoteTr
INTO @CreNoteID,@NoteMinDate,@NoteMaxDate
END
CLOSE CursorNoteTr   
DEALLOCATE CursorNoteTr

----------------------------
--Maintain log info
INSERT INTO [IO].[IN_ServicingTrLogInfo]([MinDate],[MaxDate],[FileName],[Status],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],OrignalFileName,StorageType)
VALUES(@MinDate,@MaxDate,@FileName,'Importing',@CreatedBy,GEtdate(),@CreatedBy,GEtdate(),@OriginalFileName,@storagetypeid)
SET @IN_ServicingTrLogInfoID = @@IDENTITY;
--------------------------------

--Managing generic table for fileupload
INSERT INTO [App].[UploadedDocumentLog]([ObjectTypeID],[ObjectID],[FileName],[OriginalFileName],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
VALUES(@LookupIDIN_ServicingTrLogInfo,@IN_ServicingTrLogInfoID,@FileName,@OriginalFileName,@CreatedBy,getdate(),@CreatedBy,getdate())


BEGIN TRY
BEGIN TRAN

	INSERT INTO [Cre].NoteTransactionDetail ([NoteID],TransactionType,[TransactionDate],[Amount],[RelatedtoModeledPMTDate],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])

	Select (Select TOP 1 NoteID from cre.note where CRENoteID = a.NoteID)as NoteID,TransactionType,TransactionDate,Amount,RelatedtoModeledPMTDate ,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate
	From
	(
		SELECT 
		NoteID,
		@LookupIDPrincipalReceived as TransactionType,
		TransactionDate,
		PrincipalPayment as Amount,
		DateDue as RelatedtoModeledPMTDate,
		@CreatedBy as CreatedBy,
		GETDATE() as CreatedDate,
		@CreatedBy as UpdatedBy,
		GETDATE() as UpdatedDate
		FROM [IO].[IN_ServicingTransaction] Stl where  PrincipalPayment > 0

		UNION ALL

		SELECT 
		NoteID,
		@LookupIDInterestReceived as TransactionType,
		TransactionDate,
		InterestPayment as Amount,
		DateDue as RelatedtoModeledPMTDate,
		@CreatedBy as CreatedBy,
		GETDATE() as CreatedDate,
		@CreatedBy as UpdatedBy,
		GETDATE() as UpdatedDate
		FROM [IO].[IN_ServicingTransaction] Stl where InterestPayment > 0
	)a
	

	Update [IO].[IN_ServicingTrLogInfo] set [Status] = 'Completed' where IN_ServicingTrLogInfoID = @IN_ServicingTrLogInfoID
	

	--Insert into Calculation Requst table-------------------
	DECLARE @TableTypeCalculationRequests [TableTypeCalculationRequests]

	INSERT INTO @TableTypeCalculationRequests(NoteId,StatusText,UserName,ApplicationText,PriorityText,AnalysisID,CalcType)
	Select 
	NoteID,
	'Processing' as StatusText,
	@CreatedBy as UserName,
	null,
	'Batch',
	'C10F3372-0FC2-4861-A9F5-148F1F80804F' as AnalysisID,
	775 as CalcType
	from cre.note n
	inner join core.Account acc on n.account_accountid = acc.accountid
	where acc.StatusID = @Active and Servicer = @ServicerWellsFargo and acc.IsDeleted=0

	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@CreatedBy
	----------------------------------------------------------



COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	Update [IO].[IN_ServicingTrLogInfo] set [Status] = 'Failed',[ErrorMsg] = @ErrorMessage where IN_ServicingTrLogInfoID = @IN_ServicingTrLogInfoID
 
	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  
END CATCH
--------------------------------


END

