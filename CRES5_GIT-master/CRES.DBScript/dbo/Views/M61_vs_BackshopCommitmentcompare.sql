

CREATE view [dbo].[M61_vs_BackshopCommitmentcompare]
As

Select
M61Note.NoteID
,d.dealid
,d.DealName
,ISNULL(CRENoteID,'None') CRENoteID
,M61Note.Totalcommitment
,OriginalTotalCommitment
,[TotalCommitmentExtensionFeeisBasedOn]
,OriginalTotalCommitmentBI = Case when ISNULL(InitialFundingAmount,0) > ISNull(OriginalTotalCommitment,0) 
Then ISNULL(InitialFundingAmount,0) else ISNULL(OriginalTotalCommitment,0) End
,M61Note.AdjustedTotalCommitment
,Status
,backshopNote.TotalCurrentAdjustedCommitment BacksshopcurrentAdjustedCommitment
, Case when InitialFundingAmount > OriginalTotalCommitment THEN 
abS(ISNUll(InitialFundingAmount ,0)- isnull(M61Note.AdjustedTotalCommitment,0)) 
Else abS(ISNUll(OriginalTotalCommitment ,0)- isnull(M61Note.AdjustedTotalCommitment,0)) end M61OrginalCommit_Vs_M61AdjustedCommiment
,abs(ISNUll(OriginalTotalCommitment ,0) - ISNull(backshopNote.TotalCurrentAdjustedCommitment,0) )M61OrginalCommit_Vs_backshopAdjustedCommiment
,abs(ISNUll(M61Note.AdjustedTotalCommitment ,OriginalTotalCommitment) - ISNull(backshopNote.TotalCurrentAdjustedCommitment,0) )M61AdjustedCommit_Vs_backshopAdjustedCommiment
,ActualPayoffdate
,FullyExtendedMaturityDate
, MaturityDateBI = CASe when Actualpayoffdate is NULL then FullyExtendedMaturitydate else ActualpayoffDate end
, MaturityDateBI2 = CASe when Actualpayoffdate is NULL then FullyExtendedMaturitydate else ActualpayoffDate end
,FundedAmount
, NotesLaterClosingDates= Case when CreNoteid in (Select Distinct Noteid from NotesafterNoteTransfer) Then 'Notes Later Closing Dates' end
from cre.Note M61Note
inner join uwnote backshopNote on Convert(varchar(10), backshopNote.NoteID) = M61Note.CRENoteID
inner join deal d on M61note.DealID = d.dealkey
where d.status = 'active'


