 


CREATE view [dbo].[vw_NoteCapRecon] as      
select  z.* from(        
Select N.noteid,n.[Name] as NoteName,n.ClosingDate,D.DealID,d.DealName,LN.LiabilityNoteID ,G.MaturityDate,        
LN.PledgeDate,LN.TypeName,n.FinancingSource,n.DebtType,G.TargetAdvanceRate,tblcomm.NoteAdjustedTotalCommitment as M61AdjustedCommitment      
,tblfacility.TypeName as FinancingFacility    
---,ISNULL(tblfacility.[DebtEquityType] ,'Whole Loan') as [DebtEquityType]    
,LN.AbbreviationName   
,LN.[AccountID] as LiabilityNoteAccountID
,LN.LiabilitySource
,LFinancingSourceID.IsThirdParty
from Note N         
inner join deal D on n.DealKey=d.DealKey       
inner join vw_LiabilityNoteAssetMappingBI AM  on AM.AssetAccountId=N.AccountID        
inner join vw_LiabilityNoteBI LN on AM.LiabilityNoteAccountId=LN.AccountID        
inner join vw_GeneralSetupDetailsLiabilityNoteBI G on G.LiabilityNoteAccountID=am.LiabilityNoteAccountId  
left join [CRE].[FinancingSourceMaster] LFinancingSourceID on LFinancingSourceID.FinancingSourceMasterID = n.FinancingSourceID
Left join(    
	 --Select Distinct dealid,TypeName,[DebtEquityType] ,AbbreviationName from vw_LiabilityNoteBI    
	 --where LiabilityNoteID LIKE '%Fin%'   
	Select dealid,TypeName ,AbbreviationName
	From(
		Select Distinct dealid,TypeName,[DebtEquityType] ,AbbreviationName ,ln.PledgeDate,ln.[LatestEffectiveDate]
		,ROW_NUMBER() Over (Partition by dealid,AbbreviationName Order by dealid,AbbreviationName,ln.[LatestEffectiveDate] desc) rno
		from vw_LiabilityNoteBI    ln
		where LiabilityNoteID LIKE '%Fin%'   
		---and dealid = '5233161B-B9B8-470C-A541-59D0463E0794'
	)a where rno = 1
)tblfacility on tblfacility.DealID = d.DealKey  and tblfacility.AbbreviationName = LN.AbbreviationName   
    
Left Join(    
 Select noteid,CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment    
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
  --and n.crenoteid in ( '19422')     
 )a    
 where rno =  1    
)tblcomm on tblcomm.NoteID = N.Notekey    
    
Where ScheduleType='Latest'        
and NOT LN.LiabilityNoteID like '%_PS_%'       
and NOT LN.LiabilityNoteID like '%_PE_%'     

)z      
    