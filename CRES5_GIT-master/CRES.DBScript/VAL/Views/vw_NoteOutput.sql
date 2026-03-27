-- View
-- View
CREATE View [Val].[vw_NoteOutput]
AS
SELECT MarkedDate,[DealID],[DealName],NoteID,NoteName, [Type], [Value]  
FROM   
(
	select md.MarkedDate
	,d.CREDealid as DealID
	,d.DealName
	,n.CRENoteID as NoteID
	,acc.name as NoteName	
	,nout.NoteMarkPriceClean
	,nout.NoteGAAPPriceClean
	,nout.NoteMarkClean
	,nout.NoteUPB
	,nout.NoteCommitment
	,nout.NoteBasisDirty
	,nout.NoteYieldatGAAPBasis
	,nout.NoteMarkYield
	,nout.CalculatedNoteAccruedRate
	,nout.NoteGAAPDMIndex
	,nout.NoteMarkDMgtrFLRIndex
	,nout.NoteDurationonCommitment
	from [val].NoteOutput nout
	Inner join cre.note n on n.noteid = nout.noteid
	Inner join Core.account acc on acc.accountid = n.account_accountid
	Inner join cre.deal d on d.dealid = nout.dealid
	left Join Core.lookup lCalculationStatus on lCalculationStatus.lookupid = nout.CalculationStatus
	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = nout.MarkedDateMasterID
	Where acc.Isdeleted <> 1
	
) p  
UNPIVOT  
(
	[Value] FOR [Type] IN  (
		NoteMarkPriceClean
		,NoteGAAPPriceClean
		,NoteMarkClean
		,NoteUPB
		,NoteCommitment
		,NoteBasisDirty
		,NoteYieldatGAAPBasis
		,NoteMarkYield
		,CalculatedNoteAccruedRate
		,NoteGAAPDMIndex
		,NoteMarkDMgtrFLRIndex
		,NoteDurationonCommitment
	)  
)AS unpvt

