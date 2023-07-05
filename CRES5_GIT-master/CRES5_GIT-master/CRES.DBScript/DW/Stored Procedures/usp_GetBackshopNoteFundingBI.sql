CREATE PROCEDURE [DW].[usp_GetBackshopNoteFundingBI] 

AS
BEGIN
     SET NOCOUNT ON;
   

   truncate table [DW].[BackshopNoteFundingBI]

 SELECT [ControlID]
      ,[DealName]
      ,[FundingDate]
      ,[NoteID]
      ,[ServicerLoanNumber]
      ,[NoteName]
      ,[FinancingSource]
      ,[FundingAmount]
      ,[WireConfirm]
      ,[FundingPurpose]
      ,[RSLIC]
      ,[SNCC]
      ,[PIIC]
      ,[TMR]
      ,[HCC]
      ,[USSIC]
      ,[TMNF]
      ,[HAIH]
  FROM [DW].[BackshopNoteFundingBI]


END