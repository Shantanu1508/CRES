  
--[dbo].[usp_ImportIntoTranscationBerkadia] 888, 'c10f3372-0fc2-4861-a9f5-148f1f80804f'   
CREATE PROCEDURE [dbo].[usp_ImportIntoTranscationBerkadia]   
(  
 @Batchlogid int,  
 @ScenarioId varchar(100)  
 )  
AS  
BEGIN  
  
  ----CashInterest+ExitFee+ExtensionFee+PrepaymentYMFeesMaintenance+UnusedFee+OtherFees+PrincipalAdj+LateCharge-TotalRemit


--Update Exception in landing table  
  
Update IO.[L_Berkadia] set IO.[L_Berkadia].Exception = 'Exception'  
From(  
 Select LandingID,noteid,Sum_Value From(  
  Select LandingID,noteid,CashInterest,ExitFee,ExtensionFee,PrepaymentYMFeesMaintenance,UnusedFee,OtherFees,PrincipalAdj,LateCharge,TotalRemit ,  
  Round( (ISNULL(CashInterest,0) + ISNULL(ExitFee,0) + ISNULL(ExtensionFee,0)  + ISNULL(PrepaymentYMFeesMaintenance,0)+ISNULL(UnusedFee,0)+ISNULL(OtherFees,0)+ISNULL(PrincipalAdj,0) + ISNULL(LateCharge,0) + isnull(AddlInt,0) ),2)  - Round(ISNULL(TotalRemit,0),2) as Sum_Value  
 from IO.[L_Berkadia]  
 )a  
 Where a.Sum_Value <> 0  
)b  
Where b.LandingID = IO.[L_Berkadia].LandingID  


--Update IO.[L_Berkadia] set IO.[L_Berkadia].ExceptionFee = 'Exception'  
--From(  
-- Select LandingID,noteid,Sum_Value From(  
--  Select LandingID,noteid,CashInterest,ExitFee,ExtensionFee,PrepaymentYMFeesMaintenance,UnusedFee,OtherFees,PrincipalAdj,LateCharge,TotalRemit ,  
--  Round( (0 + ISNULL(ExitFee,0) + ISNULL(ExtensionFee,0)  + ISNULL(PrepaymentYMFeesMaintenance,0)+ISNULL(UnusedFee,0)+ISNULL(OtherFees,0)+ISNULL(PrincipalAdj,0) + ISNULL(LateCharge,0) + 0 ),2)  - Round(ISNULL(TotalRemit,0),2) as Sum_Value  
-- from IO.[L_Berkadia]  
-- )a  
-- Where a.Sum_Value <> 0  
--)b  
--Where b.LandingID = IO.[L_Berkadia].LandingID
  
  
--Drop table #TempTransaction  
CREATE TABLE #TempTransaction(  
  LandingID uniqueidentifier,    
  NoteID uniqueidentifier,    
  TransactionType nvarchar(250),  
  Transcationtypeid int,    
  ServicingAmount decimal(28,15),  
  DueDate Datetime,  
  RemitDate Datetime,  
  ServcerMasterID int ,  
  TotalRemit decimal(28,15),  
  TranDate Datetime,  
  CapitalizedInterest decimal(28,15),  
  CashInterest decimal(28,15),  
  BerAddlint  decimal(28,15),  
  Exception nvarchar(256),  
    ShouldDelete int null,
	ReconFlag nvarchar(50)  ,
M61Amount decimal(28,15),    
M61PayDowns decimal(28,15),    
M61SchePrinPlusPaydowns decimal(28,15),  

PikPrinPaid decimal(28,15), 
PikPrinPaidPlusPaydowns decimal(28,15), 
PikPrinPaidPlusSchePrin decimal(28,15), 
PikPrinPaidSchePrinPlusPaydowns decimal(28,15),
  
SchePrin_Flag nvarchar(50)  
--ExceptionFee  nvarchar(256)   
  )  
   
 DECLARE @uploadedby varchar(250)  
 DECLARE @ignoredrows int,@TotalRowsCount int,@rowsinTrans int,@successmsg varchar(250)  
   
  
