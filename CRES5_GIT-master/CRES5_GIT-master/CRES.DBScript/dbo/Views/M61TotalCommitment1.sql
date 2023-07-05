
-- View
Create View [dbo].[M61TotalCommitment1]
as
SELECT CREDealID
,a.CRENoteID
,[Date]
,NoteAdjustedTotalCommitment
,NoteAggregatedTotalCommitment
,NoteTotalCommitment
, ActualPayoffDate
, ISNULL(InitialFundingAmount,0)InitialFundingAmount
, Status
, FinancingSource
, ISNULL(TotalCurrentAdjustedCommitment,0)TotalCurrentAdjustedCommitment
FROM
(SELECT d.CREDealID
,n.CRENoteID,MAX(Date) as Date
,MAX(nd.Type) as Type
,NoteAdjustedTotalCommitment,NoteAggregatedTotalCommitment,NoteTotalCommitment,
ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nm.Noteadjustedcommitmentmasterid desc,Date DESC) as rowno
,MAX(ActualPayoffdate)ActualPayoffdate,mAx(InitialFundingAmount)InitialFundingAmount, MAx(d.status)Status
from cre.NoteAdjustedCommitmentMaster nm
 left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
right join cre.deal d on d.DealID=nm.DealID
Right join cre.note n on n.NoteID = nd.NoteID
inner join core.account acc on acc.AccountID = n.Account_AccountID

where d.IsDeleted<>1 and acc.IsDeleted<>1
group by d.CREDealID,n.CRENoteID,NoteAdjustedTotalCommitment,NoteAggregatedTotalCommitment,NoteTotalCommitment,Date, nd.NoteID
,nm.NoteAdjustedCommitmentMasterID
) a


Left Join uwNote n3 on crenoteid = N3.Noteid
--left join cre.deal d on d.DealID=a.DealID
--left join cre.note n on n.NoteID = crenoteid
where rowno = 1