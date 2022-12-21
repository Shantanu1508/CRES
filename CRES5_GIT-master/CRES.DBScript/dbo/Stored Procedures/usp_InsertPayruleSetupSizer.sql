
Create PROCEDURE [dbo].[usp_InsertPayruleSetupSizer] 
@creDealID nvarchar(256),
@StripTransferFromCreNoteID nvarchar(256),
@StripTransferToCreNoteID nvarchar(256),
@Value decimal(28,15),
@RuleID int,
@UpdatedBy nvarchar(256)
AS
BEGIN

--select * from cre.FundingRepaymentSequence
INSERT INTO [CRE].[PayruleSetup]
	([DealID]
	,[StripTransferFrom]
	,[StripTransferTo]
	,[Value]
	,[RuleID]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])
	values
	(
		(select top 1 DealID from cre.Deal where creDealID=@creDealID)
		,(select top 1 NoteID from cre.Note where creNoteID=@StripTransferFromCreNoteID)
		,(select top 1 NoteID from cre.Note where creNoteID=@StripTransferToCreNoteID)
		,@Value
		,@RuleID
		,@UpdatedBy
		,getdate()
		,@UpdatedBy
		,getdate()
	)

END
