CREATE View dbo.RealizedLoanCashflowcompare_NonFee  
as  
  
Select Distinct  
m61.noteid M61Noteid  
,ig.noteid ExelNoteid  
,ig.[Value] excelamout  
,ig.[Date] excelDate  
,ig.TransactionTypeBI excelValuetype  
,ig.TransactionTypeBI excelTransactiontype  
--,ig.comments excelcommets  
,ig.DelaName excelDealName  
,ig.DealID excelDealid  
,m61.TransactionTypeBI M61TransactionTypeBI  
, m61.TransactionTypeBI M61Type  
,ISNULL(Amount,0) M61AmountBI  
--,ISNull(Amount,0) M61Amount  
,m61.Date M61date  
, M61.Date M61dateBi  
,M61 .Scenario    
,NULL   As feeName  
,TR_CashFlow_Date  
,TR_DueDate  
, M61.TR_RemitDate  
  
, ABS_Delta = ABS(isnull(Amount,0) - ISNULL(Value,0))  
from [dbo].[RealizedCashFlow_IG]  IG    
left join [RealizedCashFlow_TransactionEntry] M61   
on (ig.noteid+'_'+ ig.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),ig.Date, 110) = (m61.noteid+'_'+ m61.TransactionTypeBI + '_' + CONVERT (VARCHAR(10),m61.Date, 110)  ))  
where M61.TransactionTypeBI is not null  
and m61.TransactiontypeBI not in ('AdditionalFee', 'AcoreOriginationFeeExcludedFromLevelYield' , 'ExitFee', 'Extenstionfee', 'OrginationFee')  
and ig.TransactionTypeBI not in ('ExtensionFeeExcludedFromLevelYield')