INSERT INTO #TempTransaction(LandingID,NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,CapitalizedInterest,CashInterest,Exception,BerAddlint,ShouldDelete)    
  (   
  SELECT LandingID,n.noteid,TrType, (Select LookupID from core.lookup where parentid=39 and [Name] = TrType) as TrTypeLokkupId,Ser_Amount as ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,CapitalizedInterest,CashInterest,Exception,AddlInt ,0 as ShouldDelete   
  FROM   
 (    
 
   Select LandingID, NoteID,DueDate,PrincipalAdj as [ScheduledPrincipalPaid],isnull(CapitalizedInterest,0)*-1 as CapitalizedInterest ,isnull(CashInterest,0) as CashInterest,RemitDate,(SELECT ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid) as ServcerMasterID,TotalRemit,TranDate,Exception,AddlInt,cast( isnull(CashInterest,0) +isnull(CapitalizedInterest,0)+ isnull(AddlInt,0) as decimal(28,15)) as InterestPaid,cast(ExitFee as decimal(28,15)) AS ExitFee,cast(ExtensionFee as decimal(28,15)) as ExtensionFee  ,cast(PrepaymentYMFeesMaintenance as decimal(28,15)) as PrepaymentFee,cast(UnusedFee as decimal(28,15)) as UnusedFee
   from IO.L_Berkadia   
   where FileBatchlogid=@Batchlogid   
    
 ) P  
 UNPIVOT  
 (  
  Ser_Amount FOR TrType IN ([InterestPaid],ExitFee ,ExtensionFee,PrepaymentFee ,UnusedFee,[ScheduledPrincipalPaid] )  
 )  
  AS unpvt 
	inner join cre.Note n on n.crenoteid=unpvt.NoteID  and   isnull( unpvt.Ser_Amount,0)>0 
	inner join core.account acc on acc.accountid = n.Account_accountid
	where acc.isdeleted <> 1   
  
 )   
  

--Hot fix for unused fee--  
	UPDATE #TempTransaction set CapitalizedInterest =null , CashInterest =null where TransactionType<>'InterestPaid'

	--UPDATE #TempTransaction set Exception=ExceptionFee where TransactionType<>'InterestPaid'     
--Hot fix for unused fee--  
      
update #TempTransaction set ReconFlag=case when TransactionType='InterestPaid' THEN 'InterestPaid' WHEN TransactionType='ScheduledPrincipalPaid' THEN 'ScheduledPrincipalPaid' ELSE 'Fee' END    
 
  
--already summed in above formula
--update #TempTransaction set ServicingAmount=isnull(ServicingAmount,0)+isnull(BerAddlint,0) where ReconFlag = 'InterestPaid'    


Delete from #TempTransaction where ReconFlag in ('ScheduledPrincipalPaid','Fee') and ISNULL(ServicingAmount,0) = 0 

Delete from #TempTransaction where ServicingAmount=0 or ShouldDelete = 1  
  
  
  SELECT @uploadedby=CreatedBy FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid  
  
select @TotalRowsCount=count(NoteID) from #TempTransaction --WHERE TransactionType='InterestPaid'    


--============================Delete Duplicate Records========================  
    
;WITH CTE AS(  
   SELECT NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,  
       RN = ROW_NUMBER()OVER(PARTITION BY NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID   
    order by NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID)  
   FROM #TempTransaction  
)   
  
  
INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,TotalRemit,ServicerMasterID,TransactionDate)(  
 SELECT   
   @Batchlogid,  
   ttr.NoteID,   
   ttr.TransactionType,   
   ttr.DueDate,  
   ttr.RemitDate,   
   isnull(ttr.ServicingAmount,0) as ServicingAmount,  
   'Duplicate Record',  
   ttr.TotalRemit,  
   ttr.ServcerMasterID,   
   ttr.TranDate       
  FROM CTE ttr WHERE RN > 1   
)  
  
  
;WITH Dupl AS(  
   SELECT NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,  
       RN = ROW_NUMBER()OVER(PARTITION BY NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID   
    order by NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID)  
   FROM #TempTransaction  
)   
Delete from Dupl where RN>1  
  
 --============================Delete Duplicate Records========================  
  
  
---==========================Insert into TransactionAuditLog====================================  
  
  
  
  INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,TotalRemit,ServicerMasterID,TransactionDate,ReconFlag)(  
  SELECT   
   @Batchlogid,  
   ttr.NoteID,   
   ttr.TransactionType,   
   ttr.DueDate,  
   ttr.RemitDate,   
   isnull(ttr.ServicingAmount,0) as ServicingAmount,  
   'Imported',  
   ttr.TotalRemit,  
   ttr.ServcerMasterID,   
   ttr.TranDate  ,
   ttr.ReconFlag 
 from #TempTransaction ttr    
 )  
  
  
  
Update ta set ta.Status='Note does not exist.'   
from cre.TransactionAuditLog ta   
inner join cre.Note n on ta.Noteid=n.noteid  
inner join IO.L_Berkadia r on r.NoteID=n.CRENoteid   
inner Join core.account a on n.Account_AccountID=a.AccountID   
where (a.IsDeleted=1 or a.StatusID=2) and ta.Batchlogid = @Batchlogid   

  
Update ta set ta.Status='Note Enable M61 Calculations is N.'	
from cre.TransactionAuditLog ta 
inner join cre.Note n on ta.Noteid=n.noteid
inner join IO.L_Berkadia r on r.NoteID=n.CRENoteid 
where n.EnableM61Calculations=4 and ta.Batchlogid = @Batchlogid 

 
--Update cre.TranscationReconciliation SET Deleted = 1  
--Where PostedDate is null  
--and Noteid in(  
--Select Noteid from cre.TransactionAuditLog where [Status]='Note does not exist.'   
--)  
  


  
Update ta set ta.Status='Data already Reconcilled.'     
from cre.TransactionAuditLog ta   
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and     
ISNULL(ta.DueDate,getdate())=ISNULL(tr.DateDue,getdate()) and     
ta.TransactionType=tr.[TransactionType]  and   
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and  
ta.TransactionDate=tr.TransactionDate and  
ta.ServicerMasterID=tr.ServcerMasterID  
where tr.posteddate is not null   
and ta.Batchlogid = @Batchlogid  
and tr.Ignore <> 1  
and ta.[Status]not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')   
and ta.Reconflag='InterestPaid'  
-------------------------------------interest Paid---------------------------------  

