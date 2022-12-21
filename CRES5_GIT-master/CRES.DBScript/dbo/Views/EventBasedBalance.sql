CREATE View [dbo].[EventBasedBalance]
as 
SELECT [analysisid]
      ,[analysisName]
      ,[Noteid]
      ,[PeriodEndDate]
      ,[EventDate]
      ,[EndingBalance]
      ,[Amount]
      ,[EstimatedEndingBalance]
  FROM [DW].[EventBasedBalanceBI]
  where analysisid in (Select AnalysisID from core.analysis where name = 'Default')

  

