-- Procedure
--Drop  PROCEDURE [dbo].[usp_getFeeSplitReconcileTransaction]  
  
Create  PROCEDURE [dbo].[usp_getFeeSplitReconcileTransaction]        
@TmpreconTrans TableTypeTranscationRecon READONLY      
      
AS        
BEGIN      

  
--Declare @tblDateRange as table(Date date)    
  
IF OBJECT_ID('tempdb..#TempTransactionEntry') IS NOT NULL                                                 
 DROP TABLE #TempTransactionEntry      
         
CREATE TABLE #TempTransactionEntry      
(      
 Noteid UNIQUEIDENTIFIER,      
 Date date,      
 type nvarchar(256),      
 grouptype nvarchar(256),        
 amount decimal(28,15)      
)      




      
INSERT INTO  #TempTransactionEntry(Noteid,Date,type,grouptype,amount)  

Select Noteid,Date,Type,grouptype,sum(Amount) as Amount
from(
	Select Noteid,Date
	,(CASE WHEN Type in ('ExitFeeIncludedInLevelYield','ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable') THEN 'ExitFeeExcludedFromLevelYield' 
	WHEN Type in ('ExtensionFeeIncludedInLevelYield','ExtensionFeeStrippingExcldfromLevelYield','ExtensionFeeStripReceivable') THEN 'ExtensionFeeExcludedFromLevelYield'
	WHEN Type in ('AdditionalFeesExcludedFromLevelYield','AdditionalFeesIncludedInLevelYield','AddlFeesStrippingExcldfromLevelYield','AdditionalFeesStripReceivable') THEN 'AdditionalFeesExcludedFromLevelYield' 
	ELSE [Type] END) as [Type],

	(case when type like '%exit%' Then 'ExitFee' 
	when type like '%extension%' Then 'ExtensionFee' 
	when type ='PrepaymentFeeExcludedFromLevelYield' Then 'PrepaymentFee'        
	when type ='UnusedFeeExcludedFromLevelYield' or type like '%AdditionalFees%' OR type Like '%AddlFees%' Then 'UnusedFeeExcludedFromLevelYield' 
	when type ='ScheduledPrincipalPaid' Then 'SP_PIKPP_PYDN'  
	when type ='PIKPrincipalPaid' Then 'SP_PIKPP_PYDN'  
	when type like '%AdditionalFees%' OR type Like '%AddlFees%'  or type ='UnusedFeeExcludedFromLevelYield' Then 'AdditionalFeesExcludedFromLevelYield' 
	 when type = 'Balloon' Then 'SP_PIKPP_PYDN' 
	 when type in ('InterestPaid','PIKInterestPaid') Then 'InterestPaid_PIKPP' 
	END) as grouptype,      
	round(isnull(amount,0),2) as  Amount      
	from cre.transactionentry  tr
	Inner join core.Account acc on acc.AccountID = tr.AccountID
	Inner join cre.note n on n.Account_AccountID = acc.AccountID
	where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
	and type in (      
	'ExitFeeExcludedFromLevelYield',      
	'ExitFeeIncludedInLevelYield',      
	'ExitFeeStrippingExcldfromLevelYield',      
	'ExitFeeStripReceivable' , 

	'ExtensionFeeExcludedFromLevelYield',      
	'ExtensionFeeIncludedInLevelYield',      
	'ExtensionFeeStrippingExcldfromLevelYield',      
	'ExtensionFeeStripReceivable'    ,  

	'ScheduledPrincipalPaid',  
	'PIKPrincipalPaid' , 
	'Balloon',
	'InterestPaid',
	'PIKInterestPaid'

	--'PrepaymentFeeExcludedFromLevelYield',      
	,'UnusedFeeExcludedFromLevelYield'  
	,'AdditionalFeesExcludedFromLevelYield','AdditionalFeesIncludedInLevelYield','AddlFeesStrippingExcldfromLevelYield','AdditionalFeesStripReceivable'
	)      
	and n.Noteid  in (select distinct NoteID from @TmpreconTrans)
)z
group by Noteid,Date,Type,grouptype    

Union all  

Select n.NOteid,Date,Type,(case when type ='FundingOrRepayment' Then 'SP_PIKPP_PYDN' END),  
round(isnull(amount,0),2) as  Amount      
from cre.transactionentry tr
Inner join core.Account acc on acc.AccountID = tr.AccountID
Inner join cre.note n on n.Account_AccountID = acc.AccountID
 where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'       
and type='FundingOrRepayment'   
and PurposeType in (Select name from core.lookup where parentid = 50 and [Value] = 'Negative' and [Name] <> 'Amortization')  
and n.NOteid  in (select distinct NoteID from @TmpreconTrans)     
    
    
--and date not in (select distinct TransactionDate from cre.NotetransactionDetail where noteid=(select distinct NoteID from @TmpreconTrans))  
  
IF OBJECT_ID('tempdb..#TempSplitTransaction') IS NOT NULL                                                 
 DROP TABLE #TempSplitTransaction      
     
Declare @TransactionID UNIQUEIDENTIFIER    
Declare @NoteID UNIQUEIDENTIFIER      
Declare @RemittanceDate Date  
Declare @TransactionType nvarchar(256)   
   
