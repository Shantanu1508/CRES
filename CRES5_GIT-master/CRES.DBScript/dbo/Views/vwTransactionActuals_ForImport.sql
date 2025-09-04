-- View  

CREATE VIEW [dbo].[vwTransactionActuals_ForImport] AS    
SELECT TE.[NoteId] as [NoteId]      
,TE.NoteName as [Name]      
,TE.[DealID] as [DealID]      
,TE.DealName as DealName      
,TE.Date as Date      
,TE.TR_DueDate as [DueDate]      
    
--,TE.TR_RemitDate as [RemitDate]    
,NA.RemitDate as [RemitDate]      
    
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
,na.CashInterest -- Added by Anurag      
,NA.BatchLogID      
,f.OrigFileName as [FileName]     
,TE.FinancingSourceBI  as FinancingSource  
  
,te.IndexValue  
,te.SpreadPercentage  
,te.[OriginalIndex]  
,te.EffectiveRate  
,D.WatchlistStatus  
  
FROM [dbo].[vwTransactionEntry_ForActuals]  TE      
LEFT JOIN [dbo].[NoteActuals] NA ON TE.Note_Type_Date = NA.Note_Type_Date      
left join [IO].[FileBatchLog] f on f.BatchLogID = NA.BatchLogID      
inner Join dbo.Note N on N.Notekey = TE.NoteKey      
inner Join dbo.Deal D on D.DealKey = N.DealKey      
   
      
union   
  
  
Select z.NoteId,Name,DealID,DealName,Date,DueDate,RemitDate,TransactionDate,TransactionType,CalculatedAmount,ServicingAmount,OverrideValue,CalculateDelta,Adjustment,M61,Servicer,Ignore,Exception,comments,SourceType,UsedInCalc,ActualDelta,ServicerName,Status,OverrideReason,CapitalizedInterest,CashInterest,BatchLogID,FileName,FinancingSource
/*,(case   
 when TransactionType = 'InterestPaid' then tblTr.LIBORPercentage   
 when (TransactionType = 'StubInterest' and  RateType = 140) then InitialIndexValueOverride --n.StubInterestRateOverride   
 when TransactionType in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.PIKLiborPercentage    
 else null end) as IndexValue ---LIBORPercentage,  
,(case   
  when TransactionType in ('InterestPaid','StubInterest') then tblTr.SpreadPercentage   
  when TransactionType in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.PIKInterestPercentage   
  else null   
  end  
 ) as SpreadPercentage   
,(case when TransactionType = 'InterestPaid' then tblTr.RawIndexPercentage   
 when TransactionType in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.RawPIKIndexPercentage   
 else null end) as [OriginalIndex] --- RawIndexPercentage       
 */



,ISNULL(tblTr.IndexValue,tblTr_Overreason.IndexValue) as IndexValue
,ISNULL(tblTr.SpreadValue ,tblTr_Overreason.SpreadValue) as SpreadPercentage	
,ISNULL(tblTr.OriginalIndex,tblTr_Overreason.OriginalIndex) as OriginalIndex
,ISNULL(tblTr.AllInCouponRate,tblTr_Overreason.AllInCouponRate) as EffectiveRate 

--,tblTr.IndexValue as IndexValue
--,tblTr.SpreadValue  as SpreadPercentage	
--,tblTr.OriginalIndex  as OriginalIndex
--,tblTr.AllInCouponRate  as EffectiveRate 


,WatchlistStatus

From(
Select na.NoteKey
,na.[NoteId] as [NoteId]      
,n.Name as [Name]      
,d.[DealID] as [DealID]      
,d.DealName as DealName      
,na.DueDate as Date      
,na.DueDate as [DueDate]     
,NA.RemitDate as [RemitDate]     
,NA.TransactionDate as [TransactionDate]      
,NA.TransactionType as TransactionType      
,NA.CalculatedAmount  as [CalculatedAmount]      
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
,ISNULL(na.UsedInCalc,0) as UsedInCalc      
,NA.ActualDelta as ActualDelta      
,ServicerName      
,D.Status      
,OverrideReason      
,na.CapitalizedInterest -- Added by Anurag      
,na.CashInterest -- Added by Anurag      
,NA.BatchLogID      
,f.OrigFileName as [FileName]    
,N.FinancingSource   
,n.RateType
,n.InitialIndexValueOverride 
,D.WatchlistStatus  

from [dbo].[NoteActuals] na     
left join [IO].[FileBatchLog] f on f.BatchLogID = NA.BatchLogID      
inner Join dbo.Note N on N.Notekey = na.Notekey    
inner Join cre.Note Nm on Nm.noteid = na.Notekey    
inner Join dbo.Deal D on D.DealKey = N.DealKey  
where nm.enablem61Calculations = 3    
and na.TransactionType in (Select transactiontype From(  
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
and NoteTransactionDetailAutoID not in (    
 select Distinct na.NoteTransactionDetailAutoID    
 FROM [dbo].[vwTransactionEntry_ForActuals] TE      
 Left JOIN [dbo].[NoteActuals] NA ON TE.Note_Type_Date = NA.Note_Type_Date      
 left join [IO].[FileBatchLog] f on f.BatchLogID = NA.BatchLogID      
 inner Join dbo.Note N on N.Notekey = TE.NoteKey      
 inner Join dbo.Deal D on D.DealKey = N.DealKey      
 WHERE  na.NoteTransactionDetailAutoID is not null    
)    
and NA.DueDate <= ISNULL(n.actualpayoffdate,n.Fullyextendedmaturitydate)    

)z
Left Join(  
 /*Select analysisID   
 ,Noteid   
 ,date_dt   
 ,LIBORPercentage   
 ,PIKInterestPercentage   
 ,SpreadPercentage   
 ,PIKLiborPercentage   
 ,RawIndexPercentage   
 ,RawPIKIndexPercentage   
 ,EffectiveRate from [DW].[NoteCashflowPercentageColumns] where analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
 */

 Select 
 NoteID
 ,[Date] as date_dt
 ,IndexValue
 ,SpreadValue
 ,OriginalIndex
 ,AllInCouponRate 
 ,[Type]
from [DW].[TransactionEntryBI] where analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
)tblTr on tblTr.noteid = z.NoteKey and tblTr.date_dt = z.DueDate and tblTr.Type = z.TransactionType

Left Join(  
 Select 
 NoteID
 ,[Date] as date_dt
 ,IndexRate as IndexValue
 ,SpreadOrRate as SpreadValue
 ,IndexRate as OriginalIndex
 ,AllInCouponRate 
from [DW].NoteCFPerFromDailyIntAccBI where analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
)tblTr_Overreason on tblTr_Overreason.noteid = z.NoteKey and tblTr_Overreason.date_dt = z.DueDate