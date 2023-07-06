

 
CREATE PROCEDURE [dbo].[usp_DeleteNoteAmortDataForDealFundingID] 
	@DealID UNIQUEIDENTIFIER
AS
BEGIN


	Delete from [CORE].AmortSchedule where AmortScheduleAutoID in 
	(
		Select AmortScheduleAutoID from [CORE].AmortSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN(
			Select 
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
			from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'AmortSchedule')
			and n.dealid = @DealID  and acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
			GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
		and fs.DealAmortScheduleRowno not in (Select DealAmortScheduleRowno from cre.DealAmortizationSchedule where dealid = @DealID)
		and fs.DealAmortScheduleRowno is not null
	
	)
END
