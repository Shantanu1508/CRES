

CREATE View [dbo].[ExitFeeCommitment_Deallevel]
As
Select 
n.Dealkey
,D.Dealid
,D.DealName
,SUM(M61AdjustedCommitment)M61AdjustedCommitment
,SUM(M61Commitment)M61Commitment
,(SUM(ISNULL(M61AdjustedCommitment,0))+MAx(ISNULL(Scheduleprincipallessthantoday,0)))ExtFeeCommitmentBI
,MAX(Scheduleprincipallessthantoday )Scheduleprincipallessthantoday
from Note N
inner join Deal D on D.DealKey = N.DealKey
Outer apply (Select * from ScheduledPricipallessthantoday S
			where s.dealid = d.DealID	)x
where Financingsource <>'3rd Party Owned' and Financingsource<>'Co-Fund'		
group by D.Dealid,D.Dealname,N.DealKey