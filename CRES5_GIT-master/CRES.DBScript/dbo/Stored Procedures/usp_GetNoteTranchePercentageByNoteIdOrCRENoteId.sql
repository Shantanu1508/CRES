CREATE PROCEDURE [dbo].[usp_GetNoteTranchePercentageByNoteIdOrCRENoteId]
@NoteID NVARCHAR(256)
AS
BEGIN
  SET NOCOUNT ON;
   
   select 
	acc.Name,np.TrancheName,np.PercentofNote
	from cre.note n
	inner join cre.Deal d on d.DealID = n.DealID
	inner join core.account acc on acc.accountid = n.account_accountid
	left join cre.NoteTranchePercentage np on np.crenoteid = n.crenoteid
	left join CRE.ClientTrancheMapping ctm on ctm.TrancheName = np.TrancheName and ctm.IsDeleted=0
	where ((len(@NoteID)=36 and cast(n.NoteID as nvarchar(256))=@NoteID)  or n.CRENoteID=@NoteID)
	and isnull(acc.IsDeleted,0)=0
END
