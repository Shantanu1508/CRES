
Create View [dbo].[M61TotalCommitment2]
As
Select N.noteid, d.dealid,D.dealname,
ISNULL(n.InitialFundingAmount,0)InitialFundingAmount
, ISNULL(n3.TotalCurrentAdjustedCommitment,0)TotalCurrentAdjustedCommitment
,d.Status
,n.ActualPayoffDate
,[Date]
,NoteAdjustedTotalCommitment
,NoteAggregatedTotalCommitment
,NoteTotalCommitment
--,hasLinkid
,N.Client
, x.FinancingSource
,NB.Commitment NoteMatrixCommitment
, Validation_Isssue= Case when d.DealName in 
(
'5161 Lankershim','Gateway El Segundo',
'Glendale Office Portfolio','Hard Rock New Orleans','Legacy Central','Millennium on LaSalle',
'Mission Hills Apartments','Queens Multifamily Portfolio - Mod','Tower Burbank',
'Towers @ 2nd' ) Then 'Validation not passing' else 'Validation passed' end 
from Note N
inner join deal d on n.Dealkey = D.Dealkey
 
Left Join uwNote n3 on n.noteid = N3.Noteid
left join [M61TotalCommitment1] X on x.crenoteid = N.noteid
left join notematrixbi nb on nb.noteid = n.noteid
--Where n.Noteid = '6396'