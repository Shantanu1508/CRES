CREATE View [dbo].[FeeSchedule_ExitFee]
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
  FROM [DW].[FeeScheduleBI] F
  Where  fEEnAME = ( sELECT   cASE WHEN   EXISTS (sELECT FeeName
											from  [CORE].PrepayAndAdditionalFeeSchedule pafs1
											INNER JOIN [CORE].[Event] e on e.EventID = pafs1.EventId
											Inner join cre.Note  N on N.Account_AccountID = E.Accountid 
											WHERE F.cRENOTEID = N.cRENOTEID 
											AND pafs1.VALUETYPEID = 1
											--AND pafs1.sTARTdATE = pafs.sTARTDATE 
											--AND pafs1.eNDDATE = pafs.eNDDATE 
											AND pafs1.FeeNamE = 'Exit Fee #2'  
											
											--and pafs.FeeName = 'Exit Fee #2'
											) 
											
											
			Then 'Exit Fee #2' 

			eLSE 'Exit Fee #1'
			 End
			 )
			 and F.FeeType = 'Exit Fee'





