
CREATE PROCEDURE [dbo].[usp_DeleteDataByLastAccountingClosedate]  
	@NoteID UNIQUEIDENTIFIER,
	@LastAccountingClosedate Date

AS
BEGIN

	
	Declare @tbleventid as Table(eventid UNIQUEIDENTIFIER,rno int)

	INSERT INTO @tbleventid(eventid,rno)
	Select eventid,rno
	from(
		Select n.noteid,acc.AccountID,eve.EffectiveStartDate,eve.eventid,ROW_NUMBER() OVER (Partition by  n.noteid order by n.noteid,eve.EffectiveStartDate desc) rno
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')	
		and acc.IsDeleted = 0
		and eve.StatusID = 1
		and n.NoteID = @NoteID
	)a


	-----Funding Schedule

	---Delete History schedule
	Delete from core.FundingSchedule where eventId in (Select eventID from @tbleventid where rno <> 1)
	Delete from core.event where eventId in (Select eventID from @tbleventid where rno <> 1)

	---Delete History funding from lastest schedule
	Declare @ClosingDate date;
	SET @ClosingDate = (Select closingdate from cre.note where noteid = @NoteID)


	Update core.event set EffectiveStartDate = @ClosingDate where eventId in (Select eventID from @tbleventid where rno = 1)

	Delete from core.FundingSchedule where eventId in (Select eventID from @tbleventid where rno = 1) and date <= @LastAccountingClosedate

	--------------------------------

END