

CREATE PROCEDURE [DW].[usp_MergeNoteAttributesbyDate]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


UPDATE [DW].BatchDetail
	SET
	BITableName = 'NoteAttributesbyDateBI',
	BIStartTime = GETDATE()
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteAttributesbyDateBI'


IF EXISTS(Select top 1 [NoteAttributesbyDateID] from [DW].[L_NoteAttributesbyDateBI])
BEGIN

	Delete from [DW].[NoteAttributesbyDateBI]	where noteid in (Select distinct noteid from [DW].[L_NoteAttributesbyDateBI])
	
	INSERT INTO [DW].[NoteAttributesbyDateBI]
	([NoteID],
	[Date],
	[Value],
	[ValueTypeID],
	[ValueTypeBI],
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate],
	[GeneratedBy],
	[GeneratedByBI],
	NoteAttributesbyDateID)
	Select
	te.[NoteID],
	te.[Date],
	te.[Value],
	te.[ValueTypeID],
	te.[ValueTypeBI],
	te.[CreatedBy],
	te.[CreatedDate],
	te.[UpdatedBy],
	te.[UpdatedDate],
	te.[GeneratedBy],
	te.[GeneratedByBI],
	te.NoteAttributesbyDateID
	From DW.L_NoteAttributesbyDateBI te
END



DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT



UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteAttributesbyDateBI'

Print(char(9) +'usp_MergeNoteAttributesbyDate - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

