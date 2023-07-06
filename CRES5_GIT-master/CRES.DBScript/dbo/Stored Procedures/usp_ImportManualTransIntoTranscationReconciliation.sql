-- Procedure    
-- Procedure    
    
--[dbo].[usp_ImportManualTransIntoTranscationReconciliation] 2297,'c10f3372-0fc2-4861-a9f5-148f1f80804f'    
    
CREATE PROCEDURE [dbo].[usp_ImportManualTransIntoTranscationReconciliation]     
(    
 @Batchlogid int,    
 @ScenarioId varchar(100)    
)    
AS    
BEGIN    
    
    
  DECLARE @uploadedby varchar(250)    
 DECLARE @ignoredrows int,@TotalRowsCount int,@rowsinTrans int,@successmsg varchar(250),@ServicerMasterID int    
  SELECT @uploadedby=CreatedBy FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid    
    
 SELECT @ServicerMasterID=ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid    
  Update IO.[L_ManualTransaction] Set 
	CapitalizedInterest =null,CashInterest =NULL where ValueType<>'InterestPaid'

 Update IO.[L_ManualTransaction] SET IO.[L_ManualTransaction].NoteIDGuid = a.noteid,
IO.[L_ManualTransaction].ReconFlag = (case when ValueType='InterestPaid' THEN 'InterestPaid' when ValueType='ScheduledPrincipalPaid' THEN 'ScheduledPrincipalPaid' when ValueType in ('ExitFee','PrepaymentFee','ExtensionFee','UnusedFee') THEN 'Fee' ELSE 'OtherFee' END)
From(
	select n.crenoteid,n.noteid 
	from cre.Note n   
	inner join IO.[L_ManualTransaction] mt on n.crenoteid=mt.NoteId  
	Inner Join core.Account acc on acc.AccountID = n.Account_AccountID  
	where acc.IsDeleted <> 1 
)a
where IO.[L_ManualTransaction].noteid = a.crenoteid
    
  
  --drop  TABLE #TempTransactionEntry  
  
  --Select * from IO.[L_ManualTransaction] where FileBatchLogid=2542  
 --Select *  from cre.TransactionAuditLog where BatchLogid=2542  
  
--============================Delete Duplicate Records========================  
  --declare @Batchlogid int=2541,@ServicerMasterID int   
  -- SELECT @ServicerMasterID=ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid   
;WITH CTE AS(  
   SELECT NoteID,ValueType,Value,DueDate,RemitDate,TransDate,  
       RN = ROW_NUMBER()OVER(PARTITION BY NoteID,DueDate, ValueType, RemitDate,TransDate  
    order by NoteID,DueDate, ValueType, RemitDate, TransDate)  
   FROM IO.[L_ManualTransaction]  where FileBatchLogid=@Batchlogid  
)   
  
  
INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,ServicerMasterID,TransactionDate)(  
 SELECT   
   @Batchlogid,  
   n.NoteID,   
   ttr.ValueType,   
   ttr.DueDate,  
   ttr.RemitDate,   
   isnull(ttr.Value,0) as ServicingAmount,  
   'Duplicate Record',  
   @ServicerMasterID,   
   ttr.TransDate       
  FROM CTE ttr   
   inner join cre.note n on n.CRENoteID=ttr.NoteID    
   WHERE RN > 1   
)  
  
  
;WITH Dupl AS(  
   SELECT NoteID,ValueType,Value,DueDate,RemitDate,TransDate,  
       RN = ROW_NUMBER()OVER(PARTITION BY NoteID,ValueType,DueDate,RemitDate,TransDate  
    order by NoteID,DueDate, ValueType, RemitDate, TransDate)  
   FROM IO.[L_ManualTransaction] where FileBatchLogid=@Batchlogid  
)   
Delete from Dupl where RN>1  
  
 --============================Delete Duplicate Records========================  
  
  
 ---==========================Insert into TransactionAuditLog====================================    
    
  INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,ServicingAmount,Status,ServicerMasterID,TransactionDate,RemitDate,ReconFlag)(    
  SELECT     
   @Batchlogid,    
   n.NoteID,     
   mt.ValueType,     
   mt.DueDate,        
   isNull(mt.Value,0) as ServicingAmount,    
   'Imported',      
   @ServicerMasterID,     
   mt.TransDate,    
   mt.RemitDate ,  
   mt.ReconFlag        
   from IO.[L_ManualTransaction] mt    
  inner join cre.note n on n.NoteID=mt.NoteIDGuid     
 )    
    
    
    
Update ta set ta.Status='Note does not exist.'     
from cre.TransactionAuditLog ta     
inner join cre.Note n on ta.Noteid=n.noteid    
inner join IO.L_ManualTransaction r on r.NoteID=n.CRENoteid     
inner Join core.account a on n.Account_AccountID=a.AccountID     
where (a.IsDeleted=1 or a.StatusID=2) and ta.Batchlogid = @Batchlogid     
    
    
Update ta set ta.Status='Note Enable M61 Calculations is N.'     
from cre.TransactionAuditLog ta     
inner join cre.Note n on ta.Noteid=n.noteid    
inner join IO.L_ManualTransaction r on r.NoteIDGuid=n.Noteid     
where n.EnableM61Calculations=4 and ta.Batchlogid = @Batchlogid     
    
--=========================    
    
    
update ta set ta.Status='Data already Reconcilled.'       
from cre.TransactionAuditLog ta     
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and       
ta.DueDate=tr.DateDue and     
ta.TransactionType=tr.[TransactionType]  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) and    
ta.TransactionDate=tr.TransactionDate and    
ta.ServicerMasterID=tr.ServcerMasterID    
where tr.posteddate is not null     
and ta.Batchlogid = @Batchlogid    
and tr.Ignore <> 1    
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')     
and ta.Reconflag in('InterestPaid','OtherFee')  


Update ta set ta.Status='Reimported'       
from cre.TransactionAuditLog ta     
INNER join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and       
ta.DueDate=tr.DateDue and     
ta.TransactionType=tr.[TransactionType]  and     
--ta.TransactionDate=tr.TransactionDate and    
 isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) and    
