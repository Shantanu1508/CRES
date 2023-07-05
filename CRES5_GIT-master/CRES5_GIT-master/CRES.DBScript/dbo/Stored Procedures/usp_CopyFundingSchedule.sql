
CREATE PROCEDURE [dbo].[usp_CopyFundingSchedule] 

@ParentNoteID UNIQUEIDENTIFIER,
@CopyNoteID UNIQUEIDENTIFIER,
@CreatedBy nvarchar(256)

AS
BEGIN


Declare @ParentAccountID UNIQUEIDENTIFIER
Declare @CopyAccountID UNIQUEIDENTIFIER
Declare @FundingSchedule int

SET @FundingSchedule = 10
SET @ParentAccountID = (Select top 1 Account_AccountID from cre.note where NoteID = @ParentNoteID)
SET @CopyAccountID = (Select top 1 Account_AccountID from cre.note where NoteID = @CopyNoteID)

INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
		SELECT DISTINCT
		  EffectiveStartDate,
		  @CopyAccountID,
		  GETDATE(),
		  EventTypeID,
		  SingleEventValue,
		  StatusID,
		  @CreatedBy,
		  GETDATE(),
		  @CreatedBy,
		  GETDATE()	
	 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@FundingSchedule and StatusID = 1
 


	IF(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno)
		SELECT (SELECT TOP 1
					EventId
				FROM CORE.[event] se
				WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
				AND se.[EventTypeID] = @FundingSchedule and StatusID = 1
				AND se.AccountID = @CopyAccountID),
				CONVERT(date, fd.Date, 101),
				Value,	
				PurposeID,
				Applied,
				Issaved,	  	        
				@CreatedBy,
			GETDATE(),
			@CreatedBy,
			GETDATE()	,
			DrawFundingId,
			Comments,
			DealFundingRowno

		FROM Core.FundingSchedule fd  with (NOLOCK)
		inner join core.Event e  with (NOLOCK) on e.eventid =  fd.EventId
		inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID
		WHERE fd.Date is not null 
		and e.StatusID = 1
		and acc.AccountID = @ParentAccountID

	  END

END