Declare @DealId UNIQUEIDENTIFIER   
Declare @DateDue date    
Declare @TransactionDate date      
Declare @CalculatedAmount decimal(28,15)      
Declare @ServicingAmount decimal(28,15)      
Declare @M61Value bit      
Declare @ServicerValue bit      
Declare @Ignore bit      
Declare @OverrideValue decimal(28,15)      
Declare @comments nvarchar(256)      
Declare @BatchLogID int      
Declare @Exception nvarchar(256)      
Declare @Adjustment decimal(28,15)      
Declare @AddlInterest decimal(28,15)      
Declare @OverrideReason nvarchar(256)      
Declare @InterestAdj decimal(28,15)      
Declare @ServcerMasterID int      
Declare @TotalInterest decimal(28,15)   
Declare @BerAddlint decimal(28,15)      
Declare @Delta decimal(28,15)       
Declare  @ActualDelta decimal(28,15)    
select   
@TransactionID=tr.Transcationid  
,@NoteID=tr.NoteID  
,@TransactionType=tr.TransactionType  
,@DealId = tr.dealid    
 ,@DateDue = tr.Datedue   
 ,@RemittanceDate=tr.RemittanceDate  
 ,@TransactionDate = tr.TransactionDate      
 ,@CalculatedAmount = tr.CalculatedAmount      
 ,@ServicingAmount = tr.ServicingAmount    
  ,@Delta  =tr.Delta  
 ,@ActualDelta=tr.ActualDelta  
  ,@Adjustment = tr.Adjustment     
 ,@M61Value = tr.M61Value      
 ,@ServicerValue = tr.ServicerValue      
 ,@Ignore = tr.Ignore      
 ,@OverrideValue = tr.OverrideValue    
 ,@comments = tr.comments      
 ,@BatchLogID = tr.BatchLogID      
 ,@Exception = tr.Exception      
    
 ,@AddlInterest = tr.AddlInterest   
 ,@TotalInterest=tr.TotalInterest     
 ,@OverrideReason = tr.OverrideReason      
 ,@InterestAdj = tr.InterestAdj      
 ,@ServcerMasterID = tr.ServcerMasterID    
 ,@BerAddlint = tr.BerAddlint   
 from cre.TranscationReconciliation tr inner join @TmpreconTrans tmp on tr.[Transcationid]  =tmp.Transcationid    
 -- where (isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or tr.OverrideValue is not null)        
--;WITH CTE AS  
--(  
--  SELECT DateAdd(day,-15,@RemittanceDate) Date  
--  UNION ALL  
--  SELECT DateAdd(day,1,Date)  FROM CTE WHERE DateAdd(day,1,Date) <= DateAdd(day,15,@RemittanceDate)  
--)  
--INsert  into @tblDateRange(Date)  
--SELECT Distinct dbo.Fn_GetnextWorkingDays(Date,-1,'PMT Date') FROM CTE  
  
--DECLARE @SDate DATETIME  
--DECLARE @TDate DATETIME  
  
--SET @SDate = (Select Date as startdate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)  
--SET @TDate = (Select Date as enddate from @tblDateRange  where date > @RemittanceDate order by date OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)  
If(@TransactionType='ScheduledPrincipalPaid' or @TransactionType='FundingOrRepayment' or @TransactionType='PIKPrincipalPaid'  or @TransactionType='Balloon')  
BEGIN
	Set @TransactionType ='SP_PIKPP_PYDN'  
END

If(@TransactionType='InterestPaid' or @TransactionType='PIKInterestPaid' )  
BEGIN
	Set @TransactionType ='InterestPaid_PIKPP'  
END

Select   
@Transactionid as Transactionid,  
Date as DueDate,  
@RemittanceDate as RemittanceDate,  
@DealId as dealid ,  
Noteid,  
grouptype as TransactionType,  
[type] as Org_TransactionType,  
round(sum(amount),2) as 'M61Amount',  
@ServicingAmount as ServicingAmount ,    
round(@CalculatedAmount,2) as CalculatedAmount ,  
round(@Delta,2) as Delta,  
round(@Adjustment,2) as Adjustment,  
round(@ActualDelta,2) as ActualDelta,  
@M61Value as M61Value,    
@ServicerValue as ServicerValue,    
 @Ignore as Ignore,  
null as 'ServicingAmount_Distr',  
null as 'OverrideValue',  
null as comments  
 ,@TransactionDate as TransactionDate   
 ,@OverrideReason as OverrideReason   
   ,@Exception as Exception      
   ,@AddlInterest as AddlInterest   
   ,@TotalInterest AS TotalInterest  
   ,@InterestAdj as InterestAdj   
  ,@ServcerMasterID as ServcerMasterID  
  ,@BatchLogID as BatchLogID  
 --,@OverrideValue as OverrideValue     
  ,0 as Received  
 ,@BerAddlint as BerAddlint   
 from #TempTransactionEntry tre       
   
where  tre.Noteid = @NoteID       
and tre.grouptype = @TransactionType      
--and tre.Date < @TDate   
and  tre.Date not in (
	Select RelatedtoModeledPMTDate from cre.NoteTransactionDetail ntt 
	left join cre.note n on n.NoteID=ntt.NoteID 
	where --ntt.TransactionTypeText like '%'+@TransactionType+'%'  
	
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ntt.TransactionTypeText,'ScheduledPrincipalPaid','SP_PIKPP_PYDN'),'PIKPrincipalPaid','SP_PIKPP_PYDN'),'FundingOrRepayment','SP_PIKPP_PYDN'),'InterestPaid','InterestPaid_PIKPP') ,'PIKInterestPaid','InterestPaid_PIKPP') like '%'+@TransactionType+'%'  
	
	and ntt.NoteID=@NoteId
	and ntt.ServicerMasterID <> 5
)  
 group  by Date,Noteid,grouptype,type  
  
END  