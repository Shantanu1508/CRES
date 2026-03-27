CREATE PROCEDURE [dbo].[usp_UpdateTranscation]        
@TmpTrans TableTypeTranscationRecon READONLY,        
@CreatedBy nvarchar(256)        
        
AS        
BEGIN        
        
--insert into temp11 select * from @TmpTrans    
--Delete from temp11    
    
--Update cre.TranscationReconciliation SET M61Value=null,ServicerValue=null, Ignore=null        
--from cre.TranscationReconciliation tr        
--Where tr.postedDate is null        
        
    
--Declare @RemittanceDate Date =(Select top 1 RemittanceDate from @TmpTrans )         
Declare @ignoreLookupId int = (Select lookupid from core.Lookup where ParentID = 82 and name = 'ignore')        
Declare @M61LookupId int = (Select lookupid from core.Lookup where ParentID = 82 and name = 'M61')        
Declare @ServicingLookupId int = (Select lookupid from core.Lookup where ParentID = 82 and name = 'Servicing')     
Declare @InterestLookupId int = (Select lookupid from core.Lookup where  name = 'Interest Received' and parentid=39)        
Declare @PrincipalLookupId int = (Select lookupid from core.Lookup where  name = 'Principal Received' and parentid=39)        
    
        
--Declare @ManualTransactionServicerId int = (select ServicerMasterID from cre.ServicerMaster where ServicerName='ManualTransaction')        
    
    
       
        
--Update ignore = Deleted        
Update cre.TranscationReconciliation  SET  Deleted=1        
from @TmpTrans tr        
Where cre.TranscationReconciliation.Transcationid = tr.Transcationid  and tr.ignore=1        
        
--========================================================================        
Update cre.TranscationReconciliation        
SET          
M61Value=tr.M61Value,        
ServicerValue=tr.ServicerValue,        
comments=tr.comments,        
overridevalue=tr.overridevalue,        
Ignore=tr.Ignore,        
UpdatedBy=@CreatedBy,        
Delta=tr.Delta,        
Adjustment=tr.Adjustment,        
ActualDelta=tr.ActualDelta,        
OverrideReason=tr.OverrideReason,
WriteOffAmount = tr.WriteOffAmount,
AddlInterest = tr.AddlInterest,
TotalInterest = tr.TotalInterest
--postedDate=getDate()        
from @TmpTrans tr        
Where cre.TranscationReconciliation.Transcationid = tr.Transcationid        
and(isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or isnull(tr.ignore,0)<>0 or  tr.OverrideValue is not null)         
--========================================================================        
        
INSERT into cre.NoteTransactionDetail(NoteID,TransactionDate,TransactionType,Amount,RelatedtoModeledPMTDate,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServicerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,InterestAdj,AddlInterest,TotalInterest,WriteOffAmount)        
Select         
 tre.NoteID,         
 tre.TransactionDate,        
 (        
 CASE        
 WHEN tre.TransactionType='InterestPaid' then @InterestLookupId        
 --WHEN tre.TransactionType='ScheduledPrincipalPaid' then @PrincipalLookupId        
 end        
 ) as TransactionTypeId,        
 (        
 Case         
 When tre.OverrideValue > 0 then tre.OverrideValue         
 When tre.M61Value = 1 then tre.CalculatedAmount        
 When tre.ServicerValue = 1 then tre.ServicingAmount         
 --When tre.OverrideValue is not null and isnull(tre.overridereason,0)<>0 then tre.OverrideValue        
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
 tre.TotalInterest,
 tre.WriteOffAmount
 from cre.TranscationReconciliation tre          
 Where  tre.deleted=0 and (isnull(tre.M61Value,0) <>0 or isnull(tre.ServicerValue,0) <>0  or tre.OverrideValue is not null)        
 and tre.postedDate is null         
 and TransactionType not in ('PIKInterestPaid','ManagementFee','ExitFee','ExtensionFee','PrepaymentFee','UnusedFeeExcludedFromLevelYield','PIKPrincipalPaid' ,'PrepaymentFeeExcludedFromLevelYield'  --,'FundingOrRepayment'

--,'ExitFeeExcludedFromLevelYield',      
--'ExitFeeIncludedInLevelYield',      
--'ExitFeeStrippingExcldfromLevelYield',      
--'ExitFeeStripReceivable' , 

--'ExtensionFeeExcludedFromLevelYield',      
--'ExtensionFeeIncludedInLevelYield',      
--'ExtensionFeeStrippingExcldfromLevelYield',      
--'ExtensionFeeStripReceivable' 
 )        
and tre.SplitTransactionid is null ---Newly added   
and tre.Transcationid in (Select Transcationid from @TmpTrans)  
     
    
    
--Update posted date = null        
Update cre.TranscationReconciliation SET postedDate=getDate()        
from @TmpTrans tr        
Where cre.TranscationReconciliation.Transcationid = tr.Transcationid        
and(isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or isnull(tr.ignore,0)<>0 or  tr.OverrideValue is not null)         
and tr.TransactionType in ('InterestPaid','ScheduledPrincipalPaid')    
and cre.TranscationReconciliation.SplitTransactionid is null    


exec [dbo].[usp_UpdateTranscationForPIKINterestPaid] @CreatedBy  
    
    
---==========Reconcile Fee Transaction as granual level=====================    
    
declare @TmpFeeTrans TableTypeTranscationRecon      
    
INSERT INTO @TmpFeeTrans ([Transcationid],[NoteID])    
select [Transcationid],[NoteID] from @TmpTrans     
where   (isnull(M61Value,0) <>0 or isnull(ServicerValue,0) <>0  or OverrideValue is not null or isnull(Ignore,0) <> 0 ) 
--and TransactionType not in ('InterestPaid')  
         
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
 where NoteID in  (Select Distinct NoteID from @TmpTrans tr  Where  (isnull(tr.M61Value,0) <>0 or isnull(tr.ServicerValue,0) <>0  or  tr.OverrideValue is not null) )        
 and an.name = 'Default'        
      
 exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@CreatedBy, NULL, NULL, 'TransactionRecon'
     
     
     
     
        
End
GO

