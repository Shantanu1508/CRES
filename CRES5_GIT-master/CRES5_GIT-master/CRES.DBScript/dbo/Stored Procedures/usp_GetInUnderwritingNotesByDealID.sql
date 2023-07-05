


CREATE PROCEDURE [dbo].[usp_GetInUnderwritingNotesByDealID] 
(
	@DealID Varchar(500),
	@UserID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT  
	unN.IN_UnderwritingNoteID,
    unN.IN_UnderwritingAccountID,
    unN.IN_UnderwritingDealID,
        
	unAcc.Name,
	unAcc.PayFrequency,
	LPayFrequency.Name as PayFrequencyText,
	unN.ClientNoteID,
	ClosingDate,
	FirstPaymentDate,
	SelectedMaturityDate,
	InitialFundingAmount,
	OriginationFee,
	IOTerm,
	AmortTerm,
	DeterminationDateLeadDays,
	DeterminationDateReferenceDayoftheMonth,
	RoundingMethod,
	LRoundingMethod.Name as RoundingMethodText,
	IndexRoundingRule,
	unN.StatusID,
	LStatusID.Name as StatusIDText,

	ExpectedMaturityDate,
	ExtendedMaturityScenario1,
	ExtendedMaturityScenario2,
	ExtendedMaturityScenario3,
	

	(
			  
			Select TOP 1 mat.[SelectedMaturityDate]
	from [IO].[IN_UnderwritingMaturity] mat
	INNER JOIN [IO].IN_UnderwritingEvent e on e.IN_UnderwritingEventID = mat.IN_UnderwritingEventId
	INNER JOIN 
			(					
				Select 
					(Select IN_UnderwritingAccountID from [io].IN_UnderwritingAccount ac where ac.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [IO].IN_UnderwritingEvent eve
					INNER JOIN [io].IN_UnderwritingNote n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
					INNER JOIN [io].IN_UnderwritingAccount acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
					and acc.IN_UnderwritingAccountID = unAcc.IN_UnderwritingAccountID
					GROUP BY n.IN_UnderwritingAccountID,EventTypeID

			) sEvent

	ON sEvent.AccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	)InitialMaturityDate,
lienposition,
llienposition.name as lienpositionText,
[priority],
(Select count(crenoteid) from cre.note n inner join core.account acc on n.account_accountid = acc.accountid where acc.isdeleted =0 and  n.crenoteid = unN.clientNoteID and n.dealid <> (Select d.dealid from cre.deal d where d.credealid = unDeal.clientdealid and d.isdeleted = 0 )) as NoteExistsInDiffDeal,
(Select dealname from cre.deal dd where dd.isdeleted = 0 and dealid = (Select dealid from cre.note n inner join core.account acc on n.account_accountid = acc.accountid where acc.isdeleted =0 and  n.crenoteid = unN.clientNoteID and n.dealid <> (Select d.dealid from cre.deal d where d.credealid = unDeal.clientdealid and d.isdeleted = 0 ))) as NoteExistsInDiffDealName


FROM [IO].[In_UnderwritingNote] unN
	INNER JOIN [IO].[IN_UnderwritingDeal] unDeal ON unN.IN_UnderwritingDealID = unDeal.IN_UnderwritingDealID
	INNER JOIN [IO].[IN_UnderwritingAccount] unAcc ON unN.IN_UnderwritingAccountID = unAcc.IN_UnderwritingAccountID
	LEFT JOIN [CORE].[Lookup] LPayFrequency ON LPayFrequency.LookupID = unAcc.PayFrequency
	LEFT JOIN [CORE].[Lookup] LRoundingMethod ON LRoundingMethod.LookupID = unN.RoundingMethod
	LEFT JOIN [CORE].[Lookup] LStatusID ON LStatusID.LookupID = unN.StatusID
	left join Core.Lookup llienposition ON unN.lienposition=llienposition.LookupID

	Where unDeal.ClientDealID = @DealID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

