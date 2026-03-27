CREATE View [dbo].[GAAPExceptions]
as


select crenoteid, 
	substring (case when unfunded>0 then 'unfunded,' else '' end + 
	case when CapitalizedCost>0 then 'CapitalizedCost,' else '' end + 
	case when MissingFirstGaap>0 then 'MissingFirstGaap,' else '' end + 
	case when InvalidAccrualForDiscountPremium>0 then 'InvalidAccrualForDiscountPremium,' else '' end + 
	case when OriginationFeeStripped>0 then 'OriginationFeeStripped,' else '' end + 
	case when NegAddlFeeIncLevelYield>0 then 'NegAddlFeeIncLevelYield,' else '' end + 
	case when PikLoan>0 then 'PikLoan,' else '' end, 1,
	len(case when unfunded>0 then 'unfunded,' else '' end + 
	case when CapitalizedCost>0 then 'CapitalizedCost,' else '' end + 
	case when MissingFirstGaap>0 then 'MissingFirstGaap,' else '' end + 
	case when InvalidAccrualForDiscountPremium>0 then 'InvalidAccrualForDiscountPremium,' else '' end + 
	case when OriginationFeeStripped>0 then 'OriginationFeeStripped,' else '' end + 
	case when NegAddlFeeIncLevelYield>0 then 'NegAddlFeeIncLevelYield,' else '' end + 
	case when PikLoan>0 then 'PikLoan,' else '' end)-1) as feature
from (
select crenoteid, 
	[1] as unfunded,
	[2] as CapitalizedCost,
	[3] as MissingFirstGaap,
	[4] as InvalidAccrualForDiscountPremium,
	[5] as OriginationFeeStripped,
	[6] as NegAddlFeeIncLevelYield,
	[7] as PikLoan from (
  
  select Crenoteid,loanfeature from (
  
  Select Distinct N.CreNoteid ,1 as LoanFeature --'Unfunded' 
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type not in ( 'FundingOrRepayment')  -- Unfunded Loans
						and Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate)))  
						and InitialFundingAmount < 1
						and Tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						and tr.AccountTypeID = 1
						 ---Unfunded Loans
Union All
Select CreNoteid, 2--'Capitalized Cost' LoanFeature
from Cre.Note
Where ISNULL([CapitalizedClosingCosts],0) <> 0
union All

Select nn.crenoteid,3 --'MissingFirstGaap'
from [dbo].[Staging_Cashflow] np
inner join cre.note nn on nn.crenoteid = np.noteid 
where  np.periodenddate = EOMONTH(nn.ClosingDate) and ISNULL(EndingGAAPBookValue,0) = 0
Union all
Select  Distinct Crenoteid, 4--'InvalidAccrualForDiscountPremium'
					from [dbo].[Staging_Cashflow] np
					inner join cre.note nn on nn.crenoteid = np.noteid
					where ROUND(DiscountPremiumAccrual,2) <> 0
					and np.noteid in (Select n.Crenoteid from cre.Note n where ISNULL(n.Discount,0) = 0)

Union all
Select Crenoteid,5--'OriginationFeeStripped'
from [DW].[FeeScheduleBI] fs
where FeeType = 'Origination Fee'  and ISNULL(FeetobeStripped,0) <> 0
Union all

SELECT 
      [crenoteid] as NoteId ,6 --'NegAddlFeeIncLevelYield'
  FROM [DW].[FeeScheduleBI]
  Where FeeType = 'Origination Fee'
  and Value < 0 and [IncludedLevelYield] = 1
Union all
Select crenoteid,7--'PikLoan' 
from Core.[PIKSchedule] piks
	inner join core.Event e on e.EventID = piks.EventId
	inner join core.Account acc on acc.AccountID = e.AccountID
	inner join cre.note n on n.account_accountid=acc.accountid
	where e.EventTypeID = 12 
	group by crenoteid
	having count(piks.startdate)>0
) LoanFeatures) LoanFeaturesu
PIVOT (
  count(LoanFeature) 
  FOR LoanFeature in ([1],[2],[3],[4],[5],[6],[7])
) as FeaturePivot
) a 


