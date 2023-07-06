
CREATE view [dbo].[FundingTilldate]
as
Select Noteid
, (SUM(ISNull(Amount,0)) + SUM(InitialFundingamount)) Fundingtilldate 
,SUM( OriginalTotalCommitment )- ((SUM(ISNull(Amount,0)) + SUM(InitialFundingamount))) CommitVsFundingDiff
from NoteFundingSchedule NS
Left join cre.Note n on n.crenoteid = NS.CRENoteID
Where Amount > 0 and purpose <> 'Note Transfer'
--and Date <=Getdate() 
--and ActualPayoffdate is not null 
Group By Noteid