-- Procedure
  --  Drop  PROCEDURE [dbo].[usp_FeeReconcileTransaction]    
CREATE  PROCEDURE [dbo].[usp_FeeReconcileTransaction]            
@TmpreconTrans TableTypeTranscationRecon READONLY ,          
@CreatedBy nvarchar(256)              
AS            
BEGIN           
          
      
          
---insert into temp11 select * from @TmpreconTrans      
  
  
      
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
Select n.Noteid,Date,Type,(case when type like '%exit%' Then 'ExitFee' 
when type like '%extension%' Then 'ExtensionFee' 
when type ='PrepaymentFeeExcludedFromLevelYield' Then 'PrepaymentFee'            
when type ='UnusedFeeExcludedFromLevelYield' Then 'UnusedFee'     
when type ='FundingOrRepayment' Then 'FundingOrRepayment'   
when type like '%AdditionalFees%' OR type Like '%AddlFees%' Then 'AdditionalFeesExcludedFromLevelYield' 
when type ='ScheduledPrincipalPaid' Then 'ScheduledPrincipalPaid' 
when type ='PIKPrincipalPaid' Then 'PIKPrincipalPaid' 
when type ='Balloon' Then 'Balloon'  
when type ='InterestPaid' Then 'InterestPaid' 
END) as grouptype,          
round(isnull(amount,0),2) as  Amount           
from cre.transactionentry tr   
Inner join core.account acc on acc.accountid = tr.AccountID 
Inner join cre.note n on n.account_accountid = acc.accountid  
where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   and acc.AccounttypeID = 1         
and type in (          
'ExitFeeExcludedFromLevelYield',          
'ExitFeeIncludedInLevelYield',          
'ExitFeeStrippingExcldfromLevelYield',          
'ExitFeeStripReceivable',  

'ExtensionFeeExcludedFromLevelYield',          
'ExtensionFeeIncludedInLevelYield',          
'ExtensionFeeStrippingExcldfromLevelYield',          
'ExtensionFeeStripReceivable',  

'PrepaymentFeeExcludedFromLevelYield',          
'UnusedFeeExcludedFromLevelYield' ,
---'FundingOrRepayment'
'AdditionalFeesExcludedFromLevelYield','AdditionalFeesIncludedInLevelYield','AddlFeesStrippingExcldfromLevelYield','AdditionalFeesStripReceivable',
'ScheduledPrincipalPaid',
'Balloon',
'InterestPaid'
--,'PIKPrincipalPaid'
)          
and n.NoteID  in (select distinct NoteID from @TmpreconTrans)   

UNION ALL


Select n.Noteid,Date,Type,'FundingOrRepayment' as grouptype,          
round(isnull(amount,0),2) as  Amount           
from cre.transactionentry tr   
Inner join core.account acc on acc.accountid = tr.AccountID 
Inner join cre.note n on n.account_accountid = acc.accountid  
where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   and acc.AccounttypeID = 1         
and type in ('FundingOrRepayment') 
and tr.Amount > 0   
and n.NoteID  in (select distinct NoteID from @TmpreconTrans)         
--=============================================================          
          
IF OBJECT_ID('tempdb..#TempTransactiondetail') IS NOT NULL                                                     
 DROP TABLE #TempTransactiondetail          
          
CREATE TABLE #TempTransactiondetail          
(          
 [Transactionid] [uniqueidentifier] NULL,        
 rowno int null,        
 [DateDue] [date] NULL,          
 [RemittanceDate] [datetime] NULL,          
 [ServcerMasterID] [int] NULL,          
 [DealId] [uniqueidentifier] NULL,          
 [NoteID] [uniqueidentifier] NULL,          
 [TransactionType] [nvarchar](250) NULL,          
 [TransactionDate] [datetime] NULL,          
 [ServicingAmount] [decimal](28, 15) NULL,          
 [CalculatedAmount] [decimal](28, 15) NULL,          
 [Delta] [decimal](28, 15) NULL,          
 [M61Value] [bit] NULL,          
 [ServicerValue] [bit] NULL,          
 [Ignore] [bit] NULL,          
 [OverrideValue] [decimal](28, 15) NULL,          
 [comments] [nvarchar](max) NULL,          
 [PostedDate] [datetime] NULL,          
 [BatchLogID] [int] NULL,          
 [Deleted] [bit] NULL,          
 [Exception] [nvarchar](256) NULL,          
 [Adjustment] [decimal](28, 15) NULL,          
 [ActualDelta] [decimal](28, 15) NULL,          
 [AddlInterest] [decimal](28, 15) NULL,          
 [TotalInterest] [decimal](28, 15) NULL,          
 [OverrideReason] [int] NULL,          
 [BerAddlint] [decimal](28, 15) NULL,          
 [InterestAdj] [decimal](28, 15) NULL  , 
 [WriteOffAmount] [decimal](28, 15) NULL   
 
)          
--=============================================================          
          
Declare @DealId UNIQUEIDENTIFIER          
Declare @NoteID UNIQUEIDENTIFIER          
Declare @DateDue date          
Declare @RemittanceDate date          
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
Declare @TransactionType nvarchar(256)          
Declare @BerAddlint decimal(28,15)          
Declare @TransactionID UNIQUEIDENTIFIER        
Declare @SplitTransactionid UNIQUEIDENTIFIER      
Declare @tblDateRange as table(Date date)           
declare @WriteOffAmount decimal(28,15)       

------Added by Vishal-----------
declare @tbltranrecon as table(
Transcationid UNIQUEIDENTIFIER,
NoteID UNIQUEIDENTIFIER,
ignore bit
)
Insert INto @tbltranrecon(Transcationid,NoteID,ignore)
Select  [Transcationid],NoteID,Ignore  from cre.TranscationReconciliation  
where [Transcationid] in (select distinct Transcationid from @TmpreconTrans) 
--------------------------------------------

      
IF CURSOR_STATUS('global','CursorFeeRecon')>=-1          
BEGIN          
 DEALLOCATE CursorFeeRecon          
END          
          
DECLARE CursorFeeRecon CURSOR           
for          
(          
      
 Select [Transcationid] from @tbltranrecon where Ignore <> 1       
)          
OPEN CursorFeeRecon           
          
FETCH NEXT FROM CursorFeeRecon          
INTO @TransactionID          
          
WHILE @@FETCH_STATUS = 0          
BEGIN          
           
 Select           
 @DealId = dealid          
 ,@NoteID = NoteID          
 ,@DateDue = Datedue          
 ,@RemittanceDate = RemittanceDate          
 ,@TransactionDate = TransactionDate          
 ,@CalculatedAmount = CalculatedAmount          
 ,@ServicingAmount = ServicingAmount          
 ,@M61Value = M61Value          
 ,@ServicerValue = ServicerValue          
 ,@Ignore = Ignore          
 ,@OverrideValue = OverrideValue          
 ,@comments = comments          
 ,@BatchLogID = BatchLogID          
 ,@Exception = Exception          
 ,@Adjustment = Adjustment          
 ,@AddlInterest = AddlInterest      
 ,@TotalInterest = TotalInterest     
 ,@OverrideReason = OverrideReason          
 ,@InterestAdj = InterestAdj          
 ,@ServcerMasterID = ServcerMasterID          
 ,@TransactionType = TransactionType          
 ,@BerAddlint = BerAddlint         
 ,@SplitTransactionid=SplitTransactionid  
 ,@WriteOffAmount = WriteOffAmount
 from cre.TranscationReconciliation  where [Transcationid] = @TransactionID           
          
 Delete from  @tblDateRange          
;WITH CTE AS      
(      
  SELECT DateAdd(day,-15,@RemittanceDate) Date      
  UNION ALL      
  SELECT DateAdd(day,1,Date)  FROM CTE WHERE DateAdd(day,1,Date) <= DateAdd(day,15,@RemittanceDate)      
)      
INsert  into @tblDateRange(Date)      
SELECT Distinct dbo.Fn_GetnextWorkingDays(Date,-1,'PMT Date') FROM CTE      
      
DECLARE @SDate DATETIME      
Declare @SevenDaysPrevious DATETIME      
DECLARE @TDate DATETIME      
      
SET @SDate = (Select Date as startdate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)      
set @SevenDaysPrevious=(Select Date as enddate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)        
SET @TDate = (Select Date as enddate from @tblDateRange  where date > @RemittanceDate order by date OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)      
      
      
      
--Select @CalculatedAmount=sum(abs(round(isnull(amount,0),2))) from #TempTransactionEntry t       
-- where t.noteid = @NoteID  and t.Date between @SDate and @RemittanceDate               
-- and t.grouptype in ('ExitFee','PrepaymentFee')      
        
 IF(@CalculatedAmount <> 0)          
 BEGIN          
  IF(@SplitTransactionid is null)          
 BEGIN       
       
      
      
  INSERT INTO #TempTransactiondetail          
           ([Transactionid]         
            ,rowno       
           ,[DateDue]          
           ,[RemittanceDate]          
           ,[ServcerMasterID]          
           ,[DealId]          
           ,[NoteID]          
           ,[TransactionType]          
           ,[TransactionDate]          
           ,[ServicingAmount]          
           ,[CalculatedAmount]          
           ,[Delta]          
           ,[M61Value]          
           ,[ServicerValue]          
           ,[Ignore]          
           ,[OverrideValue]          
           ,[comments]          
           ,[PostedDate]          
           ,[BatchLogID]          
           ,[Deleted]          
           ,[Exception]          
           ,[Adjustment]          
           ,[ActualDelta]          
           ,[AddlInterest]          
           ,[TotalInterest]          
           ,[OverrideReason]          
           ,[BerAddlint]          
           ,[InterestAdj]
           ,WriteOffAmount)   
          
  select  @TransactionID as TransactionID,    
  row_number() OVER (ORDER BY @TransactionID) rowno,          
  --@DateDue as DateDue,          
  tre.Date as DateDue,      
  @RemittanceDate as RemittanceDate,          
  @ServcerMasterID as ServcerMasterID,          
  @DealId as DealId,          
  @NoteID as NoteID,          
  tre.Type,          
  @TransactionDate as TransactionDate,          
  ROUND(isnull(tre.Amount,0)/@CalculatedAmount * @ServicingAmount,2) as ServicingAmount,          
   ROUND(isnull(tre.Amount,0),2) as CalculatedAmount,          
  null as Delta,          
  @M61Value as M61Value,          
  @ServicerValue as ServicerValue,          
  @Ignore as Ignore,          
 -- round(isnull((tre.Amount/@CalculatedAmount)* @OverrideValue,0),2) as OverrideValue,        
  ROUND(isnull((tre.Amount/@CalculatedAmount)* @OverrideValue,0),2) as OverrideValue,         
  @comments as comments,          
  getdate() as PostedDate,          
  @BatchLogID as BatchLogID,          
  0 as Deleted,          
  @Exception as Exception,          
  ROUND(isnull((tre.Amount/@CalculatedAmount)* @Adjustment,0),2) as Adjustment,          
  null as ActualDelta,          
  ROUND(isnull((tre.Amount/@CalculatedAmount)* @AddlInterest,0),2)  as AddlInterest, --Capitalized INterest          
  ROUND(isnull((tre.Amount/@CalculatedAmount)* @TotalInterest,0),2) as TotalInterest, --Cash INterest          
  @OverrideReason as OverrideReason,          
  ROUND(isnull((tre.Amount/@CalculatedAmount)* @BerAddlint,0),2) as BerAddlint,          
   ROUND(isnull((tre.Amount/@CalculatedAmount)* @InterestAdj,0),2) as InterestAdj  ,
  ROUND(@WriteOffAmount,2) as WriteOffAmount
  from #TempTransactionEntry tre           
  where  tre.Noteid = @NoteID           
  and tre.grouptype = @TransactionType          
  and tre.Date between @SDate and @RemittanceDate        
  and tre.grouptype in ('ExitFee','PrepaymentFee')       
--)a      
--Select @CalculatedAmount=sum(abs(round(isnull(amount,0),2))) from #TempTransactionEntry t       
-- where t.noteid = @NoteID  and t.Date between @SevenDaysPrevious and @TDate              
-- and t.grouptype in ('ExtensionFee','UnusedFee')      
      
  INSERT INTO #TempTransactiondetail          
           ([Transactionid]       
      ,rowno       
           ,[DateDue]          
           ,[RemittanceDate]          
           ,[ServcerMasterID]          
           ,[DealId]          
           ,[NoteID]          
           ,[TransactionType]          
           ,[TransactionDate]          
           ,[ServicingAmount]          
           ,[CalculatedAmount]          
           ,[Delta]          
           ,[M61Value]          
           ,[ServicerValue]          
           ,[Ignore]          
           ,[OverrideValue]          
           ,[comments]          
           ,[PostedDate]          
           ,[BatchLogID]          
           ,[Deleted]          
           ,[Exception]          
           ,[Adjustment]          
           ,[ActualDelta]          
           ,[AddlInterest]          
           ,[TotalInterest]          
           ,[OverrideReason]          
           ,[BerAddlint]          
           ,[InterestAdj]
           ,WriteOffAmount)          
  select  @TransactionID as TransactionID,   
   row_number() OVER (ORDER BY @TransactionID) rowno,                 
  --@DateDue as DateDue,          
  tre.Date as DateDue,      
  @RemittanceDate as RemittanceDate,          
  @ServcerMasterID as ServcerMasterID,          
  @DealId as DealId,          
  @NoteID as NoteID,          
  tre.Type,          
  @TransactionDate as TransactionDate,          
   round( (isnull(tre.Amount,0))/@CalculatedAmount * @ServicingAmount,2) as ServicingAmount,                     
 round(isnull(tre.Amount,0),2) as CalculatedAmount,          
  null as Delta,          
  @M61Value as M61Value,          
  @ServicerValue as ServicerValue,          
  @Ignore as Ignore,          
 -- round(isnull((tre.Amount/@CalculatedAmount)* @OverrideValue,0),2) as OverrideValue,        
  isnull((tre.Amount/@CalculatedAmount)* @OverrideValue,0) as OverrideValue,          
  @comments as comments,          
  getdate() as PostedDate,          
  @BatchLogID as BatchLogID,          
  0 as Deleted,          
  @Exception as Exception,          
  round(isnull((tre.Amount/@CalculatedAmount)* @Adjustment,0),2) as Adjustment,          
  null as ActualDelta,          
  round(isnull((tre.Amount/@CalculatedAmount)* @AddlInterest,0),2)  as AddlInterest, --Capitalized INterest          
  round(isnull((tre.Amount/@CalculatedAmount)* @TotalInterest,0),2) as TotalInterest, --Cash INterest          
  @OverrideReason as OverrideReason,          
  round(isnull((tre.Amount/@CalculatedAmount)* @BerAddlint,0),2) as BerAddlint,          
  round(isnull((tre.Amount/@CalculatedAmount)* @InterestAdj,0),2) as InterestAdj ,
  ROUND(@WriteOffAmount,2) as WriteOffAmount
  
  from #TempTransactionEntry tre           
  where  tre.Noteid = @NoteID           
  and tre.grouptype = @TransactionType          
  and tre.Date between @SevenDaysPrevious and @TDate      
  and tre.grouptype in ('ExtensionFee','UnusedFee')      
 END      
  IF(@SplitTransactionid is not null)      
 BEGIN      
 INSERT INTO #TempTransactiondetail          
           ([Transactionid]    
           ,rowno   
           ,[DateDue]          
           ,[RemittanceDate]          
           ,[ServcerMasterID]          
           ,[DealId]          
           ,[NoteID]          
           ,[TransactionType]          
           ,[TransactionDate]          
           ,[ServicingAmount]          
           ,[CalculatedAmount]          
           ,[Delta]          
           ,[M61Value]          
           ,[ServicerValue]          
           ,[Ignore]          
           ,[OverrideValue]          
           ,[comments]          
           ,[PostedDate]          
           ,[BatchLogID]          
           ,[Deleted]          
           ,[Exception]          
           ,[Adjustment]          
           ,[ActualDelta]          
           ,[AddlInterest]          
           ,[TotalInterest]          
           ,[OverrideReason]          
           ,[BerAddlint]          
           ,[InterestAdj]
           ,WriteOffAmount)          
  select  @TransactionID as TransactionID,        
    row_number() OVER (ORDER BY @TransactionID) rowno,   
  --@DateDue as DateDue,          
  tre.Date as DateDue,      
  @RemittanceDate as RemittanceDate,          
  @ServcerMasterID as ServcerMasterID,          
  @DealId as DealId,          
  @NoteID as NoteID,          
  tre.Type,          
  @TransactionDate as TransactionDate,          
  round(((tre.Amount/@CalculatedAmount) * @ServicingAmount),2) as ServicingAmount,          
  round(tre.Amount,2) as CalculatedAmount,          
  null as Delta,          
  @M61Value as M61Value,          
  @ServicerValue as ServicerValue,          
  @Ignore as Ignore,          
 round( isnull((tre.Amount/@CalculatedAmount)* @OverrideValue,0),2) as OverrideValue,       
  --isnull((tre.Amount/@CalculatedAmount)* @OverrideValue,0) as OverrideValue,           
  @comments as comments,          
  getdate() as PostedDate,          
  @BatchLogID as BatchLogID,          
  0 as Deleted,          
  @Exception as Exception,          
  round(isnull((tre.Amount/@CalculatedAmount)* @Adjustment,0),2) as Adjustment,          
  null as ActualDelta,          
  round(isnull((tre.Amount/@CalculatedAmount)* @AddlInterest,0),2)  as AddlInterest, --Capitalized INterest          
  round(isnull((tre.Amount/@CalculatedAmount)* @TotalInterest,0),2) as TotalInterest, --Cash INterest          
  @OverrideReason as OverrideReason,          
  round(isnull((tre.Amount/@CalculatedAmount)* @BerAddlint,0),2) as BerAddlint,          
  round(isnull((tre.Amount/@CalculatedAmount)* @InterestAdj,0),2) as InterestAdj  ,
  ROUND(@WriteOffAmount,2) as WriteOffAmount
  from #TempTransactionEntry tre           
  where  tre.Noteid = @NoteID           
  --and tre.grouptype = @TransactionType  
 
    and tre.grouptype = (CASE WHEN @TransactionType in ('ExitFeeExcludedFromLevelYield','ExitFeeIncludedInLevelYield','ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable') THEN 'ExitFee' 
    WHEN @TransactionType in ('ExtensionFeeExcludedFromLevelYield','ExtensionFeeIncludedInLevelYield','ExtensionFeeStrippingExcldfromLevelYield','ExtensionFeeStripReceivable') THEN 'ExtensionFee' 
	WHEN @TransactionType in ('AdditionalFeesExcludedFromLevelYield','AdditionalFeesIncludedInLevelYield','AddlFeesStrippingExcldfromLevelYield','AdditionalFeesStripReceivable') THEN 'AdditionalFeesExcludedFromLevelYield' 
    ELSE @TransactionType END)

  and tre.Date =@DateDue      
 END      
          
          
  update #TempTransactiondetail set Delta = (Case When OverrideValue > 0 then isnull(OverrideValue,0)-isnull(CalculatedAmount,0)               
     When M61Value = 1 then isnull(CalculatedAmount,0)-isnull(CalculatedAmount,0)             
     When ServicerValue = 1 then isnull(ServicingAmount,0)-isnull(CalculatedAmount,0) END)          
 -- Where TransactionID = @TransactionID          
          
  update #TempTransactiondetail set ActualDelta = Delta + Adjustment --Where TransactionID = @TransactionID          
          
 END              
 ELSE          
 BEGIN    
   
 IF(@TransactionType ='ExitFee' or @TransactionType ='ExtensionFee' or @TransactionType ='PrepaymentFee' or @TransactionType ='UnusedFee' )      
 BEGIN            
  ---Insert transaction for servicer amount if M61 amount is 0          
  INSERT INTO #TempTransactiondetail          
           ([Transactionid]          
           ,[DateDue]          
           ,[RemittanceDate]          
           ,[ServcerMasterID]          
           ,[DealId]          
           ,[NoteID]          
           ,[TransactionType]          
           ,[TransactionDate]          
           ,[ServicingAmount]          
           ,[CalculatedAmount]          
           ,[Delta]          
           ,[M61Value]          
           ,[ServicerValue]          
           ,[Ignore]          
           ,[OverrideValue]          
           ,[comments]          
           ,[PostedDate]          
           ,[BatchLogID]          
           ,[Deleted]          
           ,[Exception]          
           ,[Adjustment]          
           ,[ActualDelta]          
           ,[AddlInterest]          
           ,[TotalInterest]          
           ,[OverrideReason]          
           ,[BerAddlint]          
           ,[InterestAdj]
           ,WriteOffAmount)          
select  @TransactionID as TransactionID,          
@DateDue as DateDue,          
@RemittanceDate as RemittanceDate,          
@ServcerMasterID as ServcerMasterID,          
@DealId as DealId,          
@NoteID as NoteID,         
(case when @TransactionType like '%exit%' Then 'ExitFeeExcludedFromLevelYield' 
when @TransactionType like '%extension%' Then 'ExtensionFeeExcludedFromLevelYield' 
when @TransactionType ='PrepaymentFee' Then 'PrepaymentFeeExcludedFromLevelYield'            
when @TransactionType ='UnusedFee' Then 'UnusedFeeExcludedFromLevelYield'            
END) as TransactionType,      
@TransactionDate as TransactionDate,          
@ServicingAmount as ServicingAmount,          
@CalculatedAmount as CalculatedAmount,          
null as Delta,          
@M61Value as M61Value,          
@ServicerValue as ServicerValue,          
@Ignore as Ignore,          
@OverrideValue as OverrideValue,           
@comments as comments,          
getdate() as PostedDate,          
@BatchLogID as BatchLogID,          
0 as Deleted,          
@Exception as Exception,          
@Adjustment as Adjustment,          
0 as ActualDelta,          
@AddlInterest  as AddlInterest, --Capitalized INterest          
@TotalInterest as TotalInterest, --Cash INterest          
@OverrideReason as OverrideReason,          
@BerAddlint as BerAddlint,          
@InterestAdj as InterestAdj ,
@WriteOffAmount as WriteOffAmount
     
        
  Print('Zero')   
   END           
 END          
         
  
Update  #TempTransactiondetail SET     
#TempTransactiondetail.ServicingAmount = b.ServicingAmount,    
#TempTransactiondetail.CalculatedAmount = b.CalculatedAmount,    
#TempTransactiondetail.OverrideValue = b.OverrideValue,    
#TempTransactiondetail.AddlInterest = b.AddlInterest,    
#TempTransactiondetail.TotalInterest = b.TotalInterest,    
#TempTransactiondetail.BerAddlint = b.BerAddlint,    
#TempTransactiondetail.InterestAdj = b.InterestAdj ,   
#TempTransactiondetail.Adjustment = b.Adjustment ,
#TempTransactiondetail.WriteOffAmount = b.WriteOffAmount 

From(    
 Select [Transactionid]      
 ,rowno        
 ,NoteID    
 ,[ServicingAmount] + (CASE WHEN rowno = 1 THEN @ServicingAmount - ROUND(SUM([ServicingAmount]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   ServicingAmount          
 --,[CalculatedAmount]    
 ,[CalculatedAmount] + (CASE WHEN rowno = 1 THEN @CalculatedAmount - ROUND(SUM([CalculatedAmount]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   CalculatedAmount    
 ,[Delta]     
 --,[OverrideValue]     
 ,[OverrideValue] + (CASE WHEN rowno = 1 THEN @OverrideValue - ROUND(SUM([OverrideValue]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   OverrideValue  
  ,[Adjustment] + (CASE WHEN rowno = 1 THEN @Adjustment - ROUND(SUM([Adjustment]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   Adjustment     
       
 ,[ActualDelta]        
 --,[AddlInterest]        
   
 ,[AddlInterest] + (CASE WHEN rowno = 1 THEN @AddlInterest - ROUND(SUM([AddlInterest]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   AddlInterest    
 --,[TotalInterest]    
 ,[TotalInterest] + (CASE WHEN rowno = 1 THEN @TotalInterest - ROUND(SUM([TotalInterest]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   TotalInterest        
      
 --,[BerAddlint]      
 ,[BerAddlint] + (CASE WHEN rowno = 1 THEN @BerAddlint - ROUND(SUM([BerAddlint]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   BerAddlint       
 --,[InterestAdj]    
 ,[InterestAdj] + (CASE WHEN rowno = 1 THEN @InterestAdj - ROUND(SUM([InterestAdj]) OVER (ORDER BY TransactionID) ,2) ELSE 0 end)   InterestAdj      
 ,WriteOffAmount
 from #TempTransactiondetail     
   where #TempTransactiondetail.Transactionid=@TransactionID  
)b    
where #TempTransactiondetail.rowno = b.rowno      
 and  #TempTransactiondetail.NoteID = b.NoteID     
 and #TempTransactiondetail.Transactionid = b.Transactionid          
                
FETCH NEXT FROM CursorFeeRecon          
INTO @TransactionID          
END          
CLOSE CursorFeeRecon             
DEALLOCATE CursorFeeRecon          
          
 
    
update #TempTransactiondetail set Delta = (Case When M61Value = 1 then round(isnull(CalculatedAmount,0)-isnull(CalculatedAmount,0),2)              
   When ServicerValue = 1 then round(isnull(ServicingAmount,0)-isnull(CalculatedAmount,0),2) 
   When OverrideValue is not null then isnull(OverrideValue,0)-isnull(CalculatedAmount,0)  END)       
          
          
  update #TempTransactiondetail set ActualDelta = isnull(Delta,0) + isnull(Adjustment,0)       
          
INSERT INTO cre.TransactionReconciliationDetail          
([Transactionid]          
,[DateDue]          
,[RemittanceDate]          
,[ServcerMasterID]          
,[DealId]          
,[NoteID]          
,[TransactionType]          
,[TransactionDate]          
,[ServicingAmount]          
,[CalculatedAmount]          
,[Delta]          
,[M61Value]          
,[ServicerValue]          
,[Ignore]          
,[OverrideValue]          
,[comments]          
,[PostedDate]          
,[BatchLogID]          
,[Deleted]          
,[Exception]          
,[Adjustment]          
,[ActualDelta]          
,[AddlInterest]          
,[TotalInterest]          
,[OverrideReason]          
,[BerAddlint]          
,[InterestAdj]
,WriteOffAmount)          
          
Select [Transactionid]          
,[DateDue]          
,[RemittanceDate]          
,[ServcerMasterID]          
,[DealId]          
,[NoteID]          
,[TransactionType]          
,[TransactionDate]          
,[ServicingAmount]          
,[CalculatedAmount]          
,[Delta]          
,[M61Value]          
,[ServicerValue]          
,[Ignore]          
,[OverrideValue]          
,[comments]          
,[PostedDate]          
,[BatchLogID]          
,[Deleted]          
,[Exception]          
,[Adjustment]          
,[ActualDelta]          
,[AddlInterest]          
,[TotalInterest]           
,[OverrideReason]          
,[BerAddlint]          
,[InterestAdj]  
,WriteOffAmount
from #TempTransactiondetail          
          
--update cre.TransactionReconciliationDetail set Delta = (Case When OverrideValue <> 0 then round(isnull(OverrideValue,0)-isnull(CalculatedAmount,0),2)               
--     When M61Value = 1 then round(isnull(CalculatedAmount,0)-isnull(CalculatedAmount,0),2)              
--     When ServicerValue = 1 then round(isnull(ServicingAmount,0)-isnull(CalculatedAmount,0),2) END)       
          
--update cre.TransactionReconciliationDetail set ActualDelta = isnull(Delta,0) + isnull(Adjustment,0)          
      
INSERT into cre.NoteTransactionDetail(NoteID,TransactionDate,TransactionType,Amount,RelatedtoModeledPMTDate,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServicerMasterID,CreatedBy,CreatedDate,    
UpdatedBy,UpdatedDate,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,InterestAdj,AddlInterest,TotalInterest,[BerAddlint],WriteOffAmount)              
Select [NoteID]          
,[TransactionDate]          
,(Select TransactionTypesID from cre.TransactionTypes where TransactionName = [TransactionType]) [TransactionType]          
 ,(              
  Case               
  When OverrideValue > 0 then OverrideValue               
  When M61Value = 1 then CalculatedAmount              
  When ServicerValue = 1 then ServicingAmount              
  When (isnull(M61Value,0) = 0 and isnull(ServicerValue,0) = 0 ) then OverrideValue               
  END              
 )as Amount           
,[DateDue]          
,[ServicingAmount]          
,[CalculatedAmount]          
,[Delta]          
,[M61Value]          
,[ServicerValue]          
,[Ignore]          
,[OverrideValue]          
,[comments]          
,[PostedDate]          
,[ServcerMasterID]          
,@createdBy          
,GETDATE()          
,@createdBy          
,GETDATE()          
,[TransactionType]          
,[Transactionid] as TranscationReconciliationID          
,[RemittanceDate]          
,[Exception]          
,[Adjustment]          
,[ActualDelta]          
,[OverrideReason]          
,[InterestAdj]          
,[AddlInterest]          
,[TotalInterest]          
,[BerAddlint]     
,WriteOffAmount
from cre.TransactionReconciliationDetail where [Transactionid] in (Select [Transcationid] from @TmpreconTrans)          
          
          
              
          
--Update posted date = null              
Update cre.TranscationReconciliation SET postedDate=getDate()              
Where  (isnull(M61Value,0) <>0 or isnull(ServicerValue,0) <>0  or isnull(ignore,0)<>0 or  OverrideValue is not null)            
and  [Transcationid] in (Select [Transcationid] from @TmpreconTrans)          
          
            
          
END    
    