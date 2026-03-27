
--[dbo].[usp_ImportIntoTranscationReconciliation] 4,'c10f3372-0fc2-4861-a9f5-148f1f80804f'
CREATE PROCEDURE [dbo].[usp_ImportManualTransIntoTranscationRecon] 
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
	

	 ---==========================Insert into TransactionAuditLog====================================

	 INSERT into cre.TransactionAuditLog(BatchLogID,NoteID,TransactionType,DueDate,ServicingAmount,Status,ServicerMasterID,TransactionDate)(
		SELECT 
			@Batchlogid,
			mt.NoteID,	
			mt.ValueType,	
			mt.DueDate,				
			isNull(mt.Value,0) as ServicingAmount,
			'Imported',		
			@ServicerMasterID,	
			mt.TransDate					
	  from IO.[L_ManualTransaction] mt
		inner join cre.note n on n.CRENoteID=mt.NoteID 		
		left join [Cre].Transactionentry CREtr on n.Account_AccountID=CREtr.AccountID and mt.DueDate=CREtr.Date and mt.ValueType=CREtr.Type and AnalysisID=@ScenarioId		
	 Where mt.ValueType='InterestPaid'
	)



Update ta set ta.Status='Data already Reconcilled.'			
from cre.TransactionAuditLog ta 
inner join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and 	 
ta.DueDate=tr.DateDue and 
ta.TransactionType=tr.[TransactionType]  and 
ta.RemitDate=tr.RemittanceDate	and
ta.TransactionDate=tr.TransactionDate and
ta.ServicerMasterID=tr.ServcerMasterID
where tr.posteddate is not null	
and ta.Batchlogid = @Batchlogid



Update ta set ta.Status='Reimported'			
from cre.TransactionAuditLog ta 
INNER join cre.TranscationReconciliation tr on ta.NoteID=tr.NoteID and 	 
ta.DueDate=tr.DateDue and 
ta.TransactionType=tr.[TransactionType]  and 
ta.RemitDate=tr.RemittanceDate and
ta.TransactionDate=tr.TransactionDate and
ta.ServicerMasterID=tr.ServcerMasterID 
where tr.posteddate is null	and ta.Batchlogid =@Batchlogid

INSERT into cre.TranscationReconciliation(DealId,NoteID,ServcerMasterID,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID)(	
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
			@Batchlogid	
	  from IO.[L_ManualTransaction] mt
		inner join cre.note n on n.CRENoteID=mt.NoteID 
		left join cre.Deal d on d.DealID=n.DealID
		left join [Cre].Transactionentry CREtr on n.Account_AccountID=CREtr.AccountID and mt.DueDate=CREtr.Date and mt.ValueType=CREtr.Type and AnalysisID=@ScenarioId		
	 Where mt.ValueType='InterestPaid' 
	 )	



select @ignoredrows=count(TransactionAuditLogID) from CRE.TransactionAuditLog where status in ('Remit Amount is Zero.','Data already Reconcilled.') and BatchLogID=@Batchlogid 

set @rowsinTrans =@TotalRowsCount-@ignoredrows

if(@rowsinTrans>0)
	set @successmsg=cast ((@rowsinTrans) as varchar(10)) + ' records imported successfully.'
if(@ignoredrows>0)
	set @successmsg= @successmsg + ' ' + cast((@ignoredrows)  as varchar(10) )+ ' records were ignored.'


select @successmsg


END
