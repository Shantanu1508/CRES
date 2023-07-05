CREATE View [dbo].[AddiotnalFeexcluded]  
AS  
Select AB.[DealKey]  
      ,AB.[DealID]  
      ,AB.[NoteId]  
      ,[EffectiveDate]  
      ,AB.[FeeName]  
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
      ,AB.[Amount] FundingRepayments_ScheduledPrincipal  
      ,[EstimatedEndingBalance] , T.Date, T.Type, T.Amount TransEntryAmount, T.FeeName as TransEntryFeename   
   ,ClosingDate  
   ,InitialFundingamount  
   --,EndingbalanceBI = CASE when ClosingDate = StartDate THEN InitialFundingamount  
   --         Else Endingbalance - AB.Amount End  
  ,Totalcommitment  
   from [dbo].[AdditionalFee_Balance] AB  
Left Join DBO.Transactionentry T on AB.Noteid = T.Noteid and AB.Feename = T.Feename  
and T.Date =  AB.Startdate  
  
Left Join DBo.Note N on AB.Noteid = N.Noteid   
--and N.ClosingDate = AB.StartDate  
  
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  
  
and Type = 'AdditionalFeesExcludedFromLevelYield'  
  
  
  