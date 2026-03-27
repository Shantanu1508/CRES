  
CREATE PROCEDURE [dbo].[usp_RefreshM61AmountIntoTranscationReconciliation]   
(  
 @UserId varchar(100)  
)  
AS  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
Declare @AnalysisID UNIQUEIDENTIFIER  
SET @AnalysisID = (Select analysisID from core.Analysis where name = 'Default')  
  
  
IF OBJECT_ID('tempdb..[#UnReconRecord]') IS NOT NULL                                           
 DROP TABLE [#UnReconRecord]   
Create table [#UnReconRecord]  
(       
 Transcationid UNIQUEIDENTIFIER ,    
 noteid UNIQUEIDENTIFIER                     
)  
   
INSERT INTO [#UnReconRecord] (Transcationid,noteid)  
Select Transcationid,noteid from cre.TranscationReconciliation where posteddate is null and Deleted <> 1   
--===================================================================================================  
  
  
Update cre.TranscationReconciliation   
SET cre.TranscationReconciliation.CalculatedAmount = z.New_M61_Amount,  
cre.TranscationReconciliation.Delta = z.Cal_Delta ,  
cre.TranscationReconciliation.ActualDelta = z.Cal_ActualDelta  
--cre.TranscationReconciliation.UpdatedBy = @UserId,  
--cre.TranscationReconciliation.UpdatedDate = getdate()  
From(  
 Select Transcationid,New_M61_Amount,Cal_Delta,Cal_ActualDelta    
  From(    
    Select nt.Transcationid,    
    TransactionDate,    
    DateDue as RelatedtoModeledPMTDate,    
    TransactionType as TransactionTypeText,    
    RemittanceDate,      
    CalculatedAmount as Old_M61_Amount,     
    TrE.Amount as New_M61_Amount,    
    ServicingAmount,    
    nt.OverrideValue as OverrideValue,     
    ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(TrE.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(TrE.Amount,0),2)    
    END),2)  as Cal_Delta,    
    ROUND(nt.Delta,2) as Old_Delta,    
    ROUND(nt.Adjustment,2) Adjustment,    
    ROUND(nt.ActualDelta,2) Old_ActualDelta,    
    ROUND((ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(TrE.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(TrE.Amount,0),2)    
    END),2) + ROUND(ISNULL(nt.Adjustment,0),2)),2) as Cal_ActualDelta ,    
    M61Value,     
    ServicerValue,     
    Ignore    
    from cre.TranscationReconciliation  nt    
    left join(    
   Select n.noteid,Date,Amount,[Type]   
   from cre.transactionEntry te  
    Inner join core.account acc on acc.accountid = te.AccountID  
             Inner join cre.note n on n.account_accountid = acc.accountid  
  
   where analysisID =  @AnalysisID  and acc.AccounttypeID = 1  
   and n.NoteID in (Select noteid from [#UnReconRecord] )  
    )TrE on TrE.noteid = nt.noteid and TrE.date = nt.DateDue  and TrE.Type = nt.TransactionType   
    where nt.posteddate is null and Deleted <> 1    
    and nt.Transcationid in (Select Transcationid from [#UnReconRecord])   
    and nt.TransactionType in ('InterestPaid' ,'AdditionalFeesExcludedFromLevelYield')
  )a  
  
)z  
where z.Transcationid = cre.TranscationReconciliation.Transcationid  
  
  
  
----===============================================================================================  
  
Declare @tblDateRange as table(Date date)   
CREATE TABLE #TempRemitDate        
(        
Noteid UNIQUEIDENTIFIER,       
type nvarchar(256),        
RemitDate date,         
StartDate Date,          
ENDDate Date  ,  
SevenDaysPrevious Date  ,  
StartDate_4daybef DATETIME,  
  
StartDate_10daybef date,  
StartDate_10dayafter date  
)      
Declare @NoteId UNIQUEIDENTIFIER    
Declare @TransactionType nvarchar(50)    
Declare @Transcationid uniqueidentifier    
Declare @RemittanceDate Date    
    
IF CURSOR_STATUS('global','CursorRemitDate')>=-1        
BEGIN        
 DEALLOCATE CursorRemitDate        
END        
        
DECLARE CursorRemitDate CURSOR         
for        
(   
 Select Transcationid,NoteId,TransactionType,RemittanceDate from cre.TranscationReconciliation where posteddate is null and Deleted <> 1      
)        
OPEN CursorRemitDate         
        
FETCH NEXT FROM CursorRemitDate        
INTO @Transcationid,@NoteId,@TransactionType,@RemittanceDate    
        
WHILE @@FETCH_STATUS = 0        
BEGIN     
    
 Delete from @tblDateRange    
    
 ;WITH CTE AS    
 (    
  SELECT DateAdd(day,-30,@RemittanceDate) Date    
  UNION ALL    
  SELECT DateAdd(day,1,Date)  FROM CTE WHERE DateAdd(day,1,Date) <= DateAdd(day,30,@RemittanceDate)    
 )    
 INsert  into @tblDateRange(Date)    
 SELECT Distinct dbo.Fn_GetnextWorkingDays(Date,-1,'PMT Date') FROM CTE    
    
 DECLARE @SDate DATETIME    
 Declare @SevenDaysPrevious DATETIME  
 DECLARE @TDate DATETIME    
  DECLARE @StartDate_4daybef DATETIME  
     
    DECLARE @StartDate_10daybef DATETIME  
 DECLARE @StartDate_10dayafter DATETIME  
  
  
 SET @SDate = (Select Date as startdate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)    
 set @SevenDaysPrevious=(Select Date as enddate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)    
 SET @TDate = (Select Date as enddate from @tblDateRange  where date > @RemittanceDate order by date OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)      
SET @StartDate_4daybef = (Select Date as startdate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY)    
     
  
    SET @StartDate_10daybef = (Select Date as startdate from @tblDateRange  where date < @RemittanceDate order by date desc OFFSET 9 ROWS FETCH NEXT 1 ROWS ONLY)    
  SET @StartDate_10dayafter = (Select Date as enddate from @tblDateRange  where date > @RemittanceDate order by date OFFSET 9 ROWS FETCH NEXT 1 ROWS ONLY)     
  
  
  
 insert into #TempRemitDate(Noteid,RemitDate,type ,StartDate ,ENDDate,SevenDaysPrevious,StartDate_4daybef,StartDate_10daybef,StartDate_10dayafter)      
 Select @NoteId, @RemittanceDate,@TransactionType,@SDate,@TDate , @SevenDaysPrevious,@StartDate_4daybef,@StartDate_10daybef,@StartDate_10dayafter  
          
FETCH NEXT FROM CursorRemitDate    
INTO @Transcationid,@NoteId,@TransactionType,@RemittanceDate    
END    
CLOSE CursorRemitDate       
DEALLOCATE CursorRemitDate   
  
  
  
IF OBJECT_ID('tempdb..#TempTransactionEntry') IS NOT NULL                                               
  DROP TABLE #TempTransactionEntry        
      
 CREATE TABLE #TempTransactionEntry(      
 Noteid UNIQUEIDENTIFIER,      
 Date date,      
 type nvarchar(256),      
 amount decimal(28,15)      
 )      
      
 INSERT INTO  #TempTransactionEntry(Noteid,Date,type,amount)      
 Select n.NOteid      
 ,Date      
 ,(case when type like '%exit%' Then 'ExitFee' when type like '%extension%' Then 'ExtensionFee' when type ='PrepaymentFeeExcludedFromLevelYield' Then 'PrepaymentFee'      
  when type ='UnusedFeeExcludedFromLevelYield' Then 'UnusedFee' else [TYPE]     
 END)      
 ,amount       
 from cre.transactionentry  tr    
  Inner join core.account acc on acc.accountid = tr.AccountID  
 Inner join cre.note n on n.account_accountid = acc.accountid  
  
 where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'    and acc.AccounttypeID = 1    
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
 'ScheduledPrincipalPaid'     
 )      
 and n.NOteid in (select noteid from cre.TranscationReconciliation where posteddate is null and Deleted <> 1  )    
  
Update cre.TranscationReconciliation   
SET cre.TranscationReconciliation.CalculatedAmount = z.New_M61_Amount,  
cre.TranscationReconciliation.Delta = z.Cal_Delta ,  
cre.TranscationReconciliation.ActualDelta = z.Cal_ActualDelta,  
--cre.TranscationReconciliation.UpdatedBy = @UserId,  
--cre.TranscationReconciliation.UpdatedDate = getdate(),  
cre.TranscationReconciliation.DateDue = z.RelatedtoModeledPMTDate  
From(  
 Select Transcationid,New_M61_Amount,Cal_Delta,Cal_ActualDelta ,TransactionTypeText ,RelatedtoModeledPMTDate  
  From(    
    Select nt.Transcationid,    
    TransactionDate,    
    --DateDue as RelatedtoModeledPMTDate,    
    MinDueDate as RelatedtoModeledPMTDate,    
  
    TransactionType as TransactionTypeText,    
    RemittanceDate,      
    CalculatedAmount as Old_M61_Amount,     
    isnull(aa.Amount,0) as New_M61_Amount,    
    ServicingAmount,    
    nt.OverrideValue as OverrideValue,     
    ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
    END),2)  as Cal_Delta,    
    ROUND(nt.Delta,2) as Old_Delta,    
    ROUND(nt.Adjustment,2) Adjustment,    
    ROUND(nt.ActualDelta,2) Old_ActualDelta,    
    ROUND((ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
    END),2) + ROUND(ISNULL(nt.Adjustment,0),2)),2) as Cal_ActualDelta ,    
    M61Value,     
    ServicerValue,     
    Ignore    
    from cre.TranscationReconciliation  nt    
    left join   #TempRemitDate trd on trd.noteid=nt.noteid and trd.type=nt.TransactionType and  trd.RemitDate=nt.RemittanceDate  
     OUTER APPLY       
    (    
    Select min(t.Date) as MinDueDate,sum(round(isnull(amount,0),2)) as amount from #TempTransactionEntry t   
    where t.noteid = nt.NoteID  and (t.Date >= trd.StartDate and t.Date <= nt.RemittanceDate )        
    and t.type=trd.type     
    )aa      
    where nt.posteddate is null and Deleted <> 1    
    and nt.Transcationid in (Select Transcationid from [#UnReconRecord])   
   and nt.TransactionType in ('ExitFee','PrepaymentFee')  
   and nt.SplitTransactionid is null  
      
  )a  
  where New_M61_Amount<>0  
  
)z  
where z.Transcationid = cre.TranscationReconciliation.Transcationid   
  
  
Update cre.TranscationReconciliation   
SET cre.TranscationReconciliation.CalculatedAmount = z.New_M61_Amount,  
cre.TranscationReconciliation.Delta = z.Cal_Delta ,  
cre.TranscationReconciliation.ActualDelta = z.Cal_ActualDelta,  
--cre.TranscationReconciliation.UpdatedBy = @UserId,  
--cre.TranscationReconciliation.UpdatedDate = getdate(),  
cre.TranscationReconciliation.DateDue = z.RelatedtoModeledPMTDate  
From(  
 Select Transcationid,New_M61_Amount,Cal_Delta,Cal_ActualDelta ,TransactionTypeText ,RelatedtoModeledPMTDate  
  From(    
    Select nt.Transcationid,    
    TransactionDate,    
    --DateDue as RelatedtoModeledPMTDate,    
    MinDueDate as RelatedtoModeledPMTDate,    
  
    TransactionType as TransactionTypeText,    
    RemittanceDate,      
    CalculatedAmount as Old_M61_Amount,     
    isnull(aa.Amount,0) as New_M61_Amount,    
    ServicingAmount,    
    nt.OverrideValue as OverrideValue,     
    ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
    END),2)  as Cal_Delta,    
    ROUND(nt.Delta,2) as Old_Delta,    
    ROUND(nt.Adjustment,2) Adjustment,    
    ROUND(nt.ActualDelta,2) Old_ActualDelta,    
    ROUND((ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
    END),2) + ROUND(ISNULL(nt.Adjustment,0),2)),2) as Cal_ActualDelta ,    
    M61Value,     
    ServicerValue,     
    Ignore    
    from cre.TranscationReconciliation  nt    
    left join   #TempRemitDate trd on trd.noteid=nt.noteid and trd.type=nt.TransactionType and  trd.RemitDate=nt.RemittanceDate  
     OUTER APPLY       
    (    
    Select min(t.Date) as MinDueDate,sum(round(isnull(amount,0),2)) as amount from #TempTransactionEntry t   
    where t.noteid = nt.NoteID  and t.Date=nt.DateDue  
    -- (t.Date >= trd.StartDate and t.Date <= nt.RemittanceDate )        
    and t.type=trd.type     
    )aa      
    where nt.posteddate is null and Deleted <> 1    
    and nt.Transcationid in (Select Transcationid from [#UnReconRecord])   
   and nt.TransactionType in ('ExitFee','PrepaymentFee')  
   and nt.SplitTransactionid is not null  
      
  )a  
  where New_M61_Amount<>0  
  
)z  
where z.Transcationid = cre.TranscationReconciliation.Transcationid   
  
  
  
Update cre.TranscationReconciliation   
SET cre.TranscationReconciliation.CalculatedAmount = z.New_M61_Amount,  
cre.TranscationReconciliation.Delta = z.Cal_Delta ,  
cre.TranscationReconciliation.ActualDelta = z.Cal_ActualDelta,  
--cre.TranscationReconciliation.UpdatedBy = @UserId,  
--cre.TranscationReconciliation.UpdatedDate = getdate(),  
cre.TranscationReconciliation.DateDue = z.RelatedtoModeledPMTDate  
From(  
 Select Transcationid,New_M61_Amount,Cal_Delta,Cal_ActualDelta ,TransactionTypeText ,RelatedtoModeledPMTDate  
  From(    
    Select nt.Transcationid,    
    TransactionDate,    
    --DateDue as RelatedtoModeledPMTDate,    
    MinDueDate as RelatedtoModeledPMTDate,    
  
    TransactionType as TransactionTypeText,    
    RemittanceDate,      
    CalculatedAmount as Old_M61_Amount,     
    isnull(aa.Amount,0) as New_M61_Amount,    
    ServicingAmount,    
    nt.OverrideValue as OverrideValue,     
    ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
    END),2)  as Cal_Delta,    
    ROUND(nt.Delta,2) as Old_Delta,    
    ROUND(nt.Adjustment,2) Adjustment,    
    ROUND(nt.ActualDelta,2) Old_ActualDelta,    
    ROUND((ROUND((Case    
    When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
    When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
    END),2) + ROUND(ISNULL(nt.Adjustment,0),2)),2) as Cal_ActualDelta ,    
    M61Value,     
    ServicerValue,     
    Ignore    
    from cre.TranscationReconciliation  nt    
  
    left join   #TempRemitDate trd on trd.noteid=nt.noteid and trd.type=nt.TransactionType and  trd.RemitDate=nt.RemittanceDate  
     OUTER APPLY       
    (    
    Select min(t.Date) as MinDueDate,sum(round(isnull(amount,0),2)) as amount from #TempTransactionEntry t   
    where t.noteid = nt.NoteID  and (t.Date >= trd.SevenDaysPrevious and t.Date <= trd.ENDDate )        
    and t.type=trd.type     
    )aa      
    where nt.posteddate is null and Deleted <> 1    
    and nt.Transcationid in (Select Transcationid from [#UnReconRecord])   
   and nt.TransactionType in ('ExtensionFee','UnusedFee')  
      
  )a  
  where New_M61_Amount<>0  
)z  
where z.Transcationid = cre.TranscationReconciliation.Transcationid   
  
  
  
Update cre.TranscationReconciliation   
SET cre.TranscationReconciliation.CalculatedAmount = z.New_M61_Amount,  
cre.TranscationReconciliation.Delta = z.Cal_Delta ,  
cre.TranscationReconciliation.ActualDelta = z.Cal_ActualDelta,  
--cre.TranscationReconciliation.UpdatedBy = @UserId,  
--cre.TranscationReconciliation.UpdatedDate = getdate(),  
cre.TranscationReconciliation.DateDue = z.RelatedtoModeledPMTDate  
From(  
 Select Transcationid,New_M61_Amount,Cal_Delta,Cal_ActualDelta ,TransactionTypeText ,RelatedtoModeledPMTDate  
 From(    
  Select nt.Transcationid,    
  TransactionDate,    
  --DateDue as RelatedtoModeledPMTDate,    
  MinDueDate as RelatedtoModeledPMTDate,  
  
  TransactionType as TransactionTypeText,    
  RemittanceDate,      
  CalculatedAmount as Old_M61_Amount,     
  isnull(aa.Amount,0) as New_M61_Amount,    
  ServicingAmount,    
  nt.OverrideValue as OverrideValue,     
  ROUND((Case    
  When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
  When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
  END),2)  as Cal_Delta,    
  ROUND(nt.Delta,2) as Old_Delta,    
  ROUND(nt.Adjustment,2) Adjustment,    
  ROUND(nt.ActualDelta,2) Old_ActualDelta,    
  ROUND((ROUND((Case    
  When ISNULL(nt.OverrideValue,0)=0  Then Round((ISNULL(nt.ServicingAmount,0)-ISNULL(aa.Amount,0)),2)    
  When ISNULL(nt.OverrideValue,0)<>0  Then Round(ISNULL(nt.OverrideValue,0)-ISNULL(aa.Amount,0),2)    
  END),2) + ROUND(ISNULL(nt.Adjustment,0),2)),2) as Cal_ActualDelta ,    
  M61Value,     
  ServicerValue,     
  Ignore    
  from cre.TranscationReconciliation  nt    
  left join  #TempRemitDate trd on trd.noteid=nt.noteid and trd.type=nt.TransactionType and  trd.RemitDate=nt.RemittanceDate  
  OUTER APPLY       
  (    
   Select min(t.Date) as MinDueDate,sum(round(isnull(amount,0),2)) as amount from #TempTransactionEntry t   
   where t.noteid = nt.NoteID  and (t.Date >= DATEADD(day,1,EOMONTH(DATEADD(month,-1,trd.RemitDate))) and t.Date <= EOMONTH(trd.RemitDate)  )      
   and t.type=trd.type     
  
   ---(t.Date >= trd.StartDate_10daybef and t.Date <= trd.StartDate_10dayafter ) ---t.Date <= trd.RemitDate    
  )aa      
  where nt.posteddate is null and Deleted <> 1    
  and nt.Transcationid in (Select Transcationid from [#UnReconRecord])   
  and nt.TransactionType in ('ScheduledPrincipalPaid')      
  )a  
  where New_M61_Amount<>0  
)z  
where z.Transcationid = cre.TranscationReconciliation.Transcationid  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
  
END

