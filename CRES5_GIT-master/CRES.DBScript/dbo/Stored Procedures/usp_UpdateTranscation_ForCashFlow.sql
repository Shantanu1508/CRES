-- Procedure
CREATE PROCEDURE [dbo].[usp_UpdateTranscation_ForCashFlow]              
@TmpTrans [TableTypeTranscationRecon_CF] READONLY,              
@CreatedBy nvarchar(256)              
              
AS              
BEGIN              
     
	 
	--- select * INTO  temp10 from @TmpTrans 

        
Declare @servicername nvarchar(256) = (Select top 1 SourceType from @TmpTrans)        
        
Declare @CurrentTime nvarchar(256) = (Select Replace(Replace(Convert(nvarchar(256), getdate(),120) ,' ','_'),':','_'))        
Declare @BatchlogId int         
declare @ServcerMasterID int  = (select ServicerMasterID from cre.ServicerMaster where ServicerName = @servicername)        
  
    
        
INSERT INTO [IO].[FileBatchLog](ServcerMasterID,OrigFileName,BlobFileName,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)        
VALUES(@ServcerMasterID,'CashFlow_Data' + @CurrentTime,'CashFlow_Data' + @CurrentTime,@CreatedBy,getdate(),@CreatedBy,getdate())        
        
set @BatchlogId = @@Identity        
        
 
        
INSERT into cre.TranscationReconciliation(        
DealId,        
NoteID,        
ServcerMasterID,        
RemittanceDate,        
TransactionType,        
DateDue,        
ServicingAmount,        
CalculatedAmount,        
Delta,        
TransactionDate,        
CreatedBy,        
createdDate,        
UpdatedBy,        
UpdatedDate,        
BatchLogID,        
Exception,        
AddlInterest,        
TotalInterest,
WriteOffAmount,
Adjustment,        
ActualDelta,        
InterestAdj,        
[M61Value],        
[ServicerValue],        
[Ignore],        
[OverrideValue],        
[comments],        
[OverrideReason],        
DueDateAlreadyReconciled,        
Deleted)          
          
select         
[DealId]        
,[NoteID]        
,@ServcerMasterID        
,[RemittanceDate]        
,[TransactionType]        
,[DateDue]        
,[ServicingAmount]        
,[CalculatedAmount]        
,[Delta]        
,[TransactionDate]        
,@CreatedBy        
,getdate()        
,@CreatedBy        
,getdate()        
,@BatchlogId  
,null as Exception        
,AddlInterest        
,TotalInterest        
,WriteOffAmount      
,Adjustment        
,ActualDelta        
,InterestAdj 
,[M61Value]        
,[ServicerValue]        
,[Ignore]        
,[OverrideValue]        
,[comments]        
,[OverrideReason]        
,DueDateAlreadyReconciled        
,(case when isnull(tr.ignore,0)=1 then 1 else 0  END)        
From @TmpTrans tr        
where (isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or isnull(tr.ignore,0)<>0 or  tr.OverrideValue is not null)         
--and tr.TransactionType not in ('ExitFee')          
--Update cre.TranscationReconciliation  SET  Deleted=1              
--Where BatchLogID =  @BatchlogId  and ignore=1        
----======================================================


