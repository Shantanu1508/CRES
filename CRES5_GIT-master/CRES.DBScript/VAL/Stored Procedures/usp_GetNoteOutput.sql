
CREATE PROCEDURE [VAL].[usp_GetNoteOutput]  --'Afghanistan Time'
(
	@MarkedDate date,
	@TimeZoneName nvarchar(250)
)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	select 
	lCalculationStatus.name as CalculationStatus	 
	,isnull( [dbo].[ufn_GetTimeByTimeZoneName] (nout.LastCalculatedOn,@TimeZoneName ),nout.LastCalculatedOn)  as LastCalculatedOn
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
	Where nout.MarkedDateMasterID = @MarkedDateMasterID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
