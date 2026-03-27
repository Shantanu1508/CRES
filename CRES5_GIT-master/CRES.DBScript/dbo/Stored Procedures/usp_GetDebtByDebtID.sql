CREATE PROCEDURE [dbo].[usp_GetDebtByDebtID]   --'DF526AD9-5C99-4A5F-96FF-0E214BC04F57'
	@DebtGUID UNIQUEIDENTIFIER 
AS
BEGIN

Select 
ln.AccountID
,ln.DebtID
,ln.DebtGUID 
,acc.Name as DebtName
,acc.StatusID as [Status]
,lStatus.name as StatusText
,acc.BaseCurrencyID as CurrencyID
,lcurr.name as CurrencyText
,acc.AccountTypeID as DebtType
,ac.Name as DebtTypeText
,ln.CurrentCommitment
,ln.MatchTerm 
,lMatchTerm.name as MatchTermText
,ln.IsRevolving 
,lIsRevolving.name as IsRevolvingText
,ln.FundingNoticeBD
,ln.EarliestFinancingArrival
,LCurrentbal.EndingBalance as CurrentBalance
,ln.OriginationDate
,ln.OriginationFees
,ln.RateType 
,lRateType.name as RateTypeText 
,ln.DrawLag
,ln.PaydownDelay 
,gsetupdt.EffectiveStartDate
,gsetupdt.Commitment
,gsetupdt.InitialMaturityDate
,gsetupdt.ExitFee
,gsetupdt.ExtensionFees
,MaxAdvanceRate
,TargetAdvanceRate
,ln.InitialFundingDelay
,ln.FundDelay
,ln.FundingDay
,ln.CreatedBy   
,ln.CreatedDate 
,ln.UpdatedBy
,ln.UpdatedDate
,accCash.AccountID as CashAccountID
,accCash.[Name] as CashAccountName
,lBanker.BankerName as BankerText
,ln.AbbreviationName
,ln.LinkedFundID

from cre.Debt ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID

Left Join core.lookup lMatchTerm on lMatchTerm.lookupid = ln.MatchTerm
Left Join core.lookup lIsRevolving on lIsRevolving.lookupid = ln.IsRevolving

Left Join core.lookup lRateType on lRateType.lookupid = ln.RateType 
Left Join [CRE].[LiabilityBanker] lBanker on lBanker.LiabilityBankerID = ln.LiabilityBankerID

Left Join Core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID

Left Join (
SELECT top 1 EndingBalance, AccountID
FROM CRE.transactionentry
WHERE  [Date] <= GETDATE()
and AccountID = (select AccountID from cre.debt where DebtGUID = @DebtGUID)
and EndingBalance is not null
ORDER BY [Date] DESC
)LCurrentbal on LCurrentbal.AccountID = ln.AccountID

left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate,ExitFee,ExtensionFees
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsDebt')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupdt on gsetupdt.AccountID = ln.AccountID
LEFT Join core.Account accCash on accCash.AccountID = ln.PortfolioAccountID

Where acc.IsDeleted <> 1
and DebtGUID = @DebtGUID


END