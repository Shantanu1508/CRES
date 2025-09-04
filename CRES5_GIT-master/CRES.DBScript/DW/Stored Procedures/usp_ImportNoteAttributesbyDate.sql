-- Procedure

CREATE PROCEDURE [DW].[usp_ImportNoteAttributesbyDate]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_NoteAttributesbyDateBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


Truncate table [DW].[L_NoteAttributesbyDateBI]

INSERT INTO [DW].[L_NoteAttributesbyDateBI](
[NoteID],
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
na.[NoteID],
na.[Date],
na.[Value],
na.[ValueTypeID],
ty.TransactionName as [ValueTypeBI],
na.[CreatedBy],
na.[CreatedDate],
na.[UpdatedBy],
na.[UpdatedDate],
na.[GeneratedBy],
lGeneratedBy.name as [GeneratedByBI],
NoteAttributesbyDateID
from [CRE].[NoteAttributesbyDate] na  
inner join cre.TransactionTypes ty on ty.TransactionTypesID = na.ValueTypeID  
Left Join core.lookup lGeneratedBy on lGeneratedBy.lookupid = na.GeneratedBy
Where na.noteid in (
	Select distinct noteid from(
		SELECT tdn.NoteID, tdn.CreatedDate, tdn.UpdatedDate FROM CRE.NoteAttributesbyDate tdn
		EXCEPT 
		SELECT dwtd.NoteID, dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].NoteAttributesbyDateBI dwtd
	)a
)





SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportNoteAttributesbyDate - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