Update ta set ta.ShouldDelete=1      
from #TempTransaction ta     
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and       
ta.DueDate=tr.DateDue and     
ta.TransactionType=tr.[TransactionType]  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and    
ta.TranDate=tr.TransactionDate and    
ta.ServcerMasterID=tr.ServcerMasterID    
where tr.posteddate is not null   
and tr.Ignore <> 1    
and ta.ReconFlag='InterestPaid'
  
Update ta set ta.Status='Reimported'     
from cre.TransactionAuditLog ta   
INNER join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and     
ISNULL(ta.DueDate,getdate())=ISNULL(tr.DateDue,getdate()) and    
ta.TransactionType=tr.[TransactionType]  and   
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and   
ta.TransactionDate=tr.TransactionDate and  
ta.ServicerMasterID=tr.ServcerMasterID   
where tr.posteddate is null and tr.deleted=0  
and ta.Batchlogid =@Batchlogid  
 and ta.[Status]not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')    
  and ta.TransactionType in ('InterestPaid')    
and ta.ReconFlag='InterestPaid' 
  
  
--Update ta set ta.Status='Zero Interest'     
--from cre.TransactionAuditLog ta   
--where ta.Batchlogid =@Batchlogid  
--and ta.ServicingAmount=0  


Update cre.TranscationReconciliation SET cre.TranscationReconciliation.Deleted = 1
From(
	Select 
	tr.TranscationID
	from cre.TranscationReconciliation tr
	inner join cre.TransactionAuditLog ta on 
	ta.NoteID=tr.NoteID 
	and	tr.DateDue=ta.DueDate 
	and tr.TransactionType=ta.TransactionType 
	and tr.RemittanceDate=ta.RemitDate 
	and	tr.TransactionDate=ta.TransactionDate 
	and	tr.ServcerMasterID=ta.ServicerMasterID
	and PostedDate is null
	where ta.BatchLogid = @Batchlogid and ta.status in ('Note does not exist.','Data already Reconcilled.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record'	) 
	and  ta.ReconFlag='InterestPaid' 
)a
where cre.TranscationReconciliation.TranscationID = a.TranscationID


  
Delete from #TempTransaction where ServicingAmount=0 or ShouldDelete = 1  
---==========================Insert into TransactionAuditLog====================================  
  
  
  
 --================Update Excisting Data=====================  
 Update cre.TranscationReconciliation   
 set cre.TranscationReconciliation.Deleted=1,   
 cre.TranscationReconciliation.UpdatedDate=GETDATE(),  
 cre.TranscationReconciliation.UpdatedBy=@uploadedby  
 from  
 (  
  SELECT tr.Transcationid,  
    ttr.LandingID,  
    ttr.ServcerMasterID,     
    ttr.RemitDate,  
    ttr.TransactionType,  
    ttr.DueDate,  
    isnull(ttr.ServicingAmount,0) as ServicingAmount,  
    tr.posteddate    
  from #TempTransaction ttr   
  inner join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID and     
  ttr.DueDate=tr.DateDue and   
  ttr.TransactionType=tr.[TransactionType]  and   
  ttr.RemitDate=tr.RemittanceDate and  
  ttr.TranDate=tr.TransactionDate and  
  ttr.ServcerMasterID=tr.ServcerMasterID and  
  ttr.TranDate=tr.TransactionDate  
  where tr.posteddate is null and tr.deleted=0   and ttr.ReconFlag='InterestPaid'
 ) a  
 where a.Transcationid=cre.TranscationReconciliation.Transcationid  
 --================Update Excisting Data=====================  
  
  
   
 ---================Insert New data================  
INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,BerAddlint,InterestAdj)
  
 SELECT    
 d.DealID,  
 n.NoteID,     
 ttr.ServcerMasterID as ServcerMasterID,     
 ttr.RemitDate,  
 ttr.TransactionType,  
 ttr.DueDate,   
 isnull(ttr.ServicingAmount,0) as ServicingAmount,  
 isnull(CREtr.Amount,0) as CalculatedAmount,   
 --round((isnull(ttr.ServicingAmount,0)-isnull(CREtr.Amount,0)),2) as Delta,  
 round(isnull(ttr.ServicingAmount,0),2)-round(isnull(CREtr.Amount,0),2) as Delta,  
 TranDate,      
 @uploadedby as createdby,  
 GETDATE() as createdDate,  
 @uploadedby as updatedby,  
 GETDATE() as UpdatedDate,  
 @Batchlogid ,  
 ttr.Exception,  
 ttr.CapitalizedInterest,  
