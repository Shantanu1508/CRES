CREATE View [dbo].[TransactionEntryPivot]
as 

SELECT [NoteID]  as [NoteKey]
      ,[AnalysisName]
      ,[Crenoteid] as [NoteID]
      ,[Date]
      ,[FeeName]
      ,[ScheduledPrincipalPaid]
      ,[ExitFeeExcludedFromLevelYield]
      ,[Balloon]
      ,[Funding]
      ,[Repayment]
  FROM [DW].[TransactionEntryPivotBI]


  


