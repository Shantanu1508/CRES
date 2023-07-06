
CREATE VIEW [dbo].[FundingSequences] AS
SELECT [FundingRepaymentSequenceID] FundingRepaymentSequenceKey
      ,[NoteID] NoteKey
      ,[CRENoteID]
      ,[SequenceNo] as FundingSequenceID
	  ,[Value] as Amount     
      ,[SequenceTypeBI] as FundingSequenceType      
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [DW].[FundingSequencesBI]