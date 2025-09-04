-- View
-- View
CREATE View [Val].[vw_NoteOutputArchive]
AS
SELECT MarkedDate,[DealID],[DealName],NoteID,NoteName, [Type], [Value]  
FROM   
(
	select am.ArchivemasterID
	,md.MarkedDate
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
	from [val].NoteOutputarchive nout
	Inner join cre.note n on n.noteid = nout.noteid
	Inner join Core.account acc on acc.accountid = n.account_accountid
	Inner join cre.deal d on d.dealid = nout.dealid
	left Join Core.lookup lCalculationStatus on lCalculationStatus.lookupid = nout.CalculationStatus
	Inner join [val].Archivemaster am on am.ArchivemasterID = nout.ArchivemasterID and am.Isdeleted <> 1
	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = am.MarkedDateMasterID
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

