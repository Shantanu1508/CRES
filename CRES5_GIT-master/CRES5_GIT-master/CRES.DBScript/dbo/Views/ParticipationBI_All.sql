  
CREATE VIEW [dbo].[ParticipationBI_All]    
AS   

Select n.crenoteid as NoteID,  
d.credealid as DealID,  
np.PercentofNote as Participation,  
np.TrancheName  as Entity  
,LFinancingSourceID.FinancingSourceName as FinancingSource
,c.ClientName
--,f.FundName
from cre.note n 
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.deal d on d.dealid = n.dealid  
left join CRE.NoteTranchePercentage np on np.crenoteid = n.crenoteid
left join [CRE].[FinancingSourceMaster] LFinancingSourceID on LFinancingSourceID.FinancingSourceMasterID = n.FinancingSourceID
left join cre.Client c on c.ClientID = n.ClientID
--left join cre.Fund f on f.FundID = n.FundID
where acc.isdeleted <> 1 and d.isdeleted <> 1 and acc.statusid <> 2


--and np.TrancheName   in ('RSLIC','SNCC' ,'PIIC' ,'TMR' ,'HCC' ,'USSIC' ,'TMNF' ,'HAIH')  



