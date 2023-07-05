CREATE  PROCEDURE [dbo].[usp_SplitFeeTransaction]      
@TmpSplitTrans TableTypeSplitTranscation READONLY ,    
@CreatedBy nvarchar(256)       
AS      
BEGIN  

--insert into temp22 select * from @TmpSplitTrans
update  cre.TranscationReconciliation  set deleted=1 where Transcationid = (select top 1 TransactionID from  @TmpSplitTrans)

INSERT INTO cre.TranscationReconciliation   
([SplitTransactionid]    
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
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
)       
  select   TransactionID,    
  DueDate,    
  RemittanceDate,    
  ServcerMasterID,    
  DealId,    
  NoteID,    
  TransactionType,    
  TransactionDate as TransactionDate,    
  ServicingAmount_Distr as ServicingAmount,    
  M61Amount as CalculatedAmount,    
  case when ISNULL(OverrideValue,0)=0 then  isnull(ServicingAmount_Distr,0)-isnull(M61Amount,0)
   when ISNULL(OverrideValue,0)<>0 then  isnull(OverrideValue,0)-isnull(M61Amount,0) end as Delta,    
  M61Value as M61Value,    
  ServicerValue as ServicerValue,    
  Ignore as Ignore,   
  (case when isnull(OverrideValue,0)=0 then null 
  when isnull(OverrideValue,0)<>0 then  round(isnull(OverrideValue,0),2) END) as OverrideValue,
  comments ,    
  null as Posteddate,    
  BatchLogID as BatchLogID,    
  0 as Deleted,    
  Exception as Exception,    
  round(isnull( Adjustment,0),2) as Adjustment,    
  isnull(Delta + Adjustment,0) as ActualDelta,    
  round(isnull( AddlInterest,0),2)  as AddlInterest, --Capitalized INterest    
  0 as TotalInterest,--round(isnull( TotalInterest,0),2) as TotalInterest, --Cash INterest    
  OverrideReason as OverrideReason,    
  round(isnull( InterestAdj,0),2) as BerAddlint,    
  round(isnull(InterestAdj,0),2) as InterestAdj,  
     @CreatedBy,
	 getdate(),
	 @CreatedBy,
	 getdate()
  from @TmpSplitTrans tr     
 where tr.Received=1




    
    	
   --update cre.TranscationReconciliation set Delta =case when ServicingAmount then  ISNULL(ServicingAmount,0)-ISNULL(CalculatedAmount,0) 
    
    
  update cre.TranscationReconciliation set ActualDelta = Delta + Adjustment Where SplitTransactionid in (select  TransactionID from  @TmpSplitTrans) and  deleted=0
 

   
    END



	