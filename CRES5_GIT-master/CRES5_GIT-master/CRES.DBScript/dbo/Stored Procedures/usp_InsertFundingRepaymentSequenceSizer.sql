
CREATE PROCEDURE [dbo].[usp_InsertFundingRepaymentSequenceSizer] 
@creNoteID nvarchar(256), 
@SequenceNo int,
@SequenceType int,
@Value decimal(28,15),
@UpdatedBy nvarchar(256)
AS
BEGIN


DECLARE @accountID varchar(256)
DECLARE @NoteID varchar(256)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID
WHERE n.CRENoteID=@creNoteID  
SELECT @NoteID = n.NoteID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID
WHERE n.CRENoteID=@creNoteID  

INSERT INTO [CRE].[FundingRepaymentSequence]
(
	 [NoteID]
	,[SequenceNo]
	,[SequenceType]
	,[Value]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])
	values
	(@NoteID,@SequenceNo,@SequenceType,@Value,@UpdatedBy,getdate(),@UpdatedBy,getdate())

END
