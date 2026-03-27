CREATE Procedure [dbo].[usp_GetPrepaymentNoteSetup]
(
 @DealID UNIQUEIDENTIFIER
)
as 
BEGIN
	SET NOCOUNT ON;

	Select 
   pn.PrepaymentNoteSetupID,
   pn.DealID,
   pn.NoteID,
   n.CRENoteID,
   pn.AttributeName,
   pn.AttributeValue,
   pn.CreatedBy,
   pn.CreatedDate,
   pn.UpdatedBy,
   pn.UpdatedDate

   from [CRE].[PrepaymentNoteSetup] pn
   Left Join cre.Note n on n.NoteID = pn.NoteID
   where pn.DealID = @DealID and ISNULL(pn.IsDeleted,0) <> 1

END