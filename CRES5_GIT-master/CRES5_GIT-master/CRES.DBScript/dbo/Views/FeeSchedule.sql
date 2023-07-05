CREATE View [dbo].[FeeSchedule]
as 

SELECT [dealid] as DealKey
      ,[NoteID] as NoteKey
      ,[CREDealID] as DealID
      ,[crenoteid] as NoteId
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
  FROM [DW].[FeeScheduleBI]




