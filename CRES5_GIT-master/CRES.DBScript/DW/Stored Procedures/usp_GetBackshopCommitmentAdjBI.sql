CREATE PROCEDURE [DW].[usp_GetBackshopCommitmentAdjBI] 

AS
BEGIN
     SET NOCOUNT ON;
   

   truncate table [DW].[BackshopCommitmentAdjBI]

   SELECT TOP (1000) [LoanNumber]
      ,[DealName]
      ,[NoteID]
      ,[NoteName]
      ,[AdjustmentDate]
      ,[AdjustmentAmount]
  FROM [DW].[BackshopCommitmentAdjBI]


END