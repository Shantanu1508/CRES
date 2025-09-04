-- View
-- View
CREATE View [dbo].[GAAP_Patterns]
as
select crenoteid, 
	substring (case when StubInterest>0 then 'StubInt,' else '' end + 
	case when PurchasedInterest>0 then 'PurchasedInt,' else '' end + 
	case when PIKLoan>0 then 'PikLoan,' else '' end ,1,
	len(case when StubInterest>0 then 'StubInt,' else '' end + 
	case when PurchasedInterest>0 then 'PurchaseInt,' else '' end + 
	case when PIKLoan>0 then 'PIKLoan,' else '' end 
	)-1) as feature
from (
select crenoteid, 
	[1] as StubInterest,
	[2] as PurchasedInterest,
	[3] as PikLoan
	
	from (
  
  select Crenoteid,loanfeature from (
  
  Select Distinct N.CreNoteid ,1 as LoanFeature --'Unfunded' 
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type  in ( 'StubInterest')  -- Unfunded Loans
						
						and Tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						and tr.AccountTypeID = 1
						 ---Unfunded Loans
Union All
Select Distinct N.CreNoteid ,2 as LoanFeature --'PurchaseInterest' 
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type  in ( 'PurchasedInterest')  -- Unfunded Loans
						
						and Tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						and tr.AccountTypeID = 1

union All

Select crenoteid,3--'PikLoan' 
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
  FOR LoanFeature in ([1],[2],[3])
) as FeaturePivot
) a