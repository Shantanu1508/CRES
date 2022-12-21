-- View
Create view SumFutureFundingAmount
As

Select ds.Credealid
,ds.Dealname
, Sum(Amount)FF_Amount
,tblFull.Name as isFullPayoff 
from [dbo].[DealFundingSchedule] DS
left join (
Select Distinct CredealID, PurposeID, Name from cre.deal d
left join cre.DealFunding df on df.DealID=d.DealID
left join core.Lookup l on l.LookupID=df.PurposeID
Where PurposeID=630
) tblFull on tblFull.credealID=DS.Credealid

Inner join cre.Deal d1 on d1.credealid = ds.credealid
where Date >CONVERT(Date,GetDate())  and amount>0 and d1.status = 323
--and credealid in  (Select Distinct CredealId from DealLevelBalanceDelphiFFDeals)
Group by ds.Credealid, ds.Dealname, tblFull.Name
GO