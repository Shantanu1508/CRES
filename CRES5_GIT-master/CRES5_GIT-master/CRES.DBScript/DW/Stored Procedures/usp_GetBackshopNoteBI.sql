
CREATE PROCEDURE [DW].[usp_GetBackshopNoteBI] 

AS
BEGIN
     SET NOCOUNT ON;
   

   truncate table [DW].[BackshopNoteBI]

   SELECT [LoanNumber]
      ,[DealName]
      ,[NoteID]
      ,[NoteName]
      ,[ServicerLoanNumber]
      ,[FundingDate]
      ,[PastFunding]
      ,[FutureFunding]
      ,[InitialLoanAmount]
      ,[TotalCommitmentAmount]
      ,[TotalCurrentAdjustedCommitment]
      ,[CurrentBalance]
      ,[FinancingSource]
      ,[RSLIC]
      ,[SNCC]
      ,[PIIC]
      ,[TMR]
      ,[HCC]
      ,[USSIC]
      ,[TMNF]
      ,[HAIH]
      ,[TotalParticipation]
  FROM [DW].[BackshopNoteBI]


END