CREATE VIEW [dbo].[vwTransactionActuals] AS

SELECT TE.[NoteId] as [NoteId]
,TE.NoteName as [Name]
,TE.[DealID] as [DealID]
,TE.DealName as DealName
,TE.Date as Date
,TE.TR_DueDate as [DueDate]
,TE.TR_RemitDate as [RemitDate]
, TE.TR_TransactionDate as [TransactionDate]
,TE.Type as TransactionType
,(CASE WHEN TE.TR_RemitDate IS NULL THEN TE.Amount ELSE NA.CalculatedAmount END)  as [CalculatedAmount]
,NA.ServicingAmount as ServicingAmount
,NA.OverrideValue as OverrideValue
,NA.CalculateDelta as CalculateDelta
,NA.Adjustment as Adjustment
,NA.M61 as M61
,NA.Servicer as Servicer
,NA.Ignore as Ignore
,NA.Exception as Exception
,NA.comments as comments
,NA.SourceType as SourceType
,na.UsedInCalc as UsedInCalc
,NA.ActualDelta as ActualDelta
, ServicerName
,D.Status
,OverrideReason
,na.CapitalizedInterest -- Added by Anurag
,na.CashInterest	-- Added by Anurag
,NA.BatchLogID
,f.OrigFileName as [FileName]
FROM [dbo].[TransactionEntry] TE
LEFT JOIN [dbo].[NoteActuals] NA ON TE.Note_Type_Date = NA.Note_Type_Date
left join [IO].[FileBatchLog] f on f.BatchLogID = NA.BatchLogID
inner Join dbo.Note N on N.Notekey = TE.NoteKey
inner Join dbo.Deal D on D.DealKey = N.DealKey
WHERE [TE].[Type] in ('InterestPaid',
'ExitFeeExcludedFromLevelYield',
'ExitFeeIncludedInLevelYield',
'ExitFeeStrippingExcldfromLevelYield',
'ExitFeeStripReceivable',
'ExtensionFeeExcludedFromLevelYield',
'ExtensionFeeIncludedInLevelYield',
'ExtensionFeeStrippingExcldfromLevelYield',
'ExtensionFeeStripReceivable',
'ScheduledPrincipalPaid',
'UnusedFeeExcludedFromLevelYield',
'PrepaymentFeeExcludedFromLevelYield'
)
AND [TE].Scenario = 'Default'

--and NA.SourceType  is null
--and (NA.CashInterest is not null or NA.CapitalizedInterest is not null)
GO


