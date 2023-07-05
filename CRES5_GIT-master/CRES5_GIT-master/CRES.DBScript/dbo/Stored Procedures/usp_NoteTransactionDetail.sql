  
CREATE PROCEDURE [dbo].[usp_NoteTransactionDetail]

@TableTypeNoteTransactionDetail [TableTypeNoteTransactionDetail] READONLY,
@NoteId UNIQUEIDENTIFIER,
@CreatedBy  nvarchar(256)

AS
BEGIN
    SET NOCOUNT ON;

 
DELETE FROM [Cre].NoteTransactionDetail WHERE [NoteID]  = @NoteId 

INSERT INTO [Cre].NoteTransactionDetail 
           (
		   [NoteID]
           ,TransactionType 
           ,[TransactionDate]
           ,[Amount]
           ,[RelatedtoModeledPMTDate]
		   ,[CreatedBy]
		  ,[CreatedDate]
		  ,[UpdatedBy]
		  ,[UpdatedDate]
            )
	Select
	@NoteId,
	(Select LookupID from CORE.Lookup where Name = TransactionTypeText and ParentID = 39),
	[TransactionDate],
	[TransactionAmount],
    [RelatedtoModeledPMTDate],	 
	@CreatedBy,
	GETDATE(),
	@CreatedBy,
	GETDATE()
	FROM @TableTypeNoteTransactionDetail

    
END