-- Round(isnull(ttr.ServicingAmount,0),2) + Round(isnull(ttr.CapitalizedInterest,0),2) ,AddlInterest,TotalInterest  
 Round(isnull(ttr.CashInterest,0),2),  
 0 as Adjustment,  
 isnull(ttr.ServicingAmount,0)-isnull(CREtr.Amount,0) as ActualDelta,  
 round(isnull(ttr.BerAddlint,0),2)as BerAddlint ,
  round(isnull(ttr.BerAddlint,0),2) as InterestAdj 
 from #TempTransaction ttr   
 left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND  
 ttr.DueDate=tr.DateDue and   
 ttr.TransactionType=tr.[TransactionType]  and   
 ttr.RemitDate=tr.RemittanceDate and  
 ttr.TranDate=tr.TransactionDate and  
 ttr.ServcerMasterID=tr.ServcerMasterID   
 left join [Cre].Transactionentry CREtr on ttr.NoteID=CREtr.NoteID and ttr.DueDate=CREtr.Date and ttr.TransactionType=CREtr.Type and AnalysisID=@ScenarioId  and CREtr.[Type]='InterestPaid'   
 left join cre.note n on n.NoteID=ttr.NoteID   
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
		where BatchLogid = @Batchlogid and status in ('Imported','Reimported') and TransactionType = 'InterestPaid'   
	)ta on 
	ta.NoteID=ttr.NoteID 
	and	ttr.DueDate=ta.DueDate 
	and ttr.TransactionType=ta.TransactionType 
	and ttr.RemitDate=ta.RemitDate 
	and	ttr.TranDate=ta.TransactionDate 
	and	ttr.ServcerMasterID=ta.ServicerMasterID
	and ttr.ReconFlag='InterestPaid'
  
 --where   ttr.Noteid not in (Select Noteid from cre.TransactionAuditLog where [Status] in ('Note does not exist.') and Batchlogid = @Batchlogid)  
   
   
   

  ---================END Insert New data================  
  -------------------------------------END interest Paid---------------------------------

---=====================Start Fee Transaction==========================
IF EXISTS(select distinct NoteID from #TempTransaction where ReconFlag = 'Fee')    
BEGIN    
    
--==============================================================  
Declare @tblDateRange as table(Date date)      
  
IF OBJECT_ID('tempdb..#TempRemitDate') IS NOT NULL                                             
 DROP TABLE #TempRemitDate    
  
CREATE TABLE #TempRemitDate      
(      
Noteid UNIQUEIDENTIFIER,     
type nvarchar(256),      
RemitDate date,       
StartDate Date,        
ENDDate Date ,
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
  
 Select LandingID,NoteId,TransactionType,RemitDate from #TempTransaction --where [Transcationid]  ='C637A832-1A23-44D1-966C-6B1509DF681A'      
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
 SET @TDate = (Select Date as enddate from @tblDateRange  where date > @RemitDate order by date OFFSET 5 ROWS FETCH NEXT 1 ROWS ONLY)    
  
 insert into #TempRemitDate(Noteid,RemitDate,type ,StartDate ,ENDDate,SevenDaysPrevious)    
 Select @NoteId, @RemitDate,@TransactionType,@SDate,@TDate ,@SevenDaysPrevious 
        
FETCH NEXT FROM CursorRemitDate  
INTO @LandingID,@NoteId,@TransactionType,@RemitDate  
END  
CLOSE CursorRemitDate     
DEALLOCATE CursorRemitDate  
  
--=================================================================  
 IF OBJECT_ID('tempdb..#TempTransactionEntry') IS NOT NULL                                             
  DROP TABLE #TempTransactionEntry      
    
 CREATE TABLE #TempTransactionEntry(    
 Noteid UNIQUEIDENTIFIER,    
 Date date,    
 type nvarchar(256),    
 amount decimal(28,15)    
 )    
    
 INSERT INTO  #TempTransactionEntry(Noteid,Date,type,amount)    
 Select NOteid    
 ,Date    
 ,(case when type like '%exit%' Then 'ExitFee' when type like '%extension%' Then 'ExtensionFee' when type ='PrepaymentFeeExcludedFromLevelYield' Then 'PrepaymentFee'    
  when type ='UnusedFeeExcludedFromLevelYield' Then 'UnusedFee'    
 END)    
,round(isnull(amount,0),2) as  amount     
 from cre.transactionentry     
 where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     
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
 and NOteid in (select distinct NoteID from #TempTransaction  where ReconFlag = 'Fee')    
  


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
and ta.[Status]not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')   
and ta.Reconflag='Fee' 
and tr.deleted=0


   Update ta set ta.ShouldDelete=1      
from #TempTransaction ta     
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and  
ta.TransactionType=tr.[TransactionType]  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and    
ta.TranDate=tr.TransactionDate and    
ta.ServcerMasterID=tr.ServcerMasterID    
where tr.posteddate is not null   
and tr.Ignore <> 1    
and ta.ReconFlag = 'Fee'

  
Update ta set ta.Status='Reimported'     
from cre.TransactionAuditLog ta   
INNER join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and    
ta.TransactionType=tr.[TransactionType]  and   
isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and  
ta.TransactionDate=tr.TransactionDate and  
ta.ServicerMasterID=tr.ServcerMasterID   
where tr.posteddate is null and tr.deleted=0  
and ta.Batchlogid =@Batchlogid  
 and ta.[Status]not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')    
  
  
  



Update cre.TranscationReconciliation 
SET cre.TranscationReconciliation.Deleted = 1,
 cre.TranscationReconciliation.UpdatedDate=GETDATE(),    
 cre.TranscationReconciliation.UpdatedBy=@uploadedby  
From(
	Select 
	tr.TranscationID
	from cre.TranscationReconciliation tr
	inner join cre.TransactionAuditLog ta on 
	ta.NoteID=tr.NoteID 
	and tr.TransactionType=ta.TransactionType 
	and tr.RemittanceDate=ta.RemitDate 
	and	tr.TransactionDate=ta.TransactionDate 
	and	tr.ServcerMasterID=ta.ServicerMasterID
	and PostedDate is null
	where ta.BatchLogid = @Batchlogid and ta.status in ('Note does not exist.','Data already Reconcilled.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record') 
	and  ta.ReconFlag = 'Fee'  
)a
where cre.TranscationReconciliation.TranscationID = a.TranscationID


  
--Delete from #TempTransaction where ServicingAmount=0 or ShouldDelete = 1  
---==========================Insert into TransactionAuditLog====================================  
  
  
  
 --================Update Excisting Data=====================  
 Update cre.TranscationReconciliation   
 set cre.TranscationReconciliation.Deleted=1,   
 cre.TranscationReconciliation.UpdatedDate=GETDATE(),  
 cre.TranscationReconciliation.UpdatedBy=@uploadedby  
 from  
 (  
  SELECT tr.Transcationid,  
    ttr.LandingID,  
    ttr.ServcerMasterID,     
    ttr.RemitDate,  
    ttr.TransactionType,  
    ttr.DueDate,  
    isnull(ttr.ServicingAmount,0) as ServicingAmount,  
    tr.posteddate    
  from #TempTransaction ttr   
  inner join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID and
  ttr.TransactionType=tr.[TransactionType]  and   
  ttr.RemitDate=tr.RemittanceDate and  
  ttr.TranDate=tr.TransactionDate and  
  ttr.ServcerMasterID=tr.ServcerMasterID and  
  ttr.TranDate=tr.TransactionDate  
  where tr.posteddate is null and tr.deleted=0   and ttr.ReconFlag<>'InterestPaid'
 ) a  
 where a.Transcationid=cre.TranscationReconciliation.Transcationid  
 --================Update Excisting Data=====================  
  
  
   
 
---================Insert New data================  
INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,BerAddlint)    
 SELECT      
 d.dealid,    
 n.NoteID,       
 ttr.ServcerMasterID as ServcerMasterID,       
 ttr.RemitDate,    
 ttr.TransactionType,    
isnull(aa.MinDueDate, ttr.RemitDate)as DueDate,    
 isnull(ttr.ServicingAmount,0)  as ServicingAmount ,    
 isnull(aa.amount,0) as CalculatedAmount,     
 round(isnull(ttr.ServicingAmount,0)-isnull(aa.amount,0),2) as Delta,    
 TranDate,        
 @uploadedby as createdby,    
 GETDATE() as createdDate,    
 @uploadedby as updatedby,   GETDATE() as UpdatedDate,    
 @Batchlogid ,    
 ttr.Exception,    
 ttr.CapitalizedInterest,    
 null,     
 0 as Adjustment,    
 isnull(ttr.ServicingAmount,0) -isnull(aa.amount,0) as ActualDelta,    
 round(isnull(ttr.BerAddlint,0),2)as BerAddlint   
 from #TempTransaction ttr     
 left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND    
     
 ttr.TransactionType=tr.[TransactionType]  and     
 ttr.RemitDate=tr.RemittanceDate and    
 ttr.TranDate=tr.TransactionDate and    
 ttr.ServcerMasterID=tr.ServcerMasterID     
    
 left join   #TempRemitDate trd on trd.noteid=ttr.noteid and trd.type=ttr.TransactionType and  trd.RemitDate=ttr.RemitDate
 OUTER APPLY     
 (  
 Select sum(amount) as amount,min(t.Date) as MinDueDate  from #TempTransactionEntry t 
 where t.noteid = trd.NoteID  and  (t.Date >= trd.StartDate and t.Date <= ttr.RemitDate )  
 and t.type=trd.type   
 )aa    
 left join cre.note n on n.NoteID=ttr.NoteID     
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
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported')    
 )ta on     
 ta.NoteID=ttr.NoteID     
 and ttr.TransactionType=ta.TransactionType     
 and ttr.RemitDate=ta.RemitDate     
 and ttr.TranDate=ta.TransactionDate     
 and ttr.ServcerMasterID=ta.ServicerMasterID    
 and ttr.ReconFlag = 'Fee'
 and   ttr.TransactionType in ('ExitFee','PrepaymentFee')  
 
 
 
 INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,BerAddlint)    
 SELECT      
 d.dealid,    
 n.NoteID,       
 ttr.ServcerMasterID as ServcerMasterID,       
 ttr.RemitDate,    
 ttr.TransactionType,    
isnull(aa.MinDueDate, ttr.RemitDate)as DueDate,    
 isnull(ttr.ServicingAmount,0)  as ServicingAmount ,    
 isnull(aa.amount,0) as CalculatedAmount,     
 round(isnull(ttr.ServicingAmount,0)-isnull(aa.amount,0),2) as Delta,    
 TranDate,        
 @uploadedby as createdby,    
 GETDATE() as createdDate,    
 @uploadedby as updatedby,   GETDATE() as UpdatedDate,    
 @Batchlogid ,    
 ttr.Exception,    
 ttr.CapitalizedInterest,    
 null,     
 0 as Adjustment,    
 isnull(ttr.ServicingAmount,0) -isnull(aa.amount,0) as ActualDelta,    
 round(isnull(ttr.BerAddlint,0),2)as BerAddlint   
 from #TempTransaction ttr     
 left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND    
     
 ttr.TransactionType=tr.[TransactionType]  and     
 ttr.RemitDate=tr.RemittanceDate and    
 ttr.TranDate=tr.TransactionDate and    
 ttr.ServcerMasterID=tr.ServcerMasterID     
    
 left join   #TempRemitDate trd on trd.noteid=ttr.noteid and trd.type=ttr.TransactionType and  trd.RemitDate=ttr.RemitDate
 OUTER APPLY     
 (  
 Select sum(amount) as amount,min(t.Date) as MinDueDate from #TempTransactionEntry t 
 where t.noteid = trd.NoteID  and  (t.Date >= trd.SevenDaysPrevious and t.Date <= trd.ENDDate)  
 and t.type=trd.type   
 )aa    
 left join cre.note n on n.NoteID=ttr.NoteID     
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
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported')    
 )ta on     
 ta.NoteID=ttr.NoteID     
 and ttr.TransactionType=ta.TransactionType     
 and ttr.RemitDate=ta.RemitDate     
 and ttr.TranDate=ta.TransactionDate     
 and ttr.ServcerMasterID=ta.ServicerMasterID    
 and ttr.ReconFlag = 'Fee'
  and   ttr.TransactionType in ('ExtensionFee','UnusedFee') 


END   
-------------------------------------END Fee Transaction------------------------------------------------
---Start ScheduledPrincipalPaid---------------------------------  
IF EXISTS(select distinct NoteID from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid')  
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
SevenDaysPrevious Date  ,
StartDate_10daybef date,
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
  
 Select LandingID,NoteId,TransactionType,RemitDate from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid'
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
 Select @NoteId_sp, @RemitDate_sp,@TransactionType_sp,@StartDate_4daybef,@StartDate_5daybef,@TDate_sp , @SevenDaysPrevious_sp,@StartDate_10daybef,@StartDate_10dayafter
        
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
 and NOteid in (select distinct NoteID from #TempTransaction  where ReconFlag = 'ScheduledPrincipalPaid')  
  
 
 
 --New
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

--New
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
 from #TempTransaction ta     
 inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and       
 ta.TransactionType=tr.[TransactionType]  and     
 isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getdate()) and    
 ta.TranDate=tr.TransactionDate and    
 ta.ServcerMasterID=tr.ServcerMasterID    
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
    ttr.ServcerMasterID,     
    ttr.RemitDate,  
    ttr.TransactionType,  
    ttr.DueDate,  
    isnull(ttr.ServicingAmount,0) as ServicingAmount,  
    tr.posteddate    
  from #TempTransaction ttr   
  inner join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID and   
  ttr.TransactionType=tr.[TransactionType]  and   
  ttr.RemitDate=tr.RemittanceDate and  
  ttr.TranDate=tr.TransactionDate and  
  ttr.ServcerMasterID=tr.ServcerMasterID   
  where tr.posteddate is null and tr.deleted=0 and  ttr.ReconFlag = 'ScheduledPrincipalPaid'  
  
  ----Need to change  
 ) a  
 where a.Transcationid=cre.TranscationReconciliation.Transcationid  
 --================Update Excisting Data=====================  
  
  
 Update #TempTransaction SET #TempTransaction.M61Amount = z.M61Amount,  
 #TempTransaction.M61PayDowns = z.M61PayDowns,  
 #TempTransaction.M61SchePrinPlusPaydowns = z.M61SchePrinPlusPaydowns  ,
  #TempTransaction.DueDate = z.DueDate,

#TempTransaction.PikPrinPaid = z.PikPrinPaid, 
#TempTransaction.PikPrinPaidPlusPaydowns = z.PikPrinPaidPlusPaydowns, 
#TempTransaction.PikPrinPaidPlusSchePrin = z.PikPrinPaidPlusSchePrin, 
#TempTransaction.PikPrinPaidSchePrinPlusPaydowns = z.PikPrinPaidSchePrinPlusPaydowns 

 From(  
  SELECT    
  ttr.LandingID,  
 -- ttr.DealID,  
  ttr.NoteID,     
  ttr.ServcerMasterID as ServcerMasterID,     
  ttr.RemitDate,  
  ttr.TransactionType,  
  
  --ttr.DueDate,   
  ISNULL(aa.MinDueDate,ttr.RemitDate) as DueDate,
  
  ttr.TranDate,   
  isnull(ttr.ServicingAmount,0)  as ServicingAmount ,   
  ISNULL(aa.amount,0) M61Amount,  
  ISNULL(FF.amount,0) M61PayDowns,  
  (ISNULL(aa.amount,0) + ISNULL(FF.amount,0)) as M61SchePrinPlusPaydowns ,
  
     iSNULL(tblpikpripaid.amount,0) as PikPrinPaid,
  (iSNULL(tblpikpripaid.amount,0) + ISNULL(FF.amount,0)) as PikPrinPaidPlusPaydowns,
  (iSNULL(tblpikpripaid.amount,0) +  ISNULL(aa.amount,0)) as PikPrinPaidPlusSchePrin,
  (ISNULL(aa.amount,0) + ISNULL(FF.amount,0) + iSNULL(tblpikpripaid.amount,0)) as PikPrinPaidSchePrinPlusPaydowns  
   
  from #TempTransaction ttr   
   left join   #TempRemitDate_sp trd on trd.noteid=ttr.noteid and trd.type=ttr.TransactionType and  trd.RemitDate=ttr.RemitDate 
  OUTER APPLY   
  (  
   Select min(t.Date) as MinDueDate,sum(amount) as amount  from #TempTransactionEntry_SP t  
   where t.noteid = ttr.NoteID and t.Date between DATEADD(day,1,EOMONTH(DATEADD(month,-1,trd.RemitDate))) and EOMONTH(trd.RemitDate) 
   --and t.type=ttr.TransactionType  
   and t.[Type] = 'ScheduledPrincipalPaid'

    --between trd.StartDate_10daybef and trd.StartDate_10dayafter
   ---trd.RemitDate  
   --dateadd(d,-5, ttr.RemitDate) and  dateadd(d,7, ttr.RemitDate) 
  )aa  
   OUTER APPLY   
  (  
   Select sum(amount) as amount   from #TempTransactionEntry_SP t  
   where t.noteid = ttr.NoteID 
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
    and n.NoteID = ttr.NoteID  
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
  
    and fs.Date between trd.StartDate_4daybef and trd.RemitDate    ---dateadd(d,-4, ttr.RemitDate) and  ttr.RemitDate 
   and n.noteid = ttr.NoteID  
   group by  n.noteid  
  )FF  
  where ttr.ReconFlag = 'ScheduledPrincipalPaid'  
 )z  
 where #TempTransaction.LandingID = z.LandingID and #TempTransaction.ReconFlag = 'ScheduledPrincipalPaid'  
  

   Update #TempTransaction SET SchePrin_Flag = 'SP_Matched'  
 where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(M61Amount,2)  

 --------------------------------------
 Update #TempTransaction SET SchePrin_Flag = 'SP_Ignore_Paydowns'  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(ServicingAmount,2) = ROUND(M61PayDowns,2)  
 
Update #TempTransaction SET SchePrin_Flag = 'SP_Ignore_PikPrinPaid'  
where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
and ROUND(ServicingAmount,2) = ROUND(PikPrinPaid,2) 
 
Update #TempTransaction SET SchePrin_Flag = 'SP_Ignore_Paydowns'    ---'SP_Ignore_Paydowns_PikPrinPaid'  
where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
and ROUND(ServicingAmount,2) = ROUND(PikPrinPaidPlusPaydowns,2) 
--------------------------------------
  
 Update #TempTransaction SET SchePrin_Flag = 'SP_has_SchePrinPlusPaydowns',ServicingAmount = M61Amount  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(ServicingAmount,2) = ROUND(M61SchePrinPlusPaydowns ,2) 

  Update #TempTransaction SET SchePrin_Flag = 'SP_has_SchePrinPlusPikPrinPaid',ServicingAmount = M61Amount  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(ServicingAmount,2) = ROUND(PikPrinPaidPlusSchePrin ,2) 

 Update #TempTransaction SET SchePrin_Flag = 'SP_has_SchePrinPlusPaydownsplusPikPrinPaid',ServicingAmount = M61Amount  
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 and ROUND(ServicingAmount,2) = ROUND(PikPrinPaidSchePrinPlusPaydowns ,2) 
  
 Update #TempTransaction SET SchePrin_Flag = 'SP_KeepAsItIs'  ---,ServicingAmount = ISNULL(M61Amount,0) ---(CASE WHEN ISNULL(M61Amount,0) = 0 THEN ServicingAmount ELSE M61Amount END)    
 where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
 


 --new
 Update ta set ta.Status='Ignore Paydowns'       
from cre.TransactionAuditLog ta     
INNER join #TempTransaction tr on ta.NoteID=tr.NoteID and          
ta.TransactionType=tr.[TransactionType]  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemitDate,getdate()) and    
ta.TransactionDate=tr.TranDate and    
ta.ServicerMasterID=tr.ServcerMasterID     
where    
 ta.Batchlogid =@Batchlogid    
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')    
and ta.TransactionType in ('ScheduledPrincipalPaid')    
and ta.ReconFlag = 'ScheduledPrincipalPaid'  
and tr.SchePrin_Flag = 'SP_Ignore_Paydowns' 


 Update ta set ta.Status='Ignore Pik Principal Paid'       
from cre.TransactionAuditLog ta     
INNER join #TempTransaction tr on ta.NoteID=tr.NoteID and          
ta.TransactionType=tr.[TransactionType]  and     
isnull(ta.RemitDate,getdate())=isnull(tr.RemitDate,getdate()) and    
ta.TransactionDate=tr.TranDate and    
ta.ServicerMasterID=tr.ServcerMasterID     
where    
 ta.Batchlogid =@Batchlogid    
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')    
and ta.TransactionType in ('ScheduledPrincipalPaid')    
and ta.ReconFlag = 'ScheduledPrincipalPaid'  
and tr.SchePrin_Flag = 'SP_Ignore_PikPrinPaid' 

-- Update ta set ta.Status='Ignore Paydowns Plus Pik Principal Paid'       
--from cre.TransactionAuditLog ta     
--INNER join #TempTransaction tr on ta.NoteID=tr.NoteID and          
--ta.TransactionType=tr.[TransactionType]  and     
--isnull(ta.RemitDate,getdate())=isnull(tr.RemitDate,getdate()) and    
--ta.TransactionDate=tr.TranDate and    
--ta.ServicerMasterID=tr.ServcerMasterID     
--where    
-- ta.Batchlogid =@Batchlogid    
--and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record')    
--and ta.TransactionType in ('ScheduledPrincipalPaid')    
--and ta.ReconFlag = 'ScheduledPrincipalPaid'  
--and tr.SchePrin_Flag = 'SP_Ignore_Paydowns_PikPrinPaid'
 
 -----================Insert New data================  
 INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,BerAddlint)    
 SELECT    
 d.DealID,  
 n.NoteID,     
 ttr.ServcerMasterID as ServcerMasterID,     
 ttr.RemitDate,  
 ttr.TransactionType,  
 ttr.DueDate,   
 isnull(ttr.ServicingAmount,0)  as ServicingAmount ,  
 isnull(ttr.M61Amount,0) as CalculatedAmount,   
 round(isnull(ttr.ServicingAmount,0)-isnull(ttr.M61Amount,0),2) as Delta,  
 TranDate,      
 @uploadedby as createdby,  
 GETDATE() as createdDate,  
 @uploadedby as updatedby,  
 GETDATE() as UpdatedDate,  
 @Batchlogid ,  
 ttr.Exception,  
 ttr.CapitalizedInterest,  
 null ,  
 0 as Adjustment,  
 isnull(ttr.ServicingAmount,0) -isnull(ttr.M61Amount,0) as ActualDelta,  
 ttr.BerAddlint  
 from #TempTransaction ttr   
 left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND ttr.TransactionType=tr.[TransactionType]  and ttr.RemitDate=tr.RemittanceDate and ttr.TranDate=tr.TransactionDate and ttr.ServcerMasterID=tr.ServcerMasterID   
 left join cre.note n on n.NoteID=ttr.NoteID   
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
 ta.NoteID=ttr.NoteID   
 and ttr.TransactionType=ta.TransactionType   
 and ttr.RemitDate=ta.RemitDate   
 and ttr.TranDate=ta.TransactionDate   
 and ttr.ServcerMasterID=ta.ServicerMasterID  
 and ttr.ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag not in ( 'SP_Ignore_Paydowns'  ,'SP_Ignore_PikPrinPaid' ) ---,'SP_Ignore_Paydowns_PikPrinPaid')
 ---================Insert New data================  
  
  
END  
---END Fee ScheduledPrincipalPaid---------------------------------  
    
    
    --new
--select @ignoredrows=count(TransactionAuditLogID) from CRE.TransactionAuditLog where status in ('Note does not exist.','Data already Reconcilled.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Ignore Paydowns') and BatchLogID=@Batchlogid     
    
    
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
--BEgin    
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
 and [Status] in ('Note does not exist.','Data already Reconcilled.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Ignore Paydowns',  'Ignore Pik Principal Paid' ) ----,'Ignore Paydowns Plus Pik Principal Paid' )
 group by TransactionType,BatchLogID

 )aa
 group by TransactionType

 
---------------------------------END Total records imported--------------------------------
    
--Delete from IO.L_Berkadia    
    
END    
  
  