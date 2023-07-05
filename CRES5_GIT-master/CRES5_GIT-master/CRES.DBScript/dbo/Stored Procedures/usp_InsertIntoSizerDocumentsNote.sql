
CREATE PROCEDURE [dbo].[usp_InsertIntoSizerDocumentsNote] 
@ObjectID nvarchar(256),
@DocLink nvarchar(256),
@DocTypeID int,
@UpdatedBy nvarchar(256)
AS
BEGIN

--select * from cre.FundingRepaymentSequence
INSERT INTO [CRE].[SizerDocuments]
	([ObjectTypeID]
	,[ObjectID]
	,DocLink
	,[DocTypeID]	 
	,CreatedBy
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])
	values
	(
		 (select LookupID from Core.Lookup where ParentID=27  and name ='note')
		,(select top 1 NoteID from cre.Note where creNoteID=@ObjectID)	
		,@DocLink
		,@DocTypeID
		,@UpdatedBy
		,getdate()
		,@UpdatedBy
		,getdate()
	)

END