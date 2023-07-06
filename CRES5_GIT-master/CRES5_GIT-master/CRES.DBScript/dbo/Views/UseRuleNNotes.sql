

Create View [dbo].UseRuleNNotes  
As  
  
  
  
Select Distinct dd.dealid,CredealID,dealname, CreNoteid  
from cre.deal dd  
inner join cre.note nn on nn.dealid = dd.dealid  
where   
ISNULL(nn.UseRuletoDetermineNoteFunding,4) = 4   
and dd.credealid in (  
 --Deal having all notes as 'N'  
 Select CREDealID from (  
 Select Distinct d.CREDealID,l.Name as UseRuletoDetermineNoteFunding  
 from cre.Deal d  
 inner join cre.Note n on n.DealID = d.DealID  
 inner join core.account acc on acc.accountid = n.account_accountid  
 left join core.Lookup l on l.LookupID = ISNULL(n.UseRuletoDetermineNoteFunding,4)  
 where d.isdeleted <> 1 and acc.isdeleted <> 1  
 )a  
 group by CREDealID  
 having count(UseRuletoDetermineNoteFunding) = 1  
)  
and nn.crenoteid in (Select distinct NoteID from [DW].[NoteFundingBI]) --Notes having funding  
  