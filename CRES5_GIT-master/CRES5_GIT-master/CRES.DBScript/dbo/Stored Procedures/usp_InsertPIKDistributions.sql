


Create PROCEDURE [dbo].[usp_InsertPIKDistributions]
(
	@tblPIKDistributions [TableTypePIKDistributions] READONLY,
	@CreatedBy nvarchar(256)
	
)
	
AS
BEGIN
    SET NOCOUNT ON;

-----Cursor Delete----------------------------
Declare @SourceNoteID UNIQUEIDENTIFIER
Declare @ReceiverNoteID UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorDelete')>=-1
BEGIN
	DEALLOCATE CursorDelete
END

DECLARE CursorDelete CURSOR 
for
(
	Select Distinct ReceiverNoteID,SourceNoteID From @tblPIKDistributions
)
OPEN CursorDelete 

FETCH NEXT FROM CursorDelete
INTO @ReceiverNoteID,@SourceNoteID

WHILE @@FETCH_STATUS = 0
BEGIN

	Delete from [CRE].[PIKDistributions] where SourceNoteID = @SourceNoteID and  ReceiverNoteID = @ReceiverNoteID
					 
FETCH NEXT FROM CursorDelete
INTO @ReceiverNoteID,@SourceNoteID
END
CLOSE CursorDelete   
DEALLOCATE CursorDelete
---------------------------------------------------------------

 INSERT INTO [CRE].[PIKDistributions]
           ([SourceNoteID]
           ,[ReceiverNoteID]
           ,[TransactionDate]
           ,[Amount]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	Select 
	[SourceNoteID]
	,[ReceiverNoteID]
	,[TransactionDate]
	,[Amount]
	,@CreatedBy
	,getdate()
	,@CreatedBy
	,getdate()
	From @tblPIKDistributions




--------Insert PIKScheduleDetail---------------

IF CURSOR_STATUS('global','CursorInsertPIKScheduleDetail')>=-1
BEGIN
	DEALLOCATE CursorInsertPIKScheduleDetail
END

DECLARE CursorInsertPIKScheduleDetail CURSOR 
for
(
	Select Distinct ReceiverNoteID,SourceNoteID From @tblPIKDistributions
)
OPEN CursorInsertPIKScheduleDetail 

FETCH NEXT FROM CursorInsertPIKScheduleDetail
INTO @ReceiverNoteID,@SourceNoteID

WHILE @@FETCH_STATUS = 0
BEGIN

	---------------------------------------------------------------
	DECLARE @notePIKScheduleDetail [TableTypePIKScheduleDetail] 

	INSERT INTO @notePIKScheduleDetail(NoteId,AccountId,Date,Value )
	Select 
	[ReceiverNoteID],
	(SELECT TOP 1 n.Account_AccountID FROM CRE.Note n inner join Core.Account ac on n.Account_AccountID=ac.AccountID  WHERE NoteID = nf.[ReceiverNoteID] and ac.IsDeleted=0) AccountId,
	[TransactionDate],
	[Amount] 
	From @tblPIKDistributions nf
	where SourceNoteID = @SourceNoteID and ReceiverNoteID = @ReceiverNoteID
	and [TransactionDate] is not null and [Amount] > 0

	exec [dbo].[usp_InsertUpdatePIKScheduleDetail] @notePIKScheduleDetail,@CreatedBy,@CreatedBy
	---------------------------------------------------------------
					 
FETCH NEXT FROM CursorInsertPIKScheduleDetail
INTO @ReceiverNoteID,@SourceNoteID
END
CLOSE CursorInsertPIKScheduleDetail   
DEALLOCATE CursorInsertPIKScheduleDetail





	 
END