ta.ServicerMasterID=tr.ServcerMasterID and tr.deleted=0    
where tr.posteddate is null and ta.Batchlogid =@Batchlogid    
 and ta.[Status]not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')     
 and ta.Reconflag in('InterestPaid','OtherFee')      
  
 --================Update Excisting Data=====================    
 Update cre.TranscationReconciliation     
 set cre.TranscationReconciliation.Deleted=1,     
 cre.TranscationReconciliation.UpdatedDate=GETDATE(),    
 cre.TranscationReconciliation.UpdatedBy=@uploadedby    
 from    
 (    
 SELECT tr.Transcationid,    
   mt.LandingID,       
   mt.ValueType,    
   mt.DueDate,    
   isnull(tr.ServicingAmount,0) as ServicingAmount,    
   tr.posteddate      
 from IO.[L_ManualTransaction] mt     
 inner join cre.note n on n.NoteID=mt.NoteIDGuid       
 inner join cre.TranscationReconciliation tr on tr.NoteID=n.NoteID      
 and mt.DueDate=tr.DateDue and     
 mt.ValueType=tr.[TransactionType]  and     
 --mt.TransDate=tr.TransactionDate and    
 @ServicerMasterID=tr.ServcerMasterID   and  
  isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate())     
 where tr.posteddate is null and tr.deleted=0  and mt.ReconFlag in('InterestPaid','OtherFee')  
 ) a    
 where a.Transcationid=cre.TranscationReconciliation.Transcationid    
  
  
     
  
    
  --================Update Excisting Data=====================    
     
    

    
  
   
    
Update ta set ta.Status='Transaction type does not configured in transaction master.'       
from cre.TransactionAuditLog ta     
where ta.Batchlogid = @Batchlogid    
and ta.TransactionType not in ( 'InterestPaid','ExitFee', 'ExtensionFee','PrepaymentFee','UnusedFee')
and ta.TransactionType not in (Select TransactionName from cre.TransactionTypes where IncludeServicingReconciliation = 3)    


Update ta set ta.Status='Transaction type does not configured in transaction master.'       
from cre.TransactionAuditLog ta     
where ta.Batchlogid = @Batchlogid    
 and ta.TransactionType  in ('ExitFeeExcludedFromLevelYield',
'ExitFeeIncludedInLevelYield',
'ExitFeeStrippingExcldfromLevelYield',
'ExitFeeStripReceivable',
'ExtensionFeeExcludedFromLevelYield',
'ExtensionFeeIncludedInLevelYield',
'ExtensionFeeStrippingExcldfromLevelYield',
'ExtensionFeeStripReceivable')


Update ta set ta.Status='Transaction type does not exist in Dropdown.'       
from cre.TransactionAuditLog ta     
where ta.Batchlogid = @Batchlogid    
 and ta.TransactionType not in  ('AdditionalFeesExcludedFromLevelYield',
'AdditionalFeesIncludedInLevelYield',
'AdditionalFeesStripReceivable',
'AddlFeesStrippingExcldfromLevelYield',
'Balloon',
'CapitalizedClosingCost',
'CouponFeeExcludedFromLevelYield',
'CouponFeeIncludedInLevelYield',
'CouponFeeStrippingExcldfromLevelYield',
'CouponFeeStripReceivable',
'Discount/Premium',
'DrawFeeExcludedFromLevelYield',
'EndingGAAPBookValue',
'EndingPVGAAPBookValue',
'ExitFee',
'ExtensionFee',
'FloatInterest',
'FundingOrRepayment',
'InitialFunding',
'InterestPaid',
'LIBORPercentage',
'ManagementFee',
'MiscFee',
'OriginationFee',
'OriginationFeeStripping',
'OriginationFeeStripReceivable',
'OtherFeeExcludedFromLevelYield',
'OtherFeeIncludedInLevelYield',
'OtherFeeStrippingExcldfromLevelYield',
'OtherFeeStripReceivable',
'PIKInterest',
'PIKInterestPaid',
'PIKInterestPercentage',
'PIKPrincipalFunding',
'PIKPrincipalPaid',
'PrepaymentFee',
'PurchasedInterest',
'ScheduledPrincipalPaid',
'ServicingFeeExcludedFromLevelYield',
'SpreadPercentage',
'StubInterest',
'UnusedFee'
)
    
    
Update cre.TranscationReconciliation SET Deleted = 1    
Where PostedDate is null    
and Noteid in(    
Select Noteid from cre.TransactionAuditLog where [Status] in ('Note does not exist.','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not exist in Dropdown.')    
)    
and BatchLogID= @Batchlogid    
-- and ReconFlag in ('InterestPaid','OtherFee')   
--Update ta set ta.Status='Transaction type does not exists in fee transaction master.'       
--from cre.TransactionAuditLog ta     
--where ta.Batchlogid = @Batchlogid    
--and ta.TransactionType <> 'InterestPaid' and ta.TransactionType not in (Select TransactionType from CRE.FeeTransactionTypeMaster)    
    
--and ta.TransactionType in (Select ValueType from  [#SkipTranType] where FeeName is null)    
---==========================Insert into TransactionAuditLog====================================    
    
    
  
    
    
INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,RemittanceDate,AddlInterest,TotalInterest)      
(       
 select d.DealID,      
   n.NoteID,      
   @ServicerMasterID,      
   mt.ValueType,      
   mt.DueDate,      
   isNull(mt.Value,0) as ServicingAmount,      
   isnull(CREtr.Amount,0) as CalculatedAmount,      
   round((isnull(mt.Value,0)-isnull(CREtr.Amount,0)),2) as Delta,      
   mt.TransDate,      
   @uploadedby as createdby,      
   GETDATE() as createdDate,      
   @uploadedby as updatedby,      
   GETDATE() as UpdatedDate,      
   @Batchlogid ,      
   mt.RemitDate   ,
   mt.CapitalizedInterest,mt.CashInterest 
 from IO.[L_ManualTransaction] mt      
 inner join cre.note n on n.NoteID=mt.NoteIDGuid       
 left join cre.Deal d on d.DealID=n.DealID      
 inner join (      
  Select BatchLogID      
  ,NoteID      
  ,TransactionType      
  ,DueDate      
  ,RemitDate      
  ,Status      
  ,ServicerMasterID      
  ,TransactionDate       
  from cre.TransactionAuditLog       
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported')      
 )ta on n.NoteID=ta.NoteID        
 AND ta.DueDate=mt.DueDate       
 and ta.TransactionType=mt.ValueType        
 and isnull(ta.RemitDate,getdate())=isnull(mt.RemitDate,getDate())       
 --and ta.TransactionDate=mt.TransDate       
 and mt.FileBatchLogid =@Batchlogid      
 left join cre.TranscationReconciliation tr on n.NoteID=tr.NoteID  and tr.posteddate is null      
      
 and  tr.Deleted =0       
 AND mt.DueDate=tr.DateDue       
 and mt.ValueType=tr.[TransactionType]        
 and isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate())       
 --and mt.TransDate=tr.TransactionDate       
 and tr.ServcerMasterID=@ServicerMasterID      
  and mt.ReconFlag in ('InterestPaid' ,'OtherFee')  
 left join [Cre].Transactionentry CREtr on n.NoteID=CREtr.NoteID and mt.DueDate=CREtr.Date and  mt.ValueType = CREtr.Type  and AnalysisID=@ScenarioId      
       
  --Where mt.FileBatchLogid =@Batchlogid      
  --and (mt.ValueType = 'InterestPaid' OR mt.ValueType in (Select TransactionType from CRE.FeeTransactionTypeMaster))        
  --and n.Noteid not in (Select Noteid from cre.TransactionAuditLog where [Status] in ('Note does not exist.','Data already Reconcilled.','Transaction type does not configured in transaction master.') and Batchlogid = @Batchlogid)      
)       
    
    
--Update tr set tr.deleted=1       
--from cre.TranscationReconciliation tr     
--INNER join cre.TransactionAuditLog ta on ta.NoteID=tr.NoteID and       
--ta.DueDate=tr.DateDue and     
--ta.TransactionType=tr.[TransactionType]  and     
--ta.TransactionDate=tr.TransactionDate and    
--ta.ServicerMasterID=tr.ServcerMasterID and tr.deleted=0    
--where tr.posteddate is null   
--and ta.status in ('Note does not exist.','Data already Reconcilled.','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Duplicate Record')   
-- and ta.ReconFlag in ('InterestPaid','OtherFee')     
  
----======================================Begin Fee Transaction=====================================================  
  
 IF EXISTS(select distinct NoteID from IO.L_ManualTransaction  where ReconFlag = 'Fee')      
BEGIN      
      
--==============================================================    
Declare @tblDateRange as table(Date date)        
  
CREATE TABLE #TempTransactionEntry(  
  Noteid UNIQUEIDENTIFIER,  
 Date date,  
 type nvarchar(256),  
 amount decimal(28,15))  
  
INSERT INTO  #TempTransactionEntry(Noteid,Date,type,amount)  
Select NOteid,Date,case   
          when type like '%exit%' Then 'ExitFee'  
          when type like '%extension%' Then 'ExtensionFee'  
          when type ='PrepaymentFeeExcludedFromLevelYield' Then 'PrepaymentFee'  
          when type ='UnusedFeeExcludedFromLevelYield' Then 'UnusedFee'  
          END,  
           round(isnull(amount,0),2) as  amount   
from cre.transactionentry where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
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
'UnusedFeeExcludedFromLevelYield'  
)  
and NOteid in (select NoteIDGuid from IO.[L_ManualTransaction])  
    
IF OBJECT_ID('tempdb..#TempRemitDate') IS NOT NULL                                               
 DROP TABLE #TempRemitDate      
    
CREATE TABLE #TempRemitDate        
(        
Noteid UNIQUEIDENTIFIER,       
type nvarchar(256),        
RemitDate date,         
StartDate Date,          
ENDDate Date    ,  
SevenDaysPrevious Date     
)      
Declare @NoteId UNIQUEIDENTIFIER    
Declare @TransactionType nvarchar(50)    
Declare @LandingID uniqueidentifier    
Declare @RemitDate Date    
    
IF CURSOR_STATUS('global','CursorRemitDate')>=-1        
BEGIN        
 DEALLOCATE CursorRemitDate        
END        
        
DECLARE CursorRemitDate CURSOR         
for        
(        
    
 Select LandingID,NoteIDGuid,ValueType,RemitDate from IO.L_ManualTransaction        
)        
OPEN CursorRemitDate         
        
FETCH NEXT FROM CursorRemitDate        
INTO @LandingID,@NoteId,@TransactionType,@RemitDate    
        
WHILE @@FETCH_STATUS = 0        
BEGIN     
    
 Delete from @tblDateRange    
    
 ;WITH CTE AS    
 (    
  SELECT DateAdd(day,-15,@RemitDate) Date    
  UNION ALL    
  SELECT DateAdd(day,1,Date)  FROM CTE WHERE DateAdd(day,1,Date) <= DateAdd(day,15,@RemitDate)    
 )    
 INsert  into @tblDateRange(Date)    
 SELECT Distinct dbo.Fn_GetnextWorkingDays(Date,-1,'PMT Date') FROM CTE    
    
 DECLARE @SDate DATETIME    
 Declare @SevenDaysPrevious DATETIME  
 DECLARE @TDate DATETIME    
    
 SET @SDate = (Select Date as startdate from @tblDateRange  where date < @RemitDate order by date desc OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)   
 set @SevenDaysPrevious=(Select Date as enddate from @tblDateRange  where date < @RemitDate order by date OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)     
 SET @TDate = (Select Date as enddate from @tblDateRange  where date > @RemitDate order by date OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)      
    
 insert into #TempRemitDate(Noteid,RemitDate,type ,StartDate ,ENDDate,SevenDaysPrevious)      
 Select @NoteId, @RemitDate,@TransactionType,@SDate,@TDate, @SevenDaysPrevious    
          
FETCH NEXT FROM CursorRemitDate    
INTO @LandingID,@NoteId,@TransactionType,@RemitDate    
END    
CLOSE CursorRemitDate       
DEALLOCATE CursorRemitDate    
  
