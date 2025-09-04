CREATE PROCEDURE [dbo].[usp_GetEquityByEquityID]  ---'E98B0C55-1DC1-4EA2-ADDD-D861D600231C'
	@EquityGUID UNIQUEIDENTIFIER 
AS
BEGIN

Declare @CalcAsOfDate date;	
	SET @CalcAsOfDate = ISNULL((Select MAX(TransactionDate) from CRE.LiabilityFundingScheduleAggregate where AccountID in (
			Select distinct ln.LiabilitytypeID
			from cre.LiabilityNote ln  
			Inner Join core.Account acc on acc.AccountID = ln.AccountID  
			Where acc.IsDeleted <> 1  
			and ln.AssetAccountID  in (
				Select ln.AssetAccountID
				from cre.LiabilityNote ln  
				Inner Join core.Account acc on acc.AccountID = ln.AccountID  
				Where acc.IsDeleted <> 1  
				and ln.LiabilityTypeID in (Select AccountID from cre.Equity where EquityGUID = @EquityGUID)
			)
		)
	),getdate())


Select 
ln.AccountID
,ln.EquityID
,ln.EquityGUID
,acc.Name as EquityName

,acc.StatusID as [Status]
,lStatus.name as StatusText

,ln.StructureID as [StructureID]
,lStructure.name as StructureText

,acc.BaseCurrencyID as CurrencyID
,lcurr.name as CurrencyText
,acc.AccountTypeID as EquityType
,ac.Name as EquityTypeText

,ln.[InvestorCapital]
,ln.[CapitalReserveRequirement]
,ln.[ReserveRequirement]
,ln.[CommittedCapital]
,ln.[CapitalReserve]
,ln.[UncommittedCapital]
,ln.[CapitalCallNoticeBusinessDays]
,ln.[EarliestEquityArrival]
,ln.[InceptionDate]
,ln.[LastDatetoInvest]
,ln.[FundBalanceexcludingReserves]
,ln.[LinkedShortTermBorrowingFacility]
,tblLinktype.Text as LinkedShortTermBorrowingFacilityText

,gsetupEq.EffectiveStartDate
,gsetupEq.Commitment
,gsetupEq.InitialMaturityDate

,ln.[CreatedBy]
,ln.[CreatedDate]
,ln.[UpdatedBy]
,ln.[UpdatedDate]
,tblLinktype.[Type]

---,(select top 1 CalcAsOfDate from CRE.LiabilityCashflowConfig) as CalcAsOfDate
,@CalcAsOfDate as CalcAsOfDate
,ln.FundDelay
,ln.FundingDay
,accCash.AccountID as CashAccountID
,accCash.[Name] as CashAccountName
,ln.AbbreviationName

from cre.Equity ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
Left Join core.lookup lStructure on lstatus.lookupid = ln.StructureID
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left Join Core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID
Left Join(  
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type]
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1
)tblLinktype on tblLinktype.AccountID = ln.LinkedShortTermBorrowingFacility

left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate
	from [CORE].GeneralSetupDetailsEquity gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsEquity')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupEq on gsetupEq.AccountID = ln.AccountID
LEFT Join core.Account accCash on accCash.AccountID = ln.PortfolioAccountID


Where acc.IsDeleted <> 1
and EquityGUID = @EquityGUID


END