CREATE View [dbo].[AdditionalFee_Balance]
as 

SELECT [DealKey]
      ,[DealID]
      ,[NoteId]
      ,[EffectiveDate]
      ,[FeeName]
      ,[StartDate]
      ,[EndDate]
      ,[FeeType]
      ,[Value]
      ,[FeeAmountOverride]
      ,[BaseAmountOverride]
      ,[ApplyTrueUpFeature]
      ,[IncludedLevelYield]
      ,[FeetobeStripped]
      ,[EndingBalance]
      ,[Amount]
      ,[EstimatedEndingBalance]
  FROM [DW].[AdditionalFee_BalanceBI]

  


