

print('Update ImpactCommitmentCalc');

GO
Update cre.note set ImpactCommitmentCalc = 4

go

Update DW.NOTEBI  set DW.NOTEBI.ImpactCommitmentCalc = a.ImpactCommitmentCalc,DW.NOTEBI.ImpactCommitmentCalcBI = a.ImpactCommitmentCalcBI
from(
	Select noteid,ImpactCommitmentCalc,LImpactCommitmentCalc.name as ImpactCommitmentCalcBI 
	from cre.note n
	left join Core.Lookup LImpactCommitmentCalc ON n.ImpactCommitmentCalc=LImpactCommitmentCalc.LookupID
)a
where DW.NOTEBI.noteid = a.noteid