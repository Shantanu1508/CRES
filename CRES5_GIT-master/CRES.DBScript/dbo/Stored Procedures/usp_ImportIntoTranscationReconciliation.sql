CREATE PROCEDURE [dbo].[usp_ImportIntoTranscationReconciliation]     
(    
 @Batchlogid int,    
 @ScenarioId varchar(100)    
 )    
AS    
BEGIN    
    
 Declare @SchedulePrincipalLogic_New bit =   1;
 
--Update Exception in landing table    
--Update IO.[L_Remittance] set IO.[L_Remittance].Exception = 'Exception'    
--From(    
-- Select LandingID,noteid,Sum_Value From(    
-- Select LandingID,noteid,Principal,Interest,ExitFees,ExtensionFees,PrepaymentYMFees,OtherFees,AddlPrincipal,AddlInt,TotalRemit ,    
--  Round((ISNULL(Principal,0) + ISNULL(Interest,0) - ISNULL(ServiceFee,0)  + ISNULL(ExitFees,0) + ISNULL(ExtensionFees,0) + ISNULL(PrepaymentYMFees,0) + ISNULL(OtherFees,0) + ISNULL(AddlPrincipal,0) + ISNULL(InterestAdj,0)  + ISNULL(AddlInt,0) ),2)  -Round( ISNULL(TotalRemit,0),2 ) as Sum_Value    
-- from IO.[L_Remittance]    
-- )a    
-- Where a.Sum_Value <> 0    
--)b    
--Where b.LandingID = IO.[L_Remittance].LandingID 


Update IO.[L_Remittance] set IO.[L_Remittance].Exception = 'Exception'    
From(    
 Select LandingID,noteid,Sum_Value From(    
 Select LandingID,noteid,OtherPrincipalAdjustments,NetInterest,ExitFees,ExtensionFees,PrepaymentYMFees,OtherFees,AddlInt,AddlPrincipal ,Principal ,TotalRemit , Interest,ScheduledInterestAmount,
  Round((ISNULL(OtherPrincipalAdjustments,0) + (CASE WHEN ISNULL(Interest,0) = 0 THEN 0 ELSE ISNULL(NetInterest,0) END) + ISNULL(ExitFees,0) + ISNULL(ExtensionFees,0) + ISNULL(PrepaymentYMFees,0) + ISNULL(OtherFees,0) + ISNULL(AddlPrincipal,0)  + ISNULL(AddlInt,0)+ ISNULL(Principal,0) ),2)  -Round( ISNULL(TotalRemit,0),2 )  as Sum_Value    
 from IO.[L_Remittance]    
 )a    
 Where a.Sum_Value <> 0    
)b    
Where b.LandingID = IO.[L_Remittance].LandingID


   
--Update IO.[L_Remittance] set IO.[L_Remittance].ExceptionFee = 'Exception'    
--From(    
-- Select LandingID,noteid,Sum_Value From(    
-- Select LandingID,noteid,Principal,Interest,ExitFees,ExtensionFees,PrepaymentYMFees,OtherFees,AddlPrincipal,AddlInt,TotalRemit ,    
--  Round((ISNULL(Principal,0) + ISNULL(Interest,0) - ISNULL(ServiceFee,0)  + ISNULL(ExitFees,0) + ISNULL(ExtensionFees,0) + ISNULL(PrepaymentYMFees,0) + ISNULL(OtherFees,0) + ISNULL(AddlPrincipal,0) + 0  + 0),2)  -Round( ISNULL(TotalRemit,0),2 ) as Sum_Value    
-- from IO.[L_Remittance]    
-- )a    
-- Where a.Sum_Value <> 0    
--)b    
--Where b.LandingID = IO.[L_Remittance].LandingID 
    
IF OBJECT_ID('tempdb..#TempTransaction') IS NOT NULL                                             
 DROP TABLE #TempTransaction      
    
CREATE TABLE #TempTransaction(    
LandingID uniqueidentifier,    
DealId uniqueidentifier,    
NoteID uniqueidentifier,      
TransactionType nvarchar(250),    
Transcationtypeid int,      
ServicingAmount decimal(28,15),    
DueDate Datetime,    
RemitDate Datetime,    
ServcerMasterID int,    
TotalRemit decimal(28,15),    
TranDate Datetime,    
AddlInterest decimal(28,15),    
InterestAdj decimal(28,15),     
Exception nvarchar(256),    
ShouldDelete int null,    
ReconFlag nvarchar(50),    
    
M61Amount decimal(28,15),    
M61PayDowns decimal(28,15),    
--M61SchePrinPlusPaydowns decimal(28,15),    

--PikPrinPaid decimal(28,15), 
--PikPrinPaidPlusPaydowns decimal(28,15), 
--PikPrinPaidPlusSchePrin decimal(28,15), 
--PikPrinPaidSchePrinPlusPaydowns decimal(28,15),
PikPrinPaid decimal(28,15),
SP_PIKPP_Pydn decimal(28,15),
SP_PIKPP      decimal(28,15),
SP_Pydn       decimal(28,15),
PIKPP_Pydn    decimal(28,15),

SchePrin_Flag nvarchar(50) ,
SchePrin_PIKPP_PayDown_Flag nvarchar(50) ,
TransactionType_SP nvarchar(250),  
SP_RowNo int,
--ExceptionFee  nvarchar(256) 

PIK_DueDate Date,
FF_DueDate Date,

BalloonAmount decimal(28,15),
Balloon_DueDate Date,

AccountID uniqueidentifier  ,
CRENoteID  nvarchar(256) 
)    


DECLARE @uploadedby varchar(250)    
DECLARE @ignoredrows int,@TotalRowsCount int,@rowsinTrans int,@successmsg varchar(250)    
  
    
--INSERT INTO #TempTransaction(LandingID,NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,Exception,InterestAdj,ShouldDelete,AccountID  )      
--SELECT LandingID,n.noteid,TrType, (Select LookupID from core.lookup where parentid=39 and [Name] = TrType) as TrTypeLokkupId,Ser_Amount as ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInt,Exception,InterestAdj ,0 as ShouldDelete  ,n.Account_AccountID   
--FROM     
--(    
-- Select LandingID, NoteID,DueDate,CAST((ISNULL(Principal,0) + ISNULL(ADDlPrincipal,0)) as decimal(28,15)) as [ScheduledPrincipalPaid],Interest as [InterestPaid],RemitDate,(SELECT ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid) as ServcerMasterID,ExitFees,TotalRemit,TranDate,AddlInt,
--  Exception,InterestAdj,ExitFees as ExitFee,ExtensionFees as ExtensionFee,PrepaymentYMFees as PrepaymentFee,OtherFees as UnusedFee 
-- from IO.L_Remittance     
-- where FileBatchlogid=@Batchlogid --and isnull(TotalRemit,0)>0      
--) P    
--UNPIVOT    
--(    
-- Ser_Amount FOR TrType IN ([InterestPaid],[ExitFee],[ExtensionFee],[PrepaymentFee],[UnusedFee],[ScheduledPrincipalPaid])    
--)    
--AS unpvt 
--inner join cre.Note n on n.crenoteid=unpvt.NoteID  
--inner join core.account acc on acc.accountid = n.Account_accountid
--where acc.isdeleted <> 1   