IF OBJECT_ID('tempdb..[#TempInsertUpdateDataActual]') IS NOT NULL                                           
 DROP TABLE [#TempInsertUpdateDataActual]    
  
Create table [#TempInsertUpdateDataActual]  
(      
NoteID UNIQUEIDENTIFIER null,  
TransactionDate Date null,  
TransactionTypeId int null,  
Amount decimal(28,15) null,  
DateDue  Date null,  
ServicingAmount decimal(28,15) null,  
CalculatedAmount decimal(28,15) null,  
Delta decimal(28,15) null,  
M61Value bit null,  
ServicerValue bit null,  
Ignore bit null,  
OverrideValue decimal(28,15) null,  
comments nvarchar(256) null,  
PostedDate  Date null,  
ServcerMasterID int null,  
CreatedBy nvarchar(256) null,  
CreatedDate  Date null,  
UpdatedBy nvarchar(256) null,  
UpdatedDate  Date null,  
TransactionTypeText nvarchar(256) null,  
TranscationReconciliationID UNIQUEIDENTIFIER null,  
RemittanceDate  Date null,  
Exception nvarchar(256) null,  
Adjustment decimal(28,15) null,  
ActualDelta decimal(28,15) null,  
OverrideReason int null,    
InterestAdj [decimal](28, 15) NULL,
AddlInterest [decimal](28, 15) NULL,
TotalInterest [decimal](28, 15) NULL,
WriteOffAmount decimal(28,15) null,
Flag nvarchar(255) null,   

)   
INSERT INTO [#TempInsertUpdateDataActual] (NoteID,TransactionDate,TransactionTypeId,Amount,DateDue,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServcerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,
TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,InterestAdj,AddlInterest,TotalInterest,WriteOffAmount,Flag)  
Select               
 tre.NoteID,               
 tre.TransactionDate,              
 ty.TransactionTypesID as TransactionTypeId, 
 (              
 Case               
 When tre.OverrideValue > 0 then tre.OverrideValue               
 When tre.M61Value = 1 then tre.CalculatedAmount              
 When tre.ServicerValue = 1 then tre.ServicingAmount               
 When (isnull(tre.M61Value,0) = 0 and isnull(tre.ServicerValue,0) = 0 ) then tre.OverrideValue               
 END              
 )as Amount,  
 tre.DateDue,              
 tre.ServicingAmount,              
 tre.CalculatedAmount,              
 tre.Delta,              
 tre.M61Value,              
 tre.ServicerValue,              
 tre.Ignore,              
 tre.OverrideValue,              
 tre.comments,               
 getDate(),              
 tre.ServcerMasterID,               
 @CreatedBy,              
 getDate(),              
 @CreatedBy,              
 getDate(),              
 tre.TransactionType as TransactionTypeText,              
 tre.Transcationid as TranscationReconciliationID ,              
 tre.RemittanceDate,              
 tre.Exception,              
 tre.Adjustment,              
 tre.ActualDelta,              
 tre.OverrideReason,              
 tre.InterestAdj,              
 tre.AddlInterest,              
 tre.TotalInterest ,
 WriteOffAmount,
 'insert' as Flag
 from cre.TranscationReconciliation tre            
 left join cre.transactiontypes  ty on ty.TransactionName = tre.TransactionType        
 Where  tre.deleted=0 and (isnull(tre.M61Value,0) <>0 or isnull(tre.ServicerValue,0) <>0  or tre.OverrideValue is not null)              
 and tre.postedDate is null  and tre.Deleted <> 1         
 and tre.BatchLogID =  @BatchlogId        
 and  tre.ServcerMasterID= @ServcerMasterID   
 and tre.TransactionType not in ('ExitFee') 


  
Update [#TempInsertUpdateDataActual] set [#TempInsertUpdateDataActual].Flag = 'update'  
from(  
   
	Select   
	a.noteid,  
	a.TransactionTypeText,  
	a.DateDue,  
	a.Amount  
	from [#TempInsertUpdateDataActual] a  
	inner join cre.NoteTransactionDetail ntd on ntd.noteid = a.noteid and a.DateDue = ntd.RelatedtoModeledPMTDate and a.TransactionTypeText = ntd.TransactionTypeText  
	where ntd.ServicerMasterID = 5
)b  
where   
[#TempInsertUpdateDataActual].noteid = b.noteid  
and [#TempInsertUpdateDataActual].TransactionTypeText = b.TransactionTypeText  
and [#TempInsertUpdateDataActual].DateDue = b.DateDue    


----INsert int Actuals
INSERT into cre.NoteTransactionDetail(NoteID,TransactionDate,TransactionType,Amount,RelatedtoModeledPMTDate,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServicerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,InterestAdj,AddlInterest,TotalInterest,WriteOffAmount )              
Select NoteID,TransactionDate,TransactionTypeId,Amount,DateDue,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServcerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,InterestAdj,AddlInterest,TotalInterest,WriteOffAmount   
From [#TempInsertUpdateDataActual] where Flag = 'insert' 
        
---Update in Actuals
Update cre.NoteTransactionDetail set   
cre.NoteTransactionDetail.TransactionDate = a.TransactionDate,  
cre.NoteTransactionDetail.TransactionType = a.TransactionType,  
cre.NoteTransactionDetail.Amount = a.Amount,  
cre.NoteTransactionDetail.ServicingAmount = a.ServicingAmount,  
cre.NoteTransactionDetail.CalculatedAmount = a.CalculatedAmount,  
cre.NoteTransactionDetail.Delta = a.Delta,  
cre.NoteTransactionDetail.M61Value = a.M61Value,  
cre.NoteTransactionDetail.ServicerValue = a.ServicerValue,  
cre.NoteTransactionDetail.Ignore = a.Ignore,  
cre.NoteTransactionDetail.OverrideValue = a.OverrideValue,  
cre.NoteTransactionDetail.comments = a.comments,  
cre.NoteTransactionDetail.PostedDate = a.PostedDate,  
cre.NoteTransactionDetail.ServicerMasterID = a.ServcerMasterID,  
cre.NoteTransactionDetail.UpdatedBy = a.UpdatedBy,  
cre.NoteTransactionDetail.UpdatedDate = a.UpdatedDate,  
cre.NoteTransactionDetail.TranscationReconciliationID = a.TranscationReconciliationID,  
cre.NoteTransactionDetail.RemittanceDate = a.RemittanceDate,  
cre.NoteTransactionDetail.Exception = a.Exception,  
cre.NoteTransactionDetail.Adjustment = a.Adjustment,  
cre.NoteTransactionDetail.ActualDelta = a.ActualDelta,  
cre.NoteTransactionDetail.OverrideReason = a.OverrideReason ,
cre.NoteTransactionDetail.WriteOffAmount = a.WriteOffAmount ,
cre.NoteTransactionDetail.AddlInterest = a.AddlInterest ,
cre.NoteTransactionDetail.TotalInterest = a.TotalInterest 
From(  
	 Select NoteID,  
	 TransactionDate,  
	 TransactionTypeId as  TransactionType,  
	 Amount,  
	 Datedue as RelatedtoModeledPMTDate,  
	 ServicingAmount,  
	 CalculatedAmount,  
	 Delta,  
	 M61Value,  
	 ServicerValue,  
	 Ignore,  
	 OverrideValue,  
	 comments,  
	 PostedDate,  
	 ServcerMasterID,  
	 CreatedBy,  
	 CreatedDate,  
	 UpdatedBy,  
	 UpdatedDate,  
	 TransactionTypeText,  
	 TranscationReconciliationID,  
	 RemittanceDate,  
	 Exception,  
	 Adjustment,  
	 ActualDelta,  
	 OverrideReason,
	 WriteOffAmount,
	 AddlInterest,
	 TotalInterest
	 from [#TempInsertUpdateDataActual] where Flag = 'update'  
)a  
where cre.NoteTransactionDetail.noteid = a.noteid  
and cre.NoteTransactionDetail.TransactionTypeText = a.TransactionTypeText  
and cre.NoteTransactionDetail.RelatedtoModeledPMTDate = a.RelatedtoModeledPMTDate  
and cre.NoteTransactionDetail.ServicerMasterID = 5
        



--Update posted date = null              
Update cre.TranscationReconciliation SET postedDate=getDate()           
Where BatchLogID =  @BatchlogId        
and postedDate is null           
and(isnull(M61Value,0) <>0 or isnull(ServicerValue,0) <>0  or isnull(ignore,0)<>0 or  OverrideValue is not null)               
 and TransactionType not in ('ExitFee')           
  
  
---==========Reconcile Fee Transaction as granual level=====================    
    
declare @TmpFeeTrans TableTypeTranscationRecon      
    
INSERT INTO @TmpFeeTrans ([Transcationid],[NoteID])  
Select tr.Transcationid,tr.NoteID from cre.TranscationReconciliation tr
Inner join @TmpTrans ttr on ttr.DateDue = tr.DateDue and ttr.RemittanceDate = tr.RemittanceDate and ttr.TransactionType = tr.TransactionType
where tr.BatchLogID = @BatchlogId
and Deleted = 0
and tr.PostedDate is null
and tr.TransactionType = 'ExitFee'
and (isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or tr.OverrideValue is not null or isnull(tr.Ignore,0) <> 0 )  

exec [dbo].[usp_FeeReconcileTransaction]  @TmpFeeTrans, @CreatedBy  
---==========================================================================  


          
 --Update value = 0 if M61 checked              
 Update cre.NoteTransactionDetail SET Delta = Round((ServicingAmount - CalculatedAmount),2),              
 OverrideValue=null,              
 Adjustment=0,              
 ActualDelta=0               
 WHERE M61Value = 1              
          
           
          
  --Recalc note              
 declare @TableTypeCalculationRequests TableTypeCalculationRequests              
               
 insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)              
 Select NoteId,'Processing',@CreatedBy,'Batch',an.AnalysisID ,775        
 From Cre.Note,core.Analysis an              
 where NoteID in  (Select Distinct NoteID from @TmpTrans )             -- tr  Where  (isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or  tr.OverrideValue is not null)  
 and an.name = 'Default'              
            
 exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@CreatedBy               
           
           
           
           
              
End 