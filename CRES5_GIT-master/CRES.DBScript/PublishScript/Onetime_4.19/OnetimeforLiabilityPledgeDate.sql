
Update cre.liabilitynote SET cre.liabilitynote.PledgeDate = a.EffectiveStartDate
From(

Select 
ln.LiabilityNoteGUID,ln.AccountID,ln.DealAccountID,ln.LiabilityNoteID,gsetupLia.EffectiveStartDate,ln.PledgeDate

from cre.liabilitynote ln
left Join (
	Select acc.AccountID,e.EffectiveStartDate,PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate
	from [CORE].GeneralSetupDetailsLiabilityNote gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsLiabilityNote')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupLia on gsetupLia.AccountID = ln.AccountID


)a
Where a.AccountID = cre.liabilitynote.AccountID