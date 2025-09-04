CREATE PROCEDURE [dbo].[usp_GetLastAccountingCloseDateByDealIDORNoteID]
	@DealID UNIQUEIDENTIFIER = NULL,
	@NoteID UNIQUEIDENTIFIER = NULL
AS

BEGIN

	SET NOCOUNT ON;

	IF(@DealID IS NOT NULL)
	BEGIN
		select top 1 p.CloseDate as [LastCloseDate] 
		from  [Core].[Period] p		 
		where p.DealID=@DealID and
		p.IsDeleted <> 1
		Order by p.CloseDate desc 
	END
	ELSE
	BEGIN
		select top 1 p.CloseDate as [LastCloseDate] 
		from  [Core].[Period] p
		inner join CRE.Note  n on n.DealID= p.DealID 
		where n.NoteID=@NoteID and
		p.IsDeleted <> 1
		Order by p.CloseDate desc  

	END


END