update ta set ta.Status='Data already Reconcilled.'       
from cre.TransactionAuditLog ta     
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and     
ta.TransactionType=tr.[TransactionType]  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) and    
ta.TransactionDate=tr.TransactionDate and    
ta.ServicerMasterID=tr.ServcerMasterID    
where tr.posteddate is not null     
and ta.Batchlogid = @Batchlogid    
and tr.Ignore <> 1    
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Transaction type does not exist in Dropdown.')     
and ta.Reconflag='Fee'   
 
  
Update cre.TranscationReconciliation     
 set cre.TranscationReconciliation.Deleted=1,     
 cre.TranscationReconciliation.UpdatedDate=GETDATE(),    
 cre.TranscationReconciliation.UpdatedBy=@uploadedby    
 from    
 (    
 SELECT tr.Transcationid,    
   mt.LandingID,       
   mt.ValueType,    
   mt.DueDate,    
   isnull(tr.ServicingAmount,0) as ServicingAmount,    
   tr.posteddate      
 from IO.[L_ManualTransaction] mt     
 inner join cre.note n on n.NoteID=mt.NoteIDGuid       
 inner join cre.TranscationReconciliation tr on tr.NoteID=mt.NoteIDGuid      
-- and mt.DueDate=tr.DateDue      
and mt.ValueType=tr.[TransactionType]       
 and mt.TransDate=tr.TransactionDate     
and @ServicerMasterID=tr.ServcerMasterID     
 and isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate())     
 where tr.posteddate is null and tr.deleted=0  and mt.ReconFlag='Fee'  
 ) a    
 where a.Transcationid=cre.TranscationReconciliation.Transcationid    
  
    
  Update ta set ta.Status='Reimported'       
from cre.TransactionAuditLog ta     
INNER join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and       
ta.TransactionType=tr.[TransactionType]  and     
 isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) and    
ta.ServicerMasterID=tr.ServcerMasterID and tr.deleted=0    
where tr.posteddate is null and ta.Batchlogid =@Batchlogid    
 and ta.[Status]not in  ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Transaction type does not exist in Dropdown.')       
 and ta.Reconflag='Fee'   
  
 
  
  
  
  
INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,RemittanceDate,AddlInterest,TotalInterest)    
(     
 select distinct d.DealID,    
   n.NoteID,    
   @ServicerMasterID,    
   mt.ValueType,    
  isnull(TrEntr.MinDueDate, mt.RemitDate)as DueDate,    
   isNull(mt.Value,0) as ServicingAmount,    
   isnull(TrEntr.amount,0) as CalculatedAmount,    
   round((isnull(mt.Value,0)-isnull(TrEntr.amount,0)),2) as Delta,    
   mt.TransDate,    
   @uploadedby as createdby,    
   GETDATE() as createdDate,    
   @uploadedby as updatedby,    
   GETDATE() as UpdatedDate,    
   @Batchlogid ,    
   mt.RemitDate,
    mt.CapitalizedInterest,mt.CashInterest    
 from IO.[L_ManualTransaction] mt    
 inner join cre.note n on n.NoteID=mt.NoteIDGuid     
 inner join cre.Deal d on d.DealID=n.DealID    
 left join cre.TranscationReconciliation tr on mt.NoteIDGuid=tr.NoteID  and tr.posteddate is null   and isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate())   
 and isnull(mt.transDate,getdate())=isnull(tr.TransactionDate,getDate())  
 and mt.ValueType=tr.TransactionType  
 and BatchLogID=FileBatchlogid  
 and  tr.Deleted =0   
   and  tr.BatchLogID= @Batchlogid   
 left join (    
  Select BatchLogID    
  ,NoteID    
  ,TransactionType    
  ,DueDate    
  ,RemitDate    
  ,Status    
  ,ServicerMasterID    
  ,TransactionDate     
  from cre.TransactionAuditLog     
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported')    
 )ta on n.NoteID=ta.NoteID      
    
 and ta.TransactionType=mt.ValueType      
 and isnull(ta.RemitDate,getdate())=isnull(mt.RemitDate,getDate())     
and ta.TransactionDate=mt.TransDate     
 and mt.FileBatchLogid =@Batchlogid    
 and mt.TransDate=tr.TransactionDate     
 and tr.ServcerMasterID=@ServicerMasterID   
 and mt.ReconFlag='Fee'   
and mt.ValueType in ('ExitFee','PrepaymentFee')  
  left join   #TempRemitDate trd on trd.noteid=mt.NoteIDGuid and trd.type=mt.ValueType and  trd.RemitDate=mt.RemitDate  
 OUTER APPLY   
 (Select sum(amount) as amount,min(t.Date) as MinDueDate from #TempTransactionEntry t   
 where t.noteid = trd.NoteID  and (t.Date >= trd.StartDate and t.Date <= mt.RemitDate)    
 and t.type=trd.type   
 )TrEntr  
   where mt.ValueType in ('ExitFee','PrepaymentFee')  
)    
  
  
INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,RemittanceDate,AddlInterest,TotalInterest)    
(     
 select distinct d.DealID,    
   n.NoteID,    
   @ServicerMasterID,    
   mt.ValueType,    
  isnull(TrEntr.MinDueDate, mt.RemitDate)as DueDate,    
   isNull(mt.Value,0) as ServicingAmount,    
   isnull(TrEntr.amount,0) as CalculatedAmount,    
   round((isnull(mt.Value,0)-isnull(TrEntr.amount,0)),2) as Delta,    
   mt.TransDate,    
   @uploadedby as createdby,    
   GETDATE() as createdDate,    
   @uploadedby as updatedby,    
   GETDATE() as UpdatedDate,    
   @Batchlogid ,    
   mt.RemitDate,
  mt.CapitalizedInterest,mt.CashInterest     
 from IO.[L_ManualTransaction] mt    
 inner join cre.note n on n.NoteID=mt.NoteIDGuid     
 inner join cre.Deal d on d.DealID=n.DealID    
 left join cre.TranscationReconciliation tr on mt.NoteIDGuid=tr.NoteID  and tr.posteddate is null   and isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate())   
 and isnull(mt.transDate,getdate())=isnull(tr.TransactionDate,getDate())  
 and mt.ValueType=tr.TransactionType  
 and BatchLogID=FileBatchlogid  
 and  tr.Deleted =0   
   and  tr.BatchLogID= @Batchlogid   
 left join (    
  Select BatchLogID    
  ,NoteID    
  ,TransactionType    
  ,DueDate    
  ,RemitDate    
  ,Status    
  ,ServicerMasterID    
  ,TransactionDate     
  from cre.TransactionAuditLog     
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported')    
 )ta on n.NoteID=ta.NoteID      
    
 and ta.TransactionType=mt.ValueType      
 and isnull(ta.RemitDate,getdate())=isnull(mt.RemitDate,getDate())     
and ta.TransactionDate=mt.TransDate     
 and mt.FileBatchLogid =@Batchlogid    
 and mt.TransDate=tr.TransactionDate     
 and tr.ServcerMasterID=@ServicerMasterID   
 and mt.ReconFlag='Fee'   
and mt.ValueType in ('ExtensionFee','UnusedFee')  
  left join   #TempRemitDate trd on trd.noteid=mt.NoteIDGuid and trd.type=mt.ValueType and  trd.RemitDate=mt.RemitDate  
 OUTER APPLY   
 (Select sum(amount) as amount,min(t.Date) as MinDueDate from #TempTransactionEntry t   
 where t.noteid = trd.NoteID  and (t.Date >= trd.SevenDaysPrevious and t.Date <= trd.ENDDate)    
 and t.type=trd.type   
 )TrEntr  
 where mt.ValueType in ('ExtensionFee','UnusedFee')  
)    
  
Update tr set tr.deleted=1       
from cre.TranscationReconciliation tr     
INNER join cre.TransactionAuditLog ta on ta.NoteID=tr.NoteID and   
ta.TransactionType=tr.[TransactionType]  and     
ta.TransactionDate=tr.TransactionDate and    
ta.ServicerMasterID=tr.ServcerMasterID and tr.deleted=0    
where tr.posteddate is null and ta.Batchlogid =@Batchlogid   
and ta.status in  ('Note does not exist.','Data already Reconcilled.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Transaction type does not exist in Dropdown.')     
  and ta.ReconFlag='Fee'   
-- Update cre.TranscationReconciliation  Set deleted=1 where status in ('Remit Amount is Zero.','Data already Reconcilled.') and Batchlogid=@Batchlogid    
    
 END   
 ----======================================End Fee Transaction=====================================================  
  
  
  
     
    
---Start ScheduledPrincipalPaid---------------------------------    
IF EXISTS(select distinct NoteID from IO.L_ManualTransaction  where ReconFlag = 'ScheduledPrincipalPaid')    
BEGIN    
    
  --==============================================================    
Declare @tblDateRange_sp as table(Date date)        
    
IF OBJECT_ID('tempdb..#TempRemitDate_sp') IS NOT NULL                                               
 DROP TABLE #TempRemitDate_sp      
    
CREATE TABLE #TempRemitDate_sp        
(        
Noteid UNIQUEIDENTIFIER,       
type nvarchar(256),        
RemitDate date,         
StartDate_4daybef Date,     
StartDate_5daybef Date,             
ENDDate Date  ,  
SevenDaysPrevious Date   ,
StartDate_10daybef date ,
StartDate_10dayafter date
)      
Declare @NoteId_sp UNIQUEIDENTIFIER    
Declare @TransactionType_sp nvarchar(50)    
Declare @LandingID_sp uniqueidentifier    
Declare @RemitDate_sp Date    
    
IF CURSOR_STATUS('global','CursorRemitDate_sp')>=-1        
BEGIN        
 DEALLOCATE CursorRemitDate_sp        
END        
        
DECLARE CursorRemitDate_sp CURSOR         
for        
(        
    
 Select LandingID,NoteIDGuid ,ValueType as TransactionType,RemitDate from io.L_ManualTransaction where ReconFlag = 'ScheduledPrincipalPaid'  
)        
OPEN CursorRemitDate_sp         
        
FETCH NEXT FROM CursorRemitDate_sp        
INTO @LandingID_sp,@NoteId_sp,@TransactionType_sp,@RemitDate_sp    
        
WHILE @@FETCH_STATUS = 0        
BEGIN     
    
 Delete from @tblDateRange_sp    
    
 ;WITH CTE AS    
 (    
  SELECT DateAdd(day,-30,@RemitDate_sp) Date    
  UNION ALL    
  SELECT DateAdd(day,1,Date)  FROM CTE WHERE DateAdd(day,1,Date) <= DateAdd(day,30,@RemitDate_sp)    
 )    
 INsert  into @tblDateRange_sp(Date)    
 SELECT Distinct dbo.Fn_GetnextWorkingDays(Date,-1,'PMT Date') FROM CTE    
    
 DECLARE @StartDate_4daybef DATETIME   
 DECLARE @StartDate_5daybef DATETIME  
 DECLARE @SevenDaysPrevious_sp DATETIME  
 DECLARE @TDate_sp DATETIME    
 DECLARE @StartDate_10daybef DATETIME
  DECLARE @StartDate_10dayafter DATETIME
    
 SET @StartDate_4daybef = (Select Date as startdate from @tblDateRange_sp  where date < @RemitDate_sp order by date desc OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY)    
 SET @StartDate_5daybef = (Select Date as startdate from @tblDateRange_sp  where date < @RemitDate_sp order by date desc OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)    
 set @SevenDaysPrevious_sp = (Select Date as enddate from @tblDateRange_sp  where date < @RemitDate_sp order by date desc OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)    
 SET @TDate_sp = (Select Date as enddate from @tblDateRange_sp  where date > @RemitDate_sp order by date OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)     
 SET @StartDate_10daybef = (Select Date as startdate from @tblDateRange_sp  where date < @RemitDate_sp order by date desc OFFSET 9 ROWS FETCH NEXT 1 ROWS ONLY)  
  SET @StartDate_10dayafter = (Select Date as enddate from @tblDateRange_sp  where date > @RemitDate_sp order by date OFFSET 9 ROWS FETCH NEXT 1 ROWS ONLY)   

 insert into #TempRemitDate_sp(Noteid,RemitDate,type ,StartDate_4daybef,StartDate_5daybef ,ENDDate,SevenDaysPrevious,StartDate_10daybef,StartDate_10dayafter)      
 Select @NoteId_sp, @RemitDate_sp,@TransactionType_sp,@StartDate_4daybef,@StartDate_5daybef,@TDate_sp , @SevenDaysPrevious_sp ,@StartDate_10daybef ,@StartDate_10dayafter
          
FETCH NEXT FROM CursorRemitDate_sp    
INTO @LandingID_sp,@NoteId_sp,@TransactionType_sp,@RemitDate_sp    
END    
CLOSE CursorRemitDate_sp       
DEALLOCATE CursorRemitDate_sp      
--=================================================================   
  
  
 IF OBJECT_ID('tempdb..#TempTransactionEntry_SP') IS NOT NULL                                             
  DROP TABLE #TempTransactionEntry_SP      
    
 CREATE TABLE #TempTransactionEntry_SP(    
 Noteid UNIQUEIDENTIFIER,    
 Date date,    
 type nvarchar(256),    
 amount decimal(28,15)    
 )    
    
 INSERT INTO  #TempTransactionEntry_SP(Noteid,Date,type,amount)    
 Select NOteid    
 ,Date    
 ,[Type]    
 ,amount     
 from cre.transactionentry     
 where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     
 and type in ( 'ScheduledPrincipalPaid'  ,'PIKPrincipalPaid')
 and NOteid in (select distinct NoteIDGuid from IO.L_ManualTransaction   where ReconFlag = 'ScheduledPrincipalPaid')    
   
  
   
Update ta set ta.Status='Data already Reconcilled.'         
from cre.TransactionAuditLog ta       
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and           
ta.TransactionType=tr.[TransactionType]  and       
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and      
ta.TransactionDate=tr.TransactionDate and      
ta.ServicerMasterID=tr.ServcerMasterID      
where tr.posteddate is not null       
and ta.Batchlogid = @Batchlogid      
and tr.Ignore <> 1      
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')      
and ta.Reconflag='ScheduledPrincipalPaid'     
and tr.deleted=0  
  
  
 Update ta set ta.Status='Reimported'         
from cre.TransactionAuditLog ta       
INNER join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and            
ta.TransactionType=tr.[TransactionType]  and       
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and      
ta.TransactionDate=tr.TransactionDate and      
ta.ServicerMasterID=tr.ServcerMasterID       
where tr.posteddate is null and tr.deleted=0      
and ta.Batchlogid =@Batchlogid      
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')      
and ta.TransactionType in ('ScheduledPrincipalPaid')      
and ta.ReconFlag = 'ScheduledPrincipalPaid'    
  
  
    
 Update ta set ta.ShouldDelete=1        
 from IO.L_ManualTransaction ta       
 inner join cre.TranscationReconciliation tr on ta.NoteIDGuid=tr.NoteID and         
 ta.ValueType=tr.[TransactionType]  and       
 isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and      
 ta.TransDate=tr.TransactionDate and      
 @ServicerMasterID=tr.ServcerMasterID      
 where tr.posteddate is not null     
 and tr.Ignore <> 1     
 and ta.ReconFlag = 'ScheduledPrincipalPaid'    
    
    
 --================Update Excisting Data=====================    
 Update cre.TranscationReconciliation     
 set cre.TranscationReconciliation.Deleted=1,     
 cre.TranscationReconciliation.UpdatedDate=GETDATE(),    
 cre.TranscationReconciliation.UpdatedBy=@uploadedby    
 from    
 (    
  SELECT tr.Transcationid,    
    ttr.LandingID,    
   -- ttr.ServcerMasterID,       
    ttr.RemitDate,    
    ttr.ValueType,    
    ttr.DueDate,    
    isnull(ttr.Value,0) as ServicingAmount,    
    tr.posteddate      
  from IO.L_ManualTransaction  ttr     
  inner join cre.TranscationReconciliation tr on ttr.NoteIDGuid=tr.NoteID and     
  ttr.ValueType=tr.[TransactionType]  and     
  ttr.RemitDate=tr.RemittanceDate and    
  ttr.TransDate=tr.TransactionDate     
  and @ServicerMasterID=tr.ServcerMasterID     
  where tr.posteddate is null and tr.deleted=0 and  ttr.ReconFlag = 'ScheduledPrincipalPaid'    
    
  ----Need to change    
 ) a    
 where a.Transcationid=cre.TranscationReconciliation.Transcationid    
  
 --================Update Excisting Data=====================    
    
    
Update IO.[L_ManualTransaction] SET IO.[L_ManualTransaction].M61Amount = z.M61Amount,    
IO.[L_ManualTransaction].M61PayDowns = z.M61PayDowns,    
IO.[L_ManualTransaction].M61SchePrinPlusPaydowns = z.M61SchePrinPlusPaydowns ,
IO.[L_ManualTransaction].DueDate = z.DueDate,
IO.[L_ManualTransaction].PikPrinPaid = z.PikPrinPaid,
IO.[L_ManualTransaction].PikPrinPaidPlusPaydowns = z.PikPrinPaidPlusPaydowns,
IO.[L_ManualTransaction].PikPrinPaidPlusSchePrin = z.PikPrinPaidPlusSchePrin,
IO.[L_ManualTransaction].PikPrinPaidSchePrinPlusPaydowns = z.PikPrinPaidSchePrinPlusPaydowns
From(    
  SELECT      
  ttr.LandingID,    
 -- ttr.DealID,    
  ttr.NoteIDGuid,       
  @ServicerMasterID as ServcerMasterID,       
  ttr.RemitDate,    
  ttr.ValueType,    
  
  --ttr.DueDate,     
  ISNULL(aa.MinDueDate,ttr.RemitDate) as DueDate,

  ttr.TransDate,     
  isnull(ttr.Value,0)  as ServicingAmount ,     
  ISNULL(aa.amount,0) M61Amount,    
  ISNULL(FF.amount,0) M61PayDowns,    
  (ISNULL(aa.amount,0) + ISNULL(FF.amount,0)) as M61SchePrinPlusPaydowns ,
  
  iSNULL(tblpikpripaid.amount,0) as PikPrinPaid,
  (iSNULL(tblpikpripaid.amount,0) + ISNULL(FF.amount,0)) as PikPrinPaidPlusPaydowns,
  (iSNULL(tblpikpripaid.amount,0) +  ISNULL(aa.amount,0)) as PikPrinPaidPlusSchePrin,
  (ISNULL(aa.amount,0) + ISNULL(FF.amount,0) + iSNULL(tblpikpripaid.amount,0)) as PikPrinPaidSchePrinPlusPaydowns    
     
  from IO.[L_ManualTransaction] ttr     
  left join   #TempRemitDate_sp trd on trd.noteid=ttr.NoteIDGuid and trd.type=ttr.ValueType and  trd.RemitDate=ttr.RemitDate   
  OUTER APPLY     
  (    
   Select min(t.Date) as MinDueDate,sum(amount) as amount from #TempTransactionEntry_SP t    
   where t.noteid = ttr.NoteIDGuid and t.Date between DATEADD(day,1,EOMONTH(DATEADD(month,-1,trd.RemitDate))) and EOMONTH(trd.RemitDate)  
   --and t.type=ttr.ValueType  
   and t.[Type] = 'ScheduledPrincipalPaid'

   ---trd.StartDate_10daybef and trd.StartDate_10dayafter  ----trd.RemitDate ---dateadd(d,-5, ttr.RemitDate) and  dateadd(d,7, ttr.RemitDate)    
  )aa  
    OUTER APPLY   
  (  
   Select sum(amount) as amount   from #TempTransactionEntry_SP t  
   where t.noteid = ttr.NoteIDGuid 
   and t.Date between trd.StartDate_4daybef and trd.RemitDate  --dateadd(d,-5, ttr.RemitDate) and  dateadd(d,7, ttr.RemitDate)  
   --and t.type=ttr.TransactionType  
   and t.[Type] = 'PIKPrincipalPaid'
  )tblpikpripaid   
  Outer Apply(    
   Select n.noteid,ABS(SUM(fs.value)) as amount    
   from [CORE].FundingSchedule fs    
   INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId    
   INNER JOIN     
   (          
    Select     
    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID    
    from [CORE].[Event] eve    
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')    
    and n.NoteID = ttr.NoteIDGuid    
    and acc.IsDeleted = 0    
    and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)    
    GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID    
   ) sEvent    
   ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID    
   left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID    
   left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID     
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
   where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0    
   and fs.purposeid in (Select Lookupid from core.lookup where parentid = 50 and [Value] = 'Negative' and [Name] <> 'Amortization') --All paydowns    
    
   and fs.Date between trd.StartDate_4daybef and trd.RemitDate ---dateadd(d,-4, ttr.RemitDate) and  ttr.RemitDate    
   and n.noteid = ttr.NoteIDGuid    
   group by  n.noteid    
  )FF    
  where ttr.ReconFlag = 'ScheduledPrincipalPaid'    
 )z    
 where IO.L_ManualTransaction.LandingID = z.LandingID and IO.L_ManualTransaction.ReconFlag = 'ScheduledPrincipalPaid'    
    
    
 --Update IO.L_ManualTransaction  SET SchePrin_Flag = 'SP_Matched'    
 --where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(Value,2) =  ROUND(M61Amount,2)    
     
 --Update IO.L_ManualTransaction  SET SchePrin_Flag = 'SP_Ignore_Paydowns'    
 --where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null    
 --and ROUND(Value,2) = ROUND(M61PayDowns,2)    
    
 --Update IO.L_ManualTransaction  SET SchePrin_Flag = 'SP_has_SchePrinPlusPaydowns',Value = M61Amount    
 --where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null    
 --and ROUND(Value,2) = ROUND(M61SchePrinPlusPaydowns ,2)   
    
 --Update IO.L_ManualTransaction  SET SchePrin_Flag = 'SP_KeepAsItIs'--,ServicingAmount = (CASE WHEN ISNULL(M61Amount,0) = 0 THEN ServicingAmount ELSE M61Amount END)      
 --where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null    
     
 Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_Matched'  
 where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(Value,2) =  ROUND(M61Amount,2)  

 --------------------------------------
 Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_Ignore_Paydowns'  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(Value,2) = ROUND(M61PayDowns,2)  
 
Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_Ignore_PikPrinPaid'  
where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
and ROUND(Value,2) = ROUND(PikPrinPaid,2) 
 
Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_Ignore_Paydowns_PikPrinPaid'  
where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
and ROUND(Value,2) = ROUND(PikPrinPaidPlusPaydowns,2) 
--------------------------------------
  
 Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_has_SchePrinPlusPaydowns',Value = M61Amount  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(Value,2) = ROUND(M61SchePrinPlusPaydowns ,2) 

  Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_has_SchePrinPlusPikPrinPaid',Value = M61Amount  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(Value,2) = ROUND(PikPrinPaidPlusSchePrin ,2) 

 Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_has_SchePrinPlusPaydownsplusPikPrinPaid',Value = M61Amount  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(Value,2) = ROUND(PikPrinPaidSchePrinPlusPaydowns ,2) 
  
 Update IO.L_ManualTransaction SET SchePrin_Flag = 'SP_KeepAsItIs'  ---,ServicingAmount = ISNULL(M61Amount,0) ---(CASE WHEN ISNULL(M61Amount,0) = 0 THEN ServicingAmount ELSE M61Amount END)    
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null
  


Update ta set ta.Status='Ignore Paydowns'         
from cre.TransactionAuditLog ta       
INNER join io.L_ManualTransaction tr on ta.NoteID=tr.NoteIDGuid and            
ta.TransactionType=tr.ValueType  and       
isnull(ta.RemitDate,getdate())=isnull(tr.RemitDate,getdate()) and      
ta.TransactionDate=tr.TransDate and      
ta.ServicerMasterID=@ServicerMasterID   
where      
 ta.Batchlogid =@Batchlogid      
and ta.[Status] not in  ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Transaction type does not exist in Dropdown.')        
and ta.TransactionType in ('ScheduledPrincipalPaid')      
and ta.ReconFlag = 'ScheduledPrincipalPaid'    
and tr.SchePrin_Flag = 'SP_Ignore_Paydowns'   


Update ta set ta.Status='Ignore Pik Principal Paid'       
from cre.TransactionAuditLog ta     
INNER join io.L_ManualTransaction tr on ta.NoteID=tr.NoteIDGuid and          
ta.TransactionType=tr.ValueType  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemitDate,getdate()) and    
ta.TransactionDate=tr.TransDate and    
ta.ServicerMasterID=@ServicerMasterID
where    
 ta.Batchlogid =@Batchlogid    
and ta.[Status] not in  ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Transaction type does not exist in Dropdown.')         
and ta.TransactionType in ('ScheduledPrincipalPaid')    
and ta.ReconFlag = 'ScheduledPrincipalPaid'  
and tr.SchePrin_Flag = 'SP_Ignore_PikPrinPaid' 


 Update ta set ta.Status='Ignore Paydowns Plus Pik Principal Paid'       
from cre.TransactionAuditLog ta     
INNER join io.L_ManualTransaction tr on ta.NoteID=tr.NoteIDGuid and          
ta.TransactionType=tr.ValueType  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemitDate,getdate()) and    
ta.TransactionDate=tr.TransDate and    
ta.ServicerMasterID=@ServicerMasterID
where    
 ta.Batchlogid =@Batchlogid    
and ta.[Status] not in  ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Transaction type does not exist in Dropdown.')     
and ta.TransactionType in ('ScheduledPrincipalPaid')    
and ta.ReconFlag = 'ScheduledPrincipalPaid'  
and tr.SchePrin_Flag = 'SP_Ignore_Paydowns_PikPrinPaid'
  
 --================Insert New data================    
 INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,AddlInterest,TotalInterest)    
 SELECT      
 d.DealID,    
 n.NoteID,       
 @ServicerMasterID,       
 ttr.RemitDate,    
 ttr.ValueType,    
 ttr.DueDate,     
 isnull(ttr.Value,0)  as ServicingAmount ,    
 isnull(ttr.M61Amount,0) as CalculatedAmount,     
 round(isnull(ttr.Value,0)-isnull(ttr.M61Amount,0),2) as Delta,    
 TransDate,        
 @uploadedby as createdby,    
 GETDATE() as createdDate,    
 @uploadedby as updatedby,    
 GETDATE() as UpdatedDate,    
 @Batchlogid,    
    ttr.CapitalizedInterest,ttr.CashInterest 
 from IO.L_ManualTransaction  ttr     
 left join cre.TranscationReconciliation tr on ttr.NoteIDGuid=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND ttr.ValueType=tr.[TransactionType]  and ttr.RemitDate=tr.RemittanceDate and ttr.TransDate=tr.TransactionDate and @ServicerMasterID=
tr.ServcerMasterID     
 left join cre.note n on n.NoteID=ttr.NoteIDGuid     
 left join cre.Deal d on d.DealID=n.DealID    
 inner join (    
  Select BatchLogID    
  ,NoteID    
  ,TransactionType    
  ,DueDate    
  ,RemitDate    
  ,Status    
  ,ServicerMasterID    
  ,TransactionDate     
  from cre.TransactionAuditLog ----Need to change     
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported') and TransactionType = 'ScheduledPrincipalPaid'    
 )ta on     
 ta.NoteID=ttr.NoteIDGuid     
 and ttr.ValueType=ta.TransactionType     
 and ttr.RemitDate=ta.RemitDate     
 and ttr.TransDate=ta.TransactionDate     
 and @ServicerMasterID=ta.ServicerMasterID    
 and ttr.ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag not in ( 'SP_Ignore_Paydowns'  ,'SP_Ignore_PikPrinPaid','SP_Ignore_Paydowns_PikPrinPaid')
 --================Insert New data================    
    
    
END    
---END Fee ScheduledPrincipalPaid---------------------------------    
  
  
  
  
  
--Select @TotalRowsCount=count(NoteID) from IO.[L_ManualTransaction]     
--where FileBatchlogid=@Batchlogid    
----and ValueType='InterestPaid' OR ValueType in (Select RTRIM(LTRIM(FeeTypeNameText)) from cre.feeschedulesconfig)    
    
--Select @ignoredrows=count(TransactionAuditLogID) from CRE.TransactionAuditLog where [status] in ('Note does not exist.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Transaction type does not configured in tran
--saction master.', 'Note Enable M61 Calculations is N.','Duplicate Record','Ignore Paydowns') and BatchLogID=@Batchlogid     
    
--set @rowsinTrans =@TotalRowsCount - @ignoredrows    
    
--if(@rowsinTrans >= 0)    
--BEGIN    
-- set @successmsg= cast ((@rowsinTrans) as varchar(10)) + ' record(s) imported successfully.'    
--END    
--ELSE    
--BEGIN    
-- set @successmsg= cast ((@TotalRowsCount) as varchar(10)) + ' record(s) imported successfully.'    
--END    
    
--if(@ignoredrows>0)    
--Begin    
-- set @successmsg= @successmsg + ' ' + cast((@ignoredrows)  as varchar(10) )+ ' record(s) were ignored.'    
--END    
    
--select @successmsg    
    

	--------------------------------- Total records imported--------------------------------

select TransactionType,sum(totalrecords-ignored) Totalrecords,sum(ignored) as ignored from (

select  TransactionType,count(Status) totalrecords,0 as ignored
 from CRE.TransactionAuditLog  where BatchLogID=@Batchlogid group by TransactionType,BatchLogID
UNION ALL
select  TransactionType,0,count(Status) as ignored
 from CRE.TransactionAuditLog  where BatchLogID=@Batchlogid 
 and [Status] in  ('Note does not exist.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Transaction type does not configured in transaction master.', 'Note Enable M61 Calculations is N.','Duplicate Record','Ignore Paydowns',  'Ignore Pik Principal Paid','Ignore Paydowns Plus Pik Principal Paid' ,'Transaction type does not exist in Dropdown.')
 
 group by TransactionType,BatchLogID

 )aa
 group by TransactionType
    
Delete from IO.L_ManualTransaction     
       
END 