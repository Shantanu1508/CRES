

CREATE PROCEDURE [dbo].[usp_DeleteINUnderwritingDealDataByDealID] --'15-0006','0C1DF314-D83A-44F6-88D9-84AB6A3C41A0'
(
	@DealID nvarchar(256),
	@UserID UNIQUEIDENTIFIER
)
	
AS
BEGIN

 
	--DELETE  FF
	--FROM [IO].[IN_UnderwritingFundingSchedule] FF
	--INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = FF.IN_UnderwritingEventID
	--INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
	--INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
	--WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
	--and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'FundingSchedule')
	
	
	

	DELETE  rs
	FROM [IO].[IN_UnderwritingRateSpreadSchedule] rs
	INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
	INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
	INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
	WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
	and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
	and rs.ValueTypeID in (Select LookupID from CORE.Lookup where Name in ('Spread','Index Floor'))


	DELETE  pik
	FROM [IO].[IN_UnderwritingPikSchedule] pik
	INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = pik.IN_UnderwritingEventID
	INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
	INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
	WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
	and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PikSchedule')

	DELETE  pik
	FROM [IO].[IN_UnderwritingMaturity] pik
	INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = pik.IN_UnderwritingEventID
	INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
	INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
	WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
	and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'Maturity')

	DELETE ss
	FROM [IO].[IN_UnderwritingStrippingSchedule] ss
	INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = ss.IN_UnderwritingEventID
	INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
	INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
	WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
	and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
	and ss.ValueTypeID = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')


	DELETE eve
	From [IO].[IN_UnderwritingEvent] eve 
	INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
	INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
	WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
	and eve.EventTypeID in (Select LookupID from CORE.Lookup where Name in ('RateSpreadSchedule','StrippingSchedule','PIKSchedule','Maturity')) --,'FundingSchedule'


	DECLARE @tListAccID TABLE (tAccountID UNIQUEIDENTIFIER)
	INSERT into @tListAccID

	Select note.IN_UnderwritingAccountID
	From [IO].[IN_UnderwritingNote] note 
	INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = note.IN_UnderwritingAccountID
	WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)

	 

	DELETE note
	From [IO].[IN_UnderwritingNote] note 
	WHERE note.IN_UnderwritingAccountID in (Select tAccountID from @tListAccID)
	--WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)


	DELETE acc
	From [IO].[IN_UnderwritingAccount] acc 
	WHERE acc.IN_UnderwritingAccountID in  (Select tAccountID from @tListAccID)


	DELETE From [IO].[IN_UnderwritingDeal] WHERE ClientDealID = @DealID


END
