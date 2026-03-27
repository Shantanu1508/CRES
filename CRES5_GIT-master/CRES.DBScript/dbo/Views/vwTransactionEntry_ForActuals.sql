-- View  
CREATE VIEW [dbo].[vwTransactionEntry_ForActuals]   
AS  
Select TE.[NoteId] as [NoteId]      
,n.Name as NoteName      
,TE.[DealID] as [DealID]      
,TE.DealName as DealName      
,TE.[Date] as Date      
,TE.[Date] as TR_DueDate    
,TE.TR_TransactionDate as [TR_TransactionDate]      
,TE.Type    
,TE.TR_RemitDate as TR_RemitDate   
,TE.Amount   
,TE.NOtekey as NoteKey  
,(TE.noteid + '_' + Type + '_' + CONVERT(VARCHAR(10), DATE, 110)) as Note_Type_Date  
,N.FinancingSourceBI  
,[TE].Scenario as Scenario  
,TE.AccountTypeID  
  
,te.IndexValue  
,te.SpreadPercentage  
,te.[OriginalIndex]  
,te.EffectiveRate  
  
FROM dbo.TransactionEntry TE--[DW].[TransactionEntryBI] TE   
Inner JOIN DW.NoteBI N ON N.Noteid = TE.NoteKey      
--LEFT JOIN [dbo].[NoteActuals] NA ON TE.Note_Type_Date = NA.Note_Type_Date      
--left join [IO].[FileBatchLog] f on f.BatchLogID = NA.BatchLogID      
--inner Join dbo.Note N on N.Notekey = TE.NoteKey      
--inner Join dbo.Deal D on D.DealKey = N.DealKey      
WHERE [TE].[Type] in (Select transactiontype From(
	Select Distinct transactiontype from [NoteActuals]
	UNION
	Select transactionname as transactiontype  from cre.TransactionTypes where transactionname in (
	'InterestPaid',    
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
	'PrepaymentFeeExcludedFromLevelYield' ,  
	'PIKPrincipalPaid',  
	'FundingOrRepayment' ,
	'PIKInterest', 
	'PIKInterestPaid',
	'AdditionalFeesExcludedFromLevelYield',
	'StubInterest',
	'PurchasedInterest'
	)
)x
)
     
AND [TE].scenario = 'Default'      
and TE.AccountTypeID = 1    