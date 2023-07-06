

CREATE PROCEDURE [DW].[usp_MergeFundingSequences]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'FundingSequencesBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_FundingSequencesBI'





truncate table [DW].[FundingSequencesBI]

INSERT INTO [DW].[FundingSequencesBI]
           ([FundingRepaymentSequenceID]
,[NoteID]
,[CRENoteID]
,[SequenceNo]
,[SequenceType]
,[SequenceTypeBI]
,[Value]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])

Select  
fs.[FundingRepaymentSequenceID]
,fs.[NoteID]
,n.[CRENoteID]
,fs.[SequenceNo]
,fs.[SequenceType]
,l.Name
,fs.[Value]
,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy]
,fs.[UpdatedDate]
from cre.FundingRepaymentSequence fs
inner join cre.Note n on n.NoteID = fs.NoteID
left join core.Lookup l on l.LookupID = fs.SequenceType and ParentID = 37




DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_FundingSequencesBI'

Print(char(9) +'usp_MergeFundingSequences - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