INSERT INTO #TempTransaction(LandingID,NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,Exception,InterestAdj,ShouldDelete,AccountID  )      
SELECT LandingID,n.noteid,TrType,(Select LookupID from core.lookup where parentid=39 and [Name] = TrType) as TrTypeLokkupId,Ser_Amount as ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInt,Exception,null as InterestAdj ,0 as ShouldDelete  ,n.Account_AccountID   
FROM     
(    
 Select LandingID, NoteID,DueDate,

 (CASE WHEN @SchedulePrincipalLogic_New = 1 THEN CAST(ISNULL(Principal,0) as decimal(28,15)) 
 ELSE CAST((ISNULL(Principal,0) + ISNULL(ADDlPrincipal,0) + ISNULL(OtherPrincipalAdjustments,0) ) as decimal(28,15)) 
 END) as [ScheduledPrincipalPaid]

 ,(CASE WHEN @SchedulePrincipalLogic_New = 1 THEN CAST(ISNULL(ADDlPrincipal,0) as decimal(28,15)) 
 ELSE 0
 END) as [FundingOrRepayment]

 ,(CASE WHEN @SchedulePrincipalLogic_New = 1 THEN CAST(ISNULL(OtherPrincipalAdjustments,0) as decimal(28,15)) 
 ELSE 0
 END) as [PIKPrincipalPaid]
 
 ,Interest as [InterestPaid],RemitDate,(SELECT ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid) as ServcerMasterID,ExitFees,TotalRemit,TranDate,AddlInt,
  Exception,null as InterestAdj,ExitFees as ExitFee,ExtensionFees as ExtensionFee,PrepaymentYMFees as PrepaymentFeeExcludedFromLevelYield,OtherFees as UnusedFeeExcludedFromLevelYield 
 from IO.L_Remittance     
 where FileBatchlogid=@Batchlogid --and isnull(TotalRemit,0)>0      
) P    
UNPIVOT    
(    
 Ser_Amount FOR TrType IN ([InterestPaid],[ExitFee],[ExtensionFee],PrepaymentFeeExcludedFromLevelYield,[UnusedFeeExcludedFromLevelYield],[ScheduledPrincipalPaid],[FundingOrRepayment],[PIKPrincipalPaid])    
)    
AS unpvt 
inner join cre.Note n on n.crenoteid=unpvt.NoteID  
inner join core.account acc on acc.accountid = n.Account_accountid
where acc.isdeleted <> 1  


---========================Note does not exists===============


INSERT INTO #TempTransaction(LandingID,CRENoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,Exception,InterestAdj,ShouldDelete,AccountID  )      
SELECT LandingID,unpvt.noteid,TrType, (Select LookupID from core.lookup where parentid=39 and [Name] = TrType) as TrTypeLokkupId,Ser_Amount as ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInt,Exception,null as InterestAdj ,0 as ShouldDelete  ,n.Account_AccountID   
FROM     
(    
 Select LandingID, NoteID,DueDate,

 (CASE WHEN @SchedulePrincipalLogic_New = 1 THEN CAST(ISNULL(Principal,0) as decimal(28,15)) 
 ELSE CAST((ISNULL(Principal,0) + ISNULL(ADDlPrincipal,0) + ISNULL(OtherPrincipalAdjustments,0) ) as decimal(28,15)) 
 END) as [ScheduledPrincipalPaid]

 ,(CASE WHEN @SchedulePrincipalLogic_New = 1 THEN CAST(ISNULL(ADDlPrincipal,0) as decimal(28,15)) 
 ELSE 0
 END) as [FundingOrRepayment]

 ,(CASE WHEN @SchedulePrincipalLogic_New = 1 THEN CAST(ISNULL(OtherPrincipalAdjustments,0) as decimal(28,15)) 
 ELSE 0
 END) as [PIKPrincipalPaid]
 
 ,Interest as [InterestPaid],RemitDate,(SELECT ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid) as ServcerMasterID,ExitFees,TotalRemit,TranDate,AddlInt,
  Exception,null as InterestAdj,ExitFees as ExitFee,ExtensionFees as ExtensionFee,PrepaymentYMFees as PrepaymentFeeExcludedFromLevelYield,OtherFees as UnusedFeeExcludedFromLevelYield 
 from IO.L_Remittance     
 where FileBatchlogid=@Batchlogid --and isnull(TotalRemit,0)>0      
) P    
UNPIVOT    
(    
 Ser_Amount FOR TrType IN ([InterestPaid],[ExitFee],[ExtensionFee],PrepaymentFeeExcludedFromLevelYield,[UnusedFeeExcludedFromLevelYield],[ScheduledPrincipalPaid],[FundingOrRepayment],[PIKPrincipalPaid])    
)    
AS unpvt 
left join cre.Note n on n.crenoteid=unpvt.NoteID  
left join core.account acc on acc.accountid = n.Account_accountid
where n.noteid is null
and Ser_Amount <> 0
---========================Note does not exists===============


--  --Hot fix for unused fee--  
	UPDATE #TempTransaction set AddlInterest =null , InterestAdj =null where TransactionType<>'InterestPaid'

--UPDATE #TempTransaction set Exception=ExceptionFee where TransactionType<>'InterestPaid' 
    
--	 --Hot fix for unused fee--  


IF(@SchedulePrincipalLogic_New = 1)
BEGIN
	update #TempTransaction set ReconFlag=case when TransactionType='InterestPaid' THEN 'InterestPaid' 
	WHEN TransactionType in ('ScheduledPrincipalPaid','FundingOrRepayment','PIKPrincipalPaid') THEN 'Fee' ELSE 'Fee' END    
END
ELSE
BEGIN
	update #TempTransaction set ReconFlag=case when TransactionType='InterestPaid' THEN 'InterestPaid' WHEN TransactionType in ('ScheduledPrincipalPaid','FundingOrRepayment','PIKPrincipalPaid') THEN 'ScheduledPrincipalPaid' ELSE 'Fee' END    
	
END

update #TempTransaction set ServicingAmount=isnull(ServicingAmount,0)+isnull(InterestAdj,0) where ReconFlag = 'InterestPaid'    
    


Delete from #TempTransaction where ReconFlag in ('ScheduledPrincipalPaid','Fee') and ISNULL(ServicingAmount,0) = 0    
    
Delete from #TempTransaction where ServicingAmount=0 or ShouldDelete = 1 


SELECT @uploadedby=CreatedBy FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid    
    
select @TotalRowsCount=count(NoteID) from #TempTransaction --WHERE TransactionType='InterestPaid'    
    
    
 --============================Delete Duplicate Records========================    
;WITH CTE AS(    
   SELECT NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,    
       RN = ROW_NUMBER()OVER(PARTITION BY NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID     
    order by NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID)    
   FROM #TempTransaction  where CRENoteID is  null  
)     
    
INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,TotalRemit,ServicerMasterID,TransactionDate)    
SELECT  @Batchlogid,ttr.NoteID,ttr.TransactionType,ttr.DueDate,ttr.RemitDate,isnull(ttr.ServicingAmount,0) as ServicingAmount,'Duplicate Record',ttr.TotalRemit,ttr.ServcerMasterID,ttr.TranDate         
FROM CTE ttr WHERE RN > 1     
    
;WITH Dupl AS(    
   SELECT NoteID,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,    
       RN = ROW_NUMBER()OVER(PARTITION BY NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID     
    order by NoteID,DueDate, TransactionType, RemitDate, TranDate, ServcerMasterID)    
   FROM #TempTransaction    where CRENoteID is  null  
)     
Delete from Dupl where RN>1    
--================================================================================    
    

-----Check PIKInterestPaid first then Interest Paid----

Update #TempTransaction set TransactionType = 'PIKInterestPaid' Where LandingID in (
    
    Select ta.LandingID
    from #TempTransaction ta
    Inner join(
        Select n.noteid,te.Date,te.Amount ,te.[Type]
        from cre.TransactionEntry te 
        Inner join cre.Note n on n.Account_AccountID = te.accountid
        inner join core.Account acc on acc.accountid = n.Account_AccountID
        where acc.IsDeleted <> 1 
        and te.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
        and te.[type]= 'PIKInterestPaid'
    )tr on tr.noteid = ta.NoteID and tr.Date = ta.DueDate and ta.TransactionType = 'InterestPaid'

    where ta.TransactionType = 'InterestPaid' 
    and ta.ServicingAmount = tr.Amount
)
and #TempTransaction.TransactionType = 'InterestPaid' 
----------------------------------------------------

    
---==========================Insert into TransactionAuditLog====================================    
INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,TotalRemit,ServicerMasterID,TransactionDate,ReconFlag)    
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
ttr.TranDate,  
ttr.ReconFlag       
from #TempTransaction ttr       
where ttr.CRENoteID is  null

------Does not exists in system
INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,CRENoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,TotalRemit,ServicerMasterID,TransactionDate,ReconFlag)    
Select @Batchlogid,
'00000000-0000-0000-0000-000000000000',
ttr.CRENoteID,     
ttr.TransactionType,     
ttr.DueDate,    
ttr.RemitDate,     
isnull(ttr.ServicingAmount,0) as ServicingAmount,    
'Note does not exist.',
ttr.TotalRemit,    
ttr.ServcerMasterID,     
ttr.TranDate,  
ttr.ReconFlag 
from #TempTransaction ttr 
 where ttr.CRENoteID is not null 


 Delete from #TempTransaction  where CRENoteID is not null 



Update cre.TransactionAuditLog SET [Status] = 'Due date is lower than accounting close date.' 
Where Batchlogid = @Batchlogid
and TransactionAuditLogID in (
	Select TransactionAuditLogID
	from cre.TransactionAuditLog ta
	Left Join (
		Select noteid,LastAccountingCloseDate from(
			Select 
			d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate	
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			Left join (
				Select dealid,CloseDate,updateddate
				from CORE.[Period]
				where isdeleted <> 1 and CloseDate is not null
			)p on d.dealid = p.dealid 
			Where d.IsDeleted <> 1
		)a
		where a.rno = 1
	)z on ta.noteid = z.NoteID
	where ta.Batchlogid = @Batchlogid
	and  ta.duedate <= LastAccountingCloseDate
)
    

Update ta set ta.Status='Note does not exist.'     
from cre.TransactionAuditLog ta     
inner join cre.Note n on ta.Noteid=n.noteid    
inner join IO.L_Remittance r on r.NoteID=n.CRENoteid     
inner Join core.account a on n.Account_AccountID=a.AccountID     
where (a.IsDeleted=1 or a.StatusID=2) and ta.Batchlogid = @Batchlogid     
    
    
Update ta set ta.Status='Note Enable M61 Calculations is N.'     
from cre.TransactionAuditLog ta     
inner join cre.Note n on ta.Noteid=n.noteid    
inner join IO.L_Remittance r on r.NoteID=n.CRENoteid     
where n.EnableM61Calculations=4 and ta.Batchlogid = @Batchlogid     
    
    
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
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
and ta.Reconflag='InterestPaid' 


Update ta set ta.Status='Due Data already Reconcilled.'       
from cre.TransactionAuditLog ta     
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and       
ISNULL(ta.DueDate,getdate())=ISNULL(tr.DateDue,getdate()) and     
ta.TransactionType=tr.[TransactionType]  and        
ta.ServicerMasterID=tr.ServcerMasterID    
where tr.posteddate is not null     
and ta.Batchlogid = @Batchlogid    
and tr.Ignore <> 1    
and ta.[Status] not in ('Data already Reconcilled.','Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
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
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
and ta.TransactionType in ('InterestPaid','PIKInterestPaid')  --newly added PIKInterestPaid  
and ta.ReconFlag='InterestPaid'      
    

Update ta set ta.Status='Zero Interest'       
from cre.TransactionAuditLog ta     
where ta.Batchlogid =@Batchlogid    
--and ta.ServicingAmount = 0    
and  (select sum(ServicingAmount) from  cre.TransactionAuditLog where Batchlogid =@Batchlogid)=0  
and TransactionType = 'InterestPaid'   
  
 Update ta set ta.Status='Due Date is not avaible' 
 from cre.TransactionAuditLog ta 
    where  ta.TransactionType in ('InterestPaid','PIKInterestPaid')  and    DueDate is null  --newly added PIKInterestPaid  
 and ta.Batchlogid =@Batchlogid 

    
Update cre.TranscationReconciliation SET cre.TranscationReconciliation.Deleted = 1    
From(    
 Select     
 tr.TranscationID    
 from cre.TranscationReconciliation tr    
 inner join cre.TransactionAuditLog ta on     
 ta.NoteID=tr.NoteID     
 and tr.DateDue=ta.DueDate     
 and tr.TransactionType=ta.TransactionType     
 and tr.RemittanceDate=ta.RemitDate     
 and tr.TransactionDate=ta.TransactionDate     
 and tr.ServcerMasterID=ta.ServicerMasterID    
 and PostedDate is null    
 where ta.BatchLogid = @Batchlogid and ta.status in ('Note does not exist.','Due Data already Reconcilled.' ,'Data already Reconcilled.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.' )     
and  ta.ReconFlag='InterestPaid'  
)a    
where cre.TranscationReconciliation.TranscationID = a.TranscationID    
    
    
Delete from #TempTransaction where ServicingAmount=0 or ShouldDelete = 1    
----=============================================================================    
    
    
    
    
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
 where tr.posteddate is null and tr.deleted=0 and ttr.ReconFlag='InterestPaid'    
) a    
where a.Transcationid=cre.TranscationReconciliation.Transcationid    
 --================Update Excisting Data=====================    
    
    
     
-----================Insert New data================    
INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,InterestAdj)    
SELECT      
d.DealID,    
n.NoteID,       
ttr.ServcerMasterID as ServcerMasterID,       
ttr.RemitDate,    
ttr.TransactionType,    
ttr.DueDate,     
isnull(ttr.ServicingAmount,0)  as ServicingAmount ,    
isnull(CREtr.Amount,0) as CalculatedAmount,    
--round((isnull(ttr.ServicingAmount,0)-isnull(CREtr.Amount,0)),2) as Delta,    
round(isnull(ttr.ServicingAmount,0)-isnull(CREtr.Amount,0),2) as Delta,    
TranDate,        
@uploadedby as createdby,    
GETDATE() as createdDate,    
@uploadedby as updatedby,    
GETDATE() as UpdatedDate,    
@Batchlogid ,    
ttr.Exception,    
ttr.AddlInterest,    
Round(isnull(ttr.ServicingAmount,0) + isnull(ttr.AddlInterest,0) ,2) ,    
0 as Adjustment,    
isnull(ttr.ServicingAmount,0)-isnull(CREtr.Amount,0) as ActualDelta,     
ttr.InterestAdj    
from #TempTransaction ttr     
left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND    
ttr.DueDate=tr.DateDue and     
ttr.TransactionType=tr.[TransactionType]  and     
ttr.RemitDate=tr.RemittanceDate and    
ttr.TranDate=tr.TransactionDate and    
ttr.ServcerMasterID=tr.ServcerMasterID     
left join [Cre].Transactionentry CREtr on ttr.AccountID=CREtr.AccountID and ttr.DueDate=CREtr.Date and ttr.TransactionType=CREtr.Type and AnalysisID=@ScenarioId and CREtr.[Type] in ('InterestPaid','PIKInterestPaid')--newly added PIKInterestPaid   
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
 where BatchLogid = @Batchlogid and status in ('Imported','Reimported','Due Data already Reconcilled.') and TransactionType in ( 'InterestPaid','PIKInterestPaid')--newly added PIKInterestPaid       
)ta on     
ta.NoteID=ttr.NoteID     
and ttr.DueDate=ta.DueDate     
and ttr.TransactionType=ta.TransactionType     
and ttr.RemitDate=ta.RemitDate     
and ttr.TranDate=ta.TransactionDate     
and ttr.ServcerMasterID=ta.ServicerMasterID     
and ttr.ReconFlag='InterestPaid'    
     


Update cre.TranscationReconciliation  SET cre.TranscationReconciliation.DueDateAlreadyReconciled = 1,cre.TranscationReconciliation.CalculatedAmount=0
Where transcationid in (

Select a.transcationid
from(
	Select transcationid ,NoteID,DateDue,[TransactionType],ServcerMasterID
	from cre.TranscationReconciliation 
	where posteddate is null and Batchlogid = @Batchlogid
	and Ignore <> 1  and [TransactionType] in ( 'InterestPaid','PIKInterestPaid')--newly added PIKInterestPaid  
)a     
inner join cre.TranscationReconciliation tr on tr.NoteID=a.NoteID and       
ISNULL(tr.DateDue,getdate())=ISNULL(a.DateDue,getdate()) and     
tr.TransactionType=a.[TransactionType]  and       
tr.ServcerMasterID=a.ServcerMasterID    
where tr.posteddate is not null 
and tr.Ignore <> 1    
and tr.TransactionType in ( 'InterestPaid','PIKInterestPaid')--newly added PIKInterestPaid  

)



    
    
----END Interest Paid---------------------------------    
    
    
---Start Fee Transaction---------------------------------    
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
ENDDate Date  ,
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
  
 Select LandingID,NoteId,TransactionType,RemitDate from #TempTransaction where ReconFlag = 'Fee'
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
 set @SevenDaysPrevious=(Select Date as enddate from @tblDateRange  where date < @RemitDate order by date desc OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY)  
 SET @TDate = (Select Date as enddate from @tblDateRange  where date > @RemitDate order by date OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)    
  
 insert into #TempRemitDate(Noteid,RemitDate,type ,StartDate ,ENDDate,SevenDaysPrevious)    
 Select @NoteId, @RemitDate,@TransactionType,@SDate,@TDate , @SevenDaysPrevious
        
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
 ,(case when type like '%exit%' Then 'ExitFee' when type like '%extension%' Then 'ExtensionFee' ELSE type END)    
 ,round(isnull(amount,0),2) as  amount    
 from cre.transactionentry tr  
 Inner Join cre.note n on n.account_accountid = tr.accountid 
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
 'UnusedFeeExcludedFromLevelYield',
 'AdditionalFeesExcludedFromLevelYield'
 )    
 and n.NOteid in (select distinct NoteID from #TempTransaction  where ReconFlag = 'Fee')  
 
IF(@SchedulePrincipalLogic_New = 1)
BEGIN
	INSERT INTO  #TempTransactionEntry(Noteid,Date,type,amount)    
	Select NOteid    
	,Date    
	,[type]  
	,round(isnull(amount,0),2) as  amount    
	from cre.transactionentry tr  
	Inner Join cre.note n on n.account_accountid = tr.accountid 
	where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     
	and type in ( 'ScheduledPrincipalPaid','FundingOrRepayment','PIKPrincipalPaid','Balloon')    
	and n.NOteid in (select distinct NoteID from #TempTransaction  where ReconFlag = 'Fee')  
END 
  
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
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
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
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
and ta.TransactionType not in ('InterestPaid','ScheduledPrincipalPaid')    
 and ta.ReconFlag = 'Fee'   

    
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
  where tr.posteddate is null and tr.deleted=0 and  ttr.ReconFlag = 'Fee'       
 ) a    
 where a.Transcationid=cre.TranscationReconciliation.Transcationid    
 --================Update Excisting Data=====================    
    
    
 -----================Insert New data================    
 INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,InterestAdj)    
	SELECT      
	d.dealid,    
	n.NoteID,       
	ttr.ServcerMasterID as ServcerMasterID,       
	ttr.RemitDate,    
	ttr.TransactionType,    
	isnull(aa.MinDueDate, ttr.RemitDate),     
	isnull(ttr.ServicingAmount,0)  as ServicingAmount ,    
	isnull(aa.amount,0) as CalculatedAmount,     
	round(isnull(ttr.ServicingAmount,0)-isnull(aa.amount,0),2) as Delta,    
	TranDate,        
	@uploadedby as createdby,    
	GETDATE() as createdDate,    
	@uploadedby as updatedby,   GETDATE() as UpdatedDate,    
	@Batchlogid ,    
	ttr.Exception,    
	ttr.AddlInterest,    
	null ,    
	0 as Adjustment,    
	isnull(ttr.ServicingAmount,0) -isnull(aa.amount,0) as ActualDelta,    
	ttr.InterestAdj    
 from #TempTransaction ttr     
 left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND         
 ttr.TransactionType=tr.[TransactionType]  and     
 ttr.RemitDate=tr.RemittanceDate and    
 ttr.TranDate=tr.TransactionDate and    
 ttr.ServcerMasterID=tr.ServcerMasterID     
    
 left join   #TempRemitDate trd on trd.noteid=ttr.noteid and trd.type=ttr.TransactionType and  trd.RemitDate=ttr.RemitDate
 OUTER APPLY     
 (  
	 Select sum(round(isnull(amount,0),2)) as amount,min(t.Date) as MinDueDate from #TempTransactionEntry t 
	 where t.noteid = trd.NoteID  and (t.Date >= trd.StartDate and t.Date <= ttr.RemitDate )      
	 and t.type=trd.type  
	 and t.Date not in (Select RelatedtoModeledPMTDate from cre.NoteTransactionDetail ntt left join cre.note n on n.NoteID=ntt.NoteID where ntt.TransactionTypeText like '%'+ttr.TransactionType+'%'  and ntt.NoteID=trd.NoteID and ntt.ServicerMasterID not in (3,5) )   
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
  from cre.TransactionAuditLog    
  where BatchLogid = @Batchlogid and status in ('Imported','Reimported')    
 )ta on     
 ta.NoteID=ttr.NoteID     
 and ttr.TransactionType=ta.TransactionType     
 and ttr.RemitDate=ta.RemitDate     
 and ttr.TranDate=ta.TransactionDate     
 and ttr.ServcerMasterID=ta.ServicerMasterID    
 and ttr.ReconFlag = 'Fee'  
 and   ttr.TransactionType in ('ExitFee','PrepaymentFeeExcludedFromLevelYield') ---'PrepaymentFee'

 ---'AdditionalFeesExcludedFromLevelYield'

INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,InterestAdj)    
Select DealId,NoteID,ServcerMasterID,RemittanceDate,
(CASE WHEN Has_AddlFee = 1 THEN 'AdditionalFeesExcludedFromLevelYield' ELSE TransactionType END) as TransactionType,
(CASE WHEN Has_AddlFee = 1 THEN isnull(AddlFee_MinDueDate, z.RemittanceDate) ELSE DateDue END) as DateDue,
ServicingAmount,
(CASE WHEN Has_AddlFee = 1 THEN AddlFee_Amount ELSE CalculatedAmount END) CalculatedAmount,
(CASE WHEN Has_AddlFee = 1 THEN round(isnull(z.ServicingAmount,0) - isnull(AddlFee_Amount,0),2) ELSE Delta END) Delta,
TransactionDate,
CreatedBy,
createdDate,
UpdatedBy,
UpdatedDate,
BatchLogID,
Exception,
AddlInterest,
TotalInterest,
Adjustment,
(CASE WHEN Has_AddlFee = 1 THEN isnull(z.ServicingAmount,0) -isnull(AddlFee_Amount,0) ELSE ActualDelta END) as ActualDelta,
InterestAdj
From(
	SELECT      
	d.dealid,    
	n.NoteID,       
	ttr.ServcerMasterID as ServcerMasterID,       
	ttr.RemitDate as RemittanceDate,    
	ttr.TransactionType,    
	isnull(aa.MinDueDate, ttr.RemitDate) as DateDue,     
	isnull(ttr.ServicingAmount,0)  as ServicingAmount ,    
	isnull(aa.amount,0) as CalculatedAmount,     
	round(isnull(ttr.ServicingAmount,0)-isnull(aa.amount,0),2) as Delta,    
	TranDate as TransactionDate,        
	@uploadedby as createdby,    
	GETDATE() as createdDate,    
	@uploadedby as updatedby,   
	GETDATE() as UpdatedDate,    
	@Batchlogid as BatchLogID,    
	ttr.Exception,    
	ttr.AddlInterest,    
	null as TotalInterest,    
	0 as Adjustment,    
	isnull(ttr.ServicingAmount,0) -isnull(aa.amount,0) as ActualDelta,    
	ttr.InterestAdj,
	(CASE WHEN (ttr.TransactionType = 'UnusedFeeExcludedFromLevelYield' and ttr.ServicingAmount = tblAddlFee.amount) THEN 1 ELSE 0 END) as Has_AddlFee,
	tblAddlFee.amount as AddlFee_Amount,
	tblAddlFee.MinDueDate as AddlFee_MinDueDate

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
		where t.noteid = trd.NoteID  and (t.Date >= trd.SevenDaysPrevious and t.Date <= trd.ENDDate)    
		and t.type=trd.type 
		--and t.Date not in (Select RelatedtoModeledPMTDate from cre.NoteTransactionDetail ntt left join cre.note n on n.NoteID=ntt.NoteID where ntt.TransactionTypeText like '%'+ttr.TransactionType+'%'  and ntt.NoteID=trd.NoteID )  
	)aa    
	OUTER APPLY     
	(  
		Select sum(round(isnull(amount,0),2)) as amount,min(t.Date) as MinDueDate 
		from #TempTransactionEntry t 
		where t.noteid = trd.NoteID  and (t.Date >= trd.StartDate and t.Date <= ttr.RemitDate )      ---t.Date = ttr.DueDate
		and t.type= 'AdditionalFeesExcludedFromLevelYield'	 
	)tblAddlFee
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
	and ttr.TransactionType in ('ExtensionFee','AdditionalFeesExcludedFromLevelYield','UnusedFeeExcludedFromLevelYield')
)z



IF(@SchedulePrincipalLogic_New = 1)
BEGIN
	
	INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,InterestAdj)    
	
	Select DealId,NoteID,ServcerMasterID,RemittanceDate,
	(CASE WHEN Has_Balloon = 1 THEN 'Balloon' ELSE TransactionType END) as TransactionType,
	(CASE WHEN Has_Balloon = 1 THEN isnull(Balloon_MinDueDate, z.RemittanceDate) ELSE DateDue END) as DateDue,
	ServicingAmount,
	(CASE WHEN Has_Balloon = 1 THEN Balloon_Amount ELSE CalculatedAmount END) CalculatedAmount,
	(CASE WHEN Has_Balloon = 1 THEN round(isnull(z.ServicingAmount,0) - isnull(Balloon_Amount,0),2) ELSE Delta END) Delta,

	TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,
	(CASE WHEN Has_Balloon = 1 THEN isnull(z.ServicingAmount,0) -isnull(Balloon_Amount,0) ELSE ActualDelta END) as ActualDelta,
	InterestAdj
	From(
		SELECT      
		d.dealid,    
		n.NoteID,       
		ttr.ServcerMasterID as ServcerMasterID,       
		ttr.RemitDate as RemittanceDate,
		ttr.TransactionType, 
		isnull(aa.MinDueDate, ttr.RemitDate) as DateDue,     
		isnull(ttr.ServicingAmount,0)  as ServicingAmount ,    
		isnull(aa.amount,0) as CalculatedAmount,     
		round(isnull(ttr.ServicingAmount,0)-isnull(aa.amount,0),2) as Delta,    
		TranDate as TransactionDate,        
		@uploadedby as createdby,    
		GETDATE() as createdDate,    
		@uploadedby as updatedby,   
		GETDATE() as UpdatedDate,    
		@Batchlogid as BatchLogID,    
		ttr.Exception,    
		ttr.AddlInterest,    
		null as TotalInterest,    
		0 as Adjustment,    
		isnull(ttr.ServicingAmount,0) -isnull(aa.amount,0) as ActualDelta,    
		ttr.InterestAdj  ,	
		(CASE WHEN (ttr.TransactionType = 'FundingOrRepayment' and ttr.ServicingAmount = tblBalloon.amount) THEN 1 ELSE 0 END) as Has_Balloon,
		tblBalloon.amount as Balloon_Amount,
		tblBalloon.MinDueDate as Balloon_MinDueDate

		from #TempTransaction ttr     
		left join cre.TranscationReconciliation tr on ttr.NoteID=tr.NoteID  and  tr.Deleted <> 1 AND tr.posteddate is null AND 
		ttr.TransactionType=tr.[TransactionType]  and     
		ttr.RemitDate=tr.RemittanceDate and    
		ttr.TranDate=tr.TransactionDate and    
		ttr.ServcerMasterID=tr.ServcerMasterID  
		left join   #TempRemitDate trd on trd.noteid=ttr.noteid and trd.type=ttr.TransactionType and  trd.RemitDate=ttr.RemitDate
		OUTER APPLY     
		(  
			Select sum(round(isnull(amount,0),2)) as amount,min(t.Date) as MinDueDate from #TempTransactionEntry t 
			where t.noteid = trd.NoteID  and (t.Date >= trd.StartDate and t.Date <= ttr.RemitDate )      
			and t.type=trd.type  
			----and t.Date not in (Select RelatedtoModeledPMTDate from cre.NoteTransactionDetail ntt left join cre.note n on n.NoteID=ntt.NoteID where ntt.TransactionTypeText like '%'+ttr.TransactionType+'%'  and ntt.NoteID=trd.NoteID )   
		)aa 
		OUTER APPLY     
		(  
			Select sum(round(isnull(amount,0),2)) as amount,min(t.Date) as MinDueDate 
			from #TempTransactionEntry t 
			where t.noteid = trd.NoteID  and (t.Date >= trd.StartDate and t.Date <= ttr.RemitDate )      ---t.Date = ttr.DueDate
			and t.type= 'Balloon'	 
		)tblBalloon  
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
			where BatchLogid = @Batchlogid and status in ('Imported','Reimported')    
		)ta on     
		ta.NoteID=ttr.NoteID     
		and ttr.TransactionType=ta.TransactionType     
		and ttr.RemitDate=ta.RemitDate     
		and ttr.TranDate=ta.TransactionDate     
		and ttr.ServcerMasterID=ta.ServicerMasterID    
		and ttr.ReconFlag = 'Fee'  
		and ttr.TransactionType in ('ScheduledPrincipalPaid','FundingOrRepayment','PIKPrincipalPaid')   
	)z


	 

END

 ---================Insert New data================    
    
    
END    
---END Fee Transaction---------------------------------    
    
    
  
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
SevenDaysPrevious Date ,
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
 from cre.transactionentry   tr
 Inner Join cre.note n on n.account_accountid = tr.accountid 
 where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
 and type in ( 'ScheduledPrincipalPaid'  ,'PIKPrincipalPaid','Balloon')
 and n.NOteid in (select distinct NoteID from #TempTransaction  where ReconFlag = 'ScheduledPrincipalPaid')  
  
  


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
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
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
and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')    
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
  ttr.TransactionType= Replace(Replace(Replace(tr.[TransactionType],'PIKPrincipalPaid','ScheduledPrincipalPaid'),'FundingOrRepayment','ScheduledPrincipalPaid'),'Balloon','ScheduledPrincipalPaid')  and   
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
--#TempTransaction.M61SchePrinPlusPaydowns = z.M61SchePrinPlusPaydowns ,
#TempTransaction.DueDate = z.DueDate , 

#TempTransaction.PikPrinPaid = z.PikPrinPaid,
#TempTransaction.SP_PIKPP_Pydn = z.SP_PIKPP_Pydn, 
#TempTransaction.SP_PIKPP = z.SP_PIKPP, 
#TempTransaction.SP_Pydn = z.SP_Pydn, 
#TempTransaction.PIKPP_Pydn = z.PIKPP_Pydn ,

#TempTransaction.PIK_DueDate = z.PIK_DueDate ,
#TempTransaction.FF_DueDate = z.FF_DueDate ,

#TempTransaction.BalloonAmount = z.BalloonAmount,
#TempTransaction.Balloon_DueDate = z.Balloon_DueDate



 From(  
	SELECT    
	ttr.LandingID,  
	ttr.DealID,  
	ttr.NoteID,     
	ttr.ServcerMasterID as ServcerMasterID,     
	ttr.RemitDate,  
	ttr.TransactionType,   
	--ttr.DueDate,   
	iSNULL(sp.MinDueDate,ttr.RemitDate) as DueDate,

	ttr.TranDate,   
	isnull(ttr.ServicingAmount,0)  as ServicingAmount ,   
	ISNULL(sp.amount,0) M61Amount,  
	ISNULL(FF.amount,0) M61PayDowns,  
	iSNULL(tblpikpripaid.amount,0) as PikPrinPaid,

	(ISNULL(sp.amount,0) + ISNULL(FF.amount,0) + iSNULL(tblpikpripaid.amount,0)) as SP_PIKPP_Pydn ,
	(ISNULL(sp.amount,0) + iSNULL(tblpikpripaid.amount,0)) as SP_PIKPP,
	(ISNULL(sp.amount,0) + iSNULL(FF.amount,0)) as SP_Pydn, 
	(ISNULL(tblpikpripaid.amount,0) + iSNULL(FF.amount,0)) as PIKPP_Pydn,

	ISNULL(tblpikpripaid.MinDueDate,ttr.RemitDate) as PIK_DueDate,
	ISNULL(FF.MinDueDate,ttr.RemitDate) as FF_DueDate,
	
	ISNULL(tblballoon.amount,0) as BalloonAmount,
	ISNULL(tblballoon.MinDueDate,ttr.RemitDate) as Balloon_DueDate


  from #TempTransaction ttr  
  left join   #TempRemitDate_sp trd on trd.noteid=ttr.noteid and trd.type=ttr.TransactionType and  trd.RemitDate=ttr.RemitDate 
  OUTER APPLY   
  (  
   Select min(t.Date) as MinDueDate,sum(amount) as amount   
   from #TempTransactionEntry_SP t  
   where t.noteid = ttr.NoteID and t.Date between DATEADD(day,1,EOMONTH(DATEADD(month,-1,trd.RemitDate))) and EOMONTH(trd.RemitDate)
   --and t.type=ttr.TransactionType  
   and t.[Type] = 'ScheduledPrincipalPaid'


  )sp  
   OUTER APPLY   
  (  
   Select min(t.Date) as MinDueDate,sum(amount) as amount   from #TempTransactionEntry_SP t  
   where t.noteid = ttr.NoteID 
   and t.Date between trd.StartDate_5daybef and trd.RemitDate  --dateadd(d,-5, ttr.RemitDate) and  dateadd(d,7, ttr.RemitDate)  
   --and t.type=ttr.TransactionType  
   and t.[Type] = 'PIKPrincipalPaid'
  )tblpikpripaid 
  Outer Apply(  
   Select n.noteid,min(fs.Date) as MinDueDate,ABS(SUM(fs.value)) as amount  
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
  
   and fs.Date between trd.StartDate_5daybef and trd.RemitDate    ---dateadd(d,-4, ttr.RemitDate) and  ttr.RemitDate  
   and n.noteid = ttr.NoteID  
   group by  n.noteid  
  )FF  

	OUTER APPLY   
	(  
		Select min(t.Date) as MinDueDate,sum(amount) as amount   
		from #TempTransactionEntry_SP t  
		where t.noteid = ttr.NoteID 
		and t.Date = ttr.DueDate
		and t.[Type] = 'Balloon'
	)tblballoon 

  where ttr.ReconFlag = 'ScheduledPrincipalPaid'  
 )z  
 where #TempTransaction.LandingID = z.LandingID and #TempTransaction.ReconFlag = 'ScheduledPrincipalPaid'  
  

 
------------------------------New Logic-by Order SP,PIKPP,PyDn----------------------
Update #TempTransaction SET SchePrin_Flag = 'SP_Matched_Balloon'  ,SchePrin_PIKPP_PayDown_Flag = 'SP_Balloon',TransactionType_SP ='Balloon' ,M61Amount = BalloonAmount
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(BalloonAmount,2)  



Update #TempTransaction SET SchePrin_Flag = 'SP_Matched'  ,SchePrin_PIKPP_PayDown_Flag = 'SP',TransactionType_SP ='ScheduledPrincipalPaid'
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(M61Amount,2)   and SchePrin_Flag is null ----latest change

Update #TempTransaction SET SchePrin_Flag = 'PIKPP_Matched' ,SchePrin_PIKPP_PayDown_Flag = 'PIKPP',TransactionType_SP ='PIKPrincipalPaid',M61Amount = PikPrinPaid,DueDate = PIK_DueDate
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(PikPrinPaid,2) and SchePrin_Flag is null

Update #TempTransaction SET SchePrin_Flag = 'Pydn_Matched',SchePrin_PIKPP_PayDown_Flag = 'PyDn',TransactionType_SP ='FundingOrRepayment',M61Amount = M61PayDowns,DueDate = FF_DueDate
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(M61PayDowns,2) and SchePrin_Flag is null


--SP+PIKPP+PyDn
Update #TempTransaction SET SchePrin_Flag = 'SP_PIKPP_Pydn_Matched',SchePrin_PIKPP_PayDown_Flag = 'SP_PIKPP_Pydn',TransactionType_SP ='ScheduledPrincipalPaid',ServicingAmount = M61Amount
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(SP_PIKPP_Pydn,2) and SchePrin_Flag is null
and (M61Amount <> 0 and PikPrinPaid <> 0 and M61PayDowns <> 0)

INSERT INTO #TempTransaction(LandingID,DealId,NoteID,TransactionType_SP,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag)
Select LandingID,DealId,NoteID,'PIKPrincipalPaid' as TransactionType_SP, TransactionType,Transcationtypeid,PikPrinPaid as ServicingAmount,PIK_DueDate as DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,PikPrinPaid as M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag
from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_PIKPP_PayDown_Flag = 'SP_PIKPP_Pydn' 

INSERT INTO #TempTransaction(LandingID,DealId,NoteID,TransactionType_SP,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag)
Select LandingID,DealId,NoteID,'FundingOrRepayment' as TransactionType_SP, TransactionType,Transcationtypeid,M61PayDowns as ServicingAmount,FF_DueDate as DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61PayDowns as M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag
from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_PIKPP_PayDown_Flag = 'SP_PIKPP_Pydn' 


--SP+PIKPP
Update #TempTransaction SET SchePrin_Flag = 'SP_PIKPP_Matched',SchePrin_PIKPP_PayDown_Flag = 'SP_PIKPP',TransactionType_SP ='ScheduledPrincipalPaid',ServicingAmount = M61Amount
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(SP_PIKPP,2) and SchePrin_Flag is null

INSERT INTO #TempTransaction(LandingID,DealId,NoteID,TransactionType_SP,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag)
Select LandingID,DealId,NoteID,'PIKPrincipalPaid' as TransactionType_SP,TransactionType,Transcationtypeid,PikPrinPaid as ServicingAmount,PIK_DueDate as DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,PikPrinPaid as M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag
from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_PIKPP_PayDown_Flag = 'SP_PIKPP' 


--SP+PyDN
Update #TempTransaction SET SchePrin_Flag = 'SP_Pydn_Matched',SchePrin_PIKPP_PayDown_Flag = 'SP_Pydn',TransactionType_SP ='ScheduledPrincipalPaid',ServicingAmount = M61Amount
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(SP_Pydn,2) and SchePrin_Flag is null

INSERT INTO #TempTransaction(LandingID,DealId,NoteID,TransactionType_SP,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag)
Select LandingID,DealId,NoteID,'FundingOrRepayment' as TransactionType_SP,TransactionType,Transcationtypeid,M61PayDowns as ServicingAmount,FF_DueDate as DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61PayDowns as M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag
from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_PIKPP_PayDown_Flag = 'SP_Pydn' 


--PIKPP+PyDN
Update #TempTransaction SET SchePrin_Flag = 'PIKPP_Pydn_Matched',SchePrin_PIKPP_PayDown_Flag = 'PIKPP_Pydn',TransactionType_SP ='PIKPrincipalPaid',ServicingAmount = PikPrinPaid,M61Amount = PikPrinPaid,DueDate = PIK_DueDate
where ReconFlag = 'ScheduledPrincipalPaid' and  ROUND(ServicingAmount,2) =  ROUND(PIKPP_Pydn,2) and SchePrin_Flag is null

INSERT INTO #TempTransaction(LandingID,DealId,NoteID,TransactionType_SP,TransactionType,Transcationtypeid,ServicingAmount,DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag)
Select LandingID,DealId,NoteID,'FundingOrRepayment' as TransactionType_SP, TransactionType,Transcationtypeid,M61PayDowns as ServicingAmount,FF_DueDate as DueDate,RemitDate,ServcerMasterID,TotalRemit,TranDate,AddlInterest,InterestAdj,Exception,ShouldDelete,ReconFlag,M61PayDowns as M61Amount,M61PayDowns,PikPrinPaid,SP_PIKPP_Pydn,SP_PIKPP,SP_Pydn,PIKPP_Pydn,SchePrin_Flag,SchePrin_PIKPP_PayDown_Flag
from #TempTransaction where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_PIKPP_PayDown_Flag = 'PIKPP_Pydn' 


Update #TempTransaction SET SchePrin_Flag = 'AsItIs',SchePrin_PIKPP_PayDown_Flag = 'AsItIs',TransactionType_SP ='ScheduledPrincipalPaid'  
where ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag is null  
  


 
 -----================Insert New data================  
 INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,RemittanceDate,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,Exception,AddlInterest,TotalInterest,Adjustment,ActualDelta,InterestAdj)  
 SELECT    
 d.DealID,  
 n.NoteID,     
 ttr.ServcerMasterID as ServcerMasterID,     
 ttr.RemitDate,  
 ----(CASE WHEN  ttr.DueDate = n.ActualPayoffDate and ttr.TransactionType_SP = 'FundingOrRepayment' THEN 'Balloon' ELSE ttr.TransactionType_SP END)  as TransactionType,  
 ttr.TransactionType_SP as TransactionType,  
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
 ttr.AddlInterest,  
 null,  
 0 as Adjustment,  
 isnull(ttr.ServicingAmount,0) -isnull(ttr.M61Amount,0) as ActualDelta,  
 ttr.InterestAdj  
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
 and ttr.ReconFlag = 'ScheduledPrincipalPaid' and SchePrin_Flag not in ( 'SP_Ignore' )  --'SP_Ignore_Paydowns'  ,'SP_Ignore_Paydowns_PikPrinPaid'
 ---================Insert New data================  




Update cre.TranscationReconciliation  SET cre.TranscationReconciliation.DueDateAlreadyReconciled = 1,cre.TranscationReconciliation.CalculatedAmount=0
Where transcationid in (

Select a.transcationid
from(
	Select transcationid ,NoteID,DateDue,[TransactionType],ServcerMasterID
	from cre.TranscationReconciliation 
	where posteddate is null and Batchlogid = @Batchlogid
	and Ignore <> 1  and [TransactionType] in ('ScheduledPrincipalPaid','PIKPrincipalPaid','FundingOrRepayment','Balloon') 
)a     
inner join cre.TranscationReconciliation tr on tr.NoteID=a.NoteID and       
ISNULL(tr.DateDue,getdate())=ISNULL(a.DateDue,getdate()) and     
tr.TransactionType=a.[TransactionType]  and       
tr.ServcerMasterID=a.ServcerMasterID    
where tr.posteddate is not null 
and tr.Ignore <> 1    
and tr.TransactionType in ('ScheduledPrincipalPaid','PIKPrincipalPaid','FundingOrRepayment','Balloon') 
)
  
  
END  
---END Fee ScheduledPrincipalPaid---------------------------------  
    
    


    
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


Select TransactionType,sum(totalrecords-ignored) Totalrecords,sum(ignored) as ignored,sum(DDAllRec) as DDAllRec, Notenotexist from (

	select  TransactionType,count(Status) totalrecords,0 as ignored,0 as DDAllRec,null as Notenotexist
	from CRE.TransactionAuditLog  where BatchLogID=@Batchlogid group by TransactionType,BatchLogID

	UNION ALL

	select  TransactionType,0,count(Status) as ignored,0 as DDAllRec,null as Notenotexist
	from CRE.TransactionAuditLog  where BatchLogID=@Batchlogid 
	and [Status] in ('Note does not exist.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Ignore Pik Principal Paid','Data already Reconcilled.','Due date is lower than accounting close date.')  ---'Ignore Paydowns',,'Ignore Paydowns Plus Pik Principal Paid' )
	group by TransactionType,BatchLogID

	UNION ALL

	select  TransactionType,0,0 ,count(Status) as DDAllRec,null as Notenotexist
	from CRE.TransactionAuditLog  where BatchLogID=@Batchlogid 
	and [Status] in ('Due Data already Reconcilled.')  ---,'Ignore Paydowns Plus Pik Principal Paid' )
	group by TransactionType,BatchLogID

	UNION ALL

	select null as TransactionType,0,0 as ignored,0 as DDAllRec,
	(SELECT STRING_AGG(CAST(CRENoteID AS VARCHAR(500)), ',') 
	FROM (
	SELECT DISTINCT CRENoteID
	FROM CRE.TransactionAuditLog 
	WHERE BatchLogID = @Batchlogid 
	AND [Status] = 'Note does not exist.'
	) AS DistinctNotes)AS Notenotexist

	from CRE.TransactionAuditLog  where BatchLogID=@Batchlogid 
	and [Status] in ('Note does not exist.')  
	group by TransactionType,BatchLogID

)aa
group by TransactionType,Notenotexist


 
---------------------------------END Total records imported--------------------------------
Delete from IO.L_Remittance    
    



END
