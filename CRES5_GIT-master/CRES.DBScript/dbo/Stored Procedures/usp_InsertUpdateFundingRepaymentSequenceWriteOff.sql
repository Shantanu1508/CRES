

CREATE PROCEDURE [dbo].[usp_InsertUpdateFundingRepaymentSequenceWriteOff] 
	@AutoDistributeWriteOff [TableTypeFundingRepaymentSequenceWriteOff] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN

Update FSW Set FSW.PriorityOverride=TFW.PriorityOverride,
FSW.UpdatedBy=@UpdatedBy,
FSW.UpdatedDate=GETDATE()
FROM [CRE].[FundingRepaymentSequenceWriteOff] FSW
INNER JOIN @AutoDistributeWriteOff TFW ON TFW.NoteID=FSW.NoteID AND TFW.DealID=FSW.DealID

INSERT INTO [CRE].[FundingRepaymentSequenceWriteOff]
    ([DealID]
	,[NoteID]
    ,[PriorityOverride]
    ,[CreatedBy]
    ,[CreatedDate]
    ,[UpdatedBy]
    ,[UpdatedDate])
Select
	[DealID]
	,[NoteID]
	,[PriorityOverride]
	,@CreatedBy
	,Getdate()
	,@UpdatedBy
	,Getdate()
From @AutoDistributeWriteOff Where NoteID NOT IN (Select NoteID from [CRE].[FundingRepaymentSequenceWriteOff] WHERE DealID in (Select top 1 DealID from @AutoDistributeWriteOff))

END