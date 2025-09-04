    
    
CREATE VIEW [dbo].[NPCEndingBalanceDefaultScenario_Liability]    
AS    
Select AnalysisID,b.Noteid,EndingBalance,PeriodEndDate ,CONCAT(b.Noteid,PeriodEndDate) as NoteidDate ,tblcomm.NoteAdjustedTotalCommitment    
from [DW].[NPCEndingBalanceDefaultScenario] b    
Outer apply(    
 Select top 1 noteid,CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment    
 From(       
  SELECT d.CREDealID    
  ,n.NoteID    
  ,n.CRENoteID    
  ,Date as Date    
  ,nd.Type as Type    
  ,NoteAdjustedTotalCommitment    
  ,NoteTotalCommitment    
  --,nd.NoteID    
  ,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,    
  nd.Rowno    
  from cre.NoteAdjustedCommitmentMaster nm    
  left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID    
  right join cre.deal d on d.DealID=nm.DealID    
  Right join cre.note n on n.NoteID = nd.NoteID    
  inner join core.account acc on acc.AccountID = n.Account_AccountID    
  where d.IsDeleted<>1 and acc.IsDeleted<>1    
  and nm.Date <= b.PeriodEndDate     
  and n.CRENoteID = b.Noteid    
 )a    
 where rno =  1    
)tblcomm     
where PeriodEndDate between '2015-01-01' and '2040-12-31' 