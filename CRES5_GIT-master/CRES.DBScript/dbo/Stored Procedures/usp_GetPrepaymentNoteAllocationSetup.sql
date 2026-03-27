CREATE Procedure [dbo].[usp_GetPrepaymentNoteAllocationSetup]
(
 @DealID UNIQUEIDENTIFIER
)
as 
BEGIN
	SET NOCOUNT ON;

	Select 
   pn.PrepaymentNoteAllocationSetupID,
   pn.DealID,
   pn.NoteID,
   n.CRENoteID,
   acc.Name as NoteName,
   n.lienposition,
   lLienPosition.name as LienPositionText,
   n.Priority,
   pn.GroupID,
   pn.GroupPriority,
   pn.Exclude,
   lExclude.name as ExcludeText,
   pn.CreatedBy,
   pn.CreatedDate,
   pn.UpdatedBy,
   pn.UpdatedDate

   from [CRE].[PrepaymentNoteAllocationSetup] pn
   Left Join cre.Note n on n.NoteID = pn.NoteID
   Left Join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
   Left Join core.lookup lExclude on lExclude.lookupid = pn.Exclude
   Left Join core.lookup lLienPosition on lLienPosition.lookupid = n.lienposition
   where pn.DealID = @DealID

END