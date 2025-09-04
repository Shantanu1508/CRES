-- Procedure
--[DBO].[usp_CheckDuplicateNoteSettlement] '22-0623','123'
CREATE PROCEDURE [DBO].[usp_CheckDuplicateNoteSettlement] 
(	
	@CREDealID nvarchar(256),
	@CRENoteID nvarchar(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	IF OBJECT_ID('tempdb..[#tbl_ListNotes]') IS NOT NULL                                         
	DROP TABLE [#tbl_ListNotes]

	CREATE TABLE [#tbl_ListNotes](
		CRENoteID VARCHAR(256)
	)

	IF(@CRENoteID <>'')
	BEGIN	
		INSERT INTO [#tbl_ListNotes](CRENoteID)
		select Value from fn_Split(@CRENoteID);
	END;


	IF EXISTS(Select n.NoteID from CRE.Note n 
		inner join core.Account acc on n.Account_AccountID=acc.AccountID 
		Inner join cre.deal d on d.dealid = n.dealid 
		where n.CRENoteID in (select CRENoteID from [#tbl_ListNotes])
		and acc.IsDeleted <> 1 and d.isdeleted <> 1 and d.CREDealID <> @CREDealID
	) 
	BEGIN
		Select 1 as IsDuplicate
	END
	ELSE
	BEGIN
		Select 0 as IsDuplicate
	END


END


