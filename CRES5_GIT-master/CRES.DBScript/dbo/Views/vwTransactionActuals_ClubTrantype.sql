CREATE VIEW [dbo].[vwTransactionActuals_ClubTrantype]  
AS  
Select NoteId  
,Name  
,DealID  
,DealName  
,(select [Value]+'#/dealdetail/'+DealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl
,Date  
,DueDate  
,RemitDate  
,TransactionDate  
,TransactionType     
,SUM(CalculatedAmount) as CalculatedAmount  
,SUM(ServicingAmount) as ServicingAmount  
,SUM(OverrideValue ) as OverrideValue  
,SUM(CalculateDelta ) as CalculateDelta  
,SUM(Adjustment  ) as Adjustment  
,M61  
,Servicer  
,Ignore  
,Exception  
,comments  
,SourceType  
,SUM(UsedInCalc  ) as UsedInCalc  
,SUM(ActualDelta ) as ActualDelta  
,ServicerName  
,Status  
,OverrideReason  
,SUM(CapitalizedInterest) as CapitalizedInterest  
,SUM(CashInterest  ) as CashInterest  
,BatchLogID  
,FileName  
,[FileName_woTime]  
,FinancingSource  
,IndexValue  
,SpreadPercentage  
,OriginalIndex  
,EffectiveRate  
,WatchlistStatus  
,PIKType  
  
From(  
  
 select   
 NoteId  
 ,Name  
 ,DealID  
 ,DealName  
 ,Date  
 ,DueDate  
 ,RemitDate  
 ,TransactionDate     
 ---,REPLACE(REPLACE(REPLACE(TransactionType,'ExitFeeStripReceivable','ExitFee'),'ExitFeeExcludedFromLevelYield','ExitFee') ,'ExitFeeStrippingExcldfromLevelYield','ExitFee') as TransactionType
 ,(CASE WHEN TransactionType like '%exitfee%' then 'ExitFee' ELSE TransactionType END) as   TransactionType
 ,CalculatedAmount  
 ,ServicingAmount  
 ,OverrideValue  
 ,CalculateDelta  
 ,Adjustment  
 ,M61  
 ,Servicer  
 ,Ignore  
 ,Exception  
 ,comments  
 ,SourceType  
 ,UsedInCalc  
 ,ActualDelta  
 ,ServicerName  
 ,Status  
 ,OverrideReason  
 ,CapitalizedInterest  
 ,CashInterest  
 ,BatchLogID  
 ,FileName  
 ,FinancingSource  
 ,IndexValue  
 ,SpreadPercentage  
 ,OriginalIndex  
 ,EffectiveRate  
 ,WatchlistStatus  
 ,PIKType  
 ,(CASE WHEN [FileName] like 'CashFlow_Data%' THEN SUBSTRING([FileName],1,Len([FileName])-9) ELSE [FileName] END) [FileName_woTime]  
 from [DW].[TransactionActuals]  
   
)z  
Group by  NoteId  
,Name  
,DealID  
,DealName  
,Date  
,DueDate  
,RemitDate  
,TransactionDate  
,TransactionType     
--,SUM(CalculatedAmount) as CalculatedAmount  
--,SUM(ServicingAmount) as ServicingAmount  
--,SUM(OverrideValue ) as OverrideValue  
--,SUM(CalculateDelta ) as CalculateDelta  
--,SUM(Adjustment  ) as Adjustment  
,M61  
,Servicer  
,Ignore  
,Exception  
,comments  
,SourceType  
--,SUM(UsedInCalc  ) as UsedInCalc  
--,SUM(ActualDelta ) as ActualDelta  
,ServicerName  
,Status  
,OverrideReason  
--,SUM(CapitalizedInterest) as CapitalizedInterest  
--,SUM(CashInterest  ) as CashInterest  
,BatchLogID  
,FileName  
,[FileName_woTime]  
,FinancingSource  
,IndexValue  
,SpreadPercentage  
,OriginalIndex  
,EffectiveRate  
,WatchlistStatus  
,PIKType  
GO


