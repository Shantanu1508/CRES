  
CREATE PROCEDURE [Val].[usp_GetNoteOutputArchive]  
  @MarkedDate date
AS        
BEGIN        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
	select 
	lCalculationStatus.name as CalculationStatus
	,nout.LastCalculatedOn
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
	Inner join [val].Archivemaster am on am.ArchivemasterID = nout.ArchivemasterID and am.isdeleted <> 1

	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = am.MarkedDateMasterID
	
	Where md.MarkedDate = @MarkedDate




	
	
	    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END    
  