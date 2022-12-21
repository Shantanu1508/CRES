Create  PROCEDURE [dbo].[usp_getFeeSplitReconcileTransaction]      
@TmpreconTrans TableTypeTranscationRecon READONLY    
    
AS      
BEGIN    

 --insert into temp11	select * from @TmpreconTrans

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
Select NOteid,Date,Type,(case when type like '%exit%' Then 'ExitFee' when type like '%extension%' Then 'ExtensionFee' when type ='PrepaymentFeeExcludedFromLevelYield' Then 'PrepaymentFee'      
when type ='UnusedFeeExcludedFromLevelYield' Then 'UnusedFee'    when type ='ScheduledPrincipalPaid' Then 'ScheduledPrincipalPaid'   
END),    
round(isnull(amount,0),2) as  Amount    
from cre.transactionentry  where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     
and type in (    
'ExitFeeExcludedFromLevelYield',    
'ExitFeeIncludedInLevelYield',    
'ExitFeeStrippingExcldfromLevelYield',    
'ExitFeeStripReceivable' ,  
'ExtensionFeeExcludedFromLevelYield',    
'ExtensionFeeIncludedInLevelYield',    
'ExtensionFeeStrippingExcldfromLevelYield',    
'ExtensionFeeStripReceivable'    ,
'ScheduledPrincipalPaid'
--'PrepaymentFeeExcludedFromLevelYield',    
--'UnusedFeeExcludedFromLevelYield'    
)    
and NOteid  in (select distinct NoteID from @TmpreconTrans)   
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

Select 
@Transactionid as Transactionid,
Date as DueDate,
@RemittanceDate as RemittanceDate,
@DealId as dealid ,
Noteid,
grouptype as TransactionType,
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
and  tre.Date not in (Select RelatedtoModeledPMTDate from cre.NoteTransactionDetail ntt left join cre.note n on n.NoteID=ntt.NoteID where ntt.TransactionTypeText like '%'+@TransactionType+'%'  and ntt.NoteID=@NoteId)
 group  by Date,Noteid,grouptype

END