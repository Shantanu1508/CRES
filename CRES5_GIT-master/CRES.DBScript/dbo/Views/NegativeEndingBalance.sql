-- View
CREATE View NegativeEndingBalance
as
Select 
dl.DealName
,n.noteid
, Payoffdate
,d.Date
,EndingBalance 
, hasscheduledprincipal
,PIK_NonPik
,FF_Vs_FundedAtClosing= Case when Value = InitialFundingAmount then 'Fully Funded'
		when (hf.CRENoteID is not null or InitialFundingAmount = 0.01) then 'Has FutureFunding'
		else 'Fully Funded or Funding not yet entered' end
from [CRE].[DailyInterestAccruals] D
Inner join note n on n.notekey = d.Noteid
left Join deal Dl on Dl.Dealkey =  N.Dealkey
Left join payoffdate pd on pd.noteid = n.noteid
left Join CommitmentatClosing c on c.noteid = n.noteid
Left join HasFutureFunding hf on hf.CRENoteID = n.noteid
Where Round(EndingBalance,2) < 0 and n.Actualpayoffdate is null
--
and n.Noteid not like '%Sop%'