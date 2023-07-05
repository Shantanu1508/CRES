-- Procedure

CREATE PROCEDURE [dbo].[usp_UpdateTranscationForPIKINterestPaid]
@CreatedBy nvarchar(256)
AS
BEGIN


Declare @InterestLookupId int = (Select lookupid from core.Lookup where  name = 'Interest Received' and parentid=39)
Declare @PIKINterestPaidLookupId int = (Select TransactionTypesID from cre.TransactionTypes where TransactionName = 'PIKInterestPaid')
Declare @ManagementFee int = (Select TransactionTypesID from cre.TransactionTypes where TransactionName = 'ManagementFee')



IF OBJECT_ID('tempdb..[#TempPIKINterestPaid]') IS NOT NULL                                         
 DROP TABLE [#TempPIKINterestPaid]  

Create table [#TempPIKINterestPaid]
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

Flag	nvarchar(255) null, 
AmountToBeUpdate decimal(28,15) null,
)  
INSERT INTO [#TempPIKINterestPaid] (NoteID,TransactionDate,TransactionTypeId,Amount,DateDue,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServcerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,Flag,AmountToBeUpdate)
Select 
	tre.NoteID,	
	tre.TransactionDate,
	--@PIKINterestPaidLookupId as TransactionTypeId,
	ty.TransactionTypesID as TransactionTypeId,
	(
		Case	
		When tre.M61Value = 1 then tre.CalculatedAmount
		When tre.ServicerValue = 1 then tre.ServicingAmount	
		When isnull(tre.OverrideValue,0)<>0 then tre.OverrideValue	
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
	getDate() as PostedDate,
	tre.ServcerMasterID,	
	@CreatedBy as CreatedBy,
	getDate() as CreatedDate,
	@CreatedBy as UpdatedBy,
	getDate() as UpdatedDate,
	tre.TransactionType as TransactionTypeText,
	tre.Transcationid as TranscationReconciliationID ,
	tre.RemittanceDate,
	tre.Exception,
	tre.Adjustment,
	tre.ActualDelta,
	tre.OverrideReason,	
	'insert' as Flag,

	(Case When (isnull(tre.OverrideValue,0) <> 0 ) Then tre.OverrideValue
		When (isnull(tre.M61Value,0) <> 0 ) Then tre.CalculatedAmount
		When (isnull(tre.ServicerValue,0) <>0 ) Then tre.ServicingAmount
		When (isnull(tre.Ignore,0) <>0 ) Then tre.OverrideValue
		ELSE tre.CalculatedAmount END) 
	as AmountToBeUpdate

	from cre.TranscationReconciliation tre  
	left join cre.transactiontypes ty on ty.TransactionName = tre.TransactionType
	Where  tre.deleted=0 and (isnull(tre.M61Value,0) <> 0 or isnull(tre.ServicerValue,0) <> 0  or tre.OverrideValue is not null)
	and tre.postedDate is null	
	and TransactionType in ('PIKInterestPaid','ManagementFee')


Update [#TempPIKINterestPaid] set [#TempPIKINterestPaid].Flag = 'update'
from(
	
	Select 
	a.noteid,
	a.TransactionTypeText,
	a.DateDue,
	a.Amount
	from [#TempPIKINterestPaid] a
	inner join cre.NoteTransactionDetail ntd on ntd.noteid = a.noteid and a.DateDue = ntd.RelatedtoModeledPMTDate and a.TransactionTypeText = ntd.TransactionTypeText
	where ntd.TransactionTypeText in ('PIKInterestPaid','ManagementFee')
)b
where 
[#TempPIKINterestPaid].noteid = b.noteid
and [#TempPIKINterestPaid].TransactionTypeText = b.TransactionTypeText
and [#TempPIKINterestPaid].DateDue = b.DateDue

---==========================================

INSERT into cre.NoteTransactionDetail(NoteID,TransactionDate,TransactionType,Amount,RelatedtoModeledPMTDate,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServicerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason)
Select NoteID,
TransactionDate,
---@PIKINterestPaidLookupId as  TransactionType,
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
OverrideReason 
from [#TempPIKINterestPaid] where Flag = 'insert'



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
--cre.NoteTransactionDetail.CreatedBy = a.CreatedBy,
--cre.NoteTransactionDetail.CreatedDate = a.CreatedDate,
cre.NoteTransactionDetail.UpdatedBy = a.UpdatedBy,
cre.NoteTransactionDetail.UpdatedDate = a.UpdatedDate,
cre.NoteTransactionDetail.TranscationReconciliationID = a.TranscationReconciliationID,
cre.NoteTransactionDetail.RemittanceDate = a.RemittanceDate,
cre.NoteTransactionDetail.Exception = a.Exception,
cre.NoteTransactionDetail.Adjustment = a.Adjustment,
cre.NoteTransactionDetail.ActualDelta = a.ActualDelta,
cre.NoteTransactionDetail.OverrideReason = a.OverrideReason
From(
	Select NoteID,
	TransactionDate,
	--@PIKINterestPaidLookupId as  TransactionType,
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
	OverrideReason 
	from [#TempPIKINterestPaid] where Flag = 'update'
)a
where cre.NoteTransactionDetail.noteid = a.noteid
and cre.NoteTransactionDetail.TransactionTypeText = a.TransactionTypeText
and cre.NoteTransactionDetail.RelatedtoModeledPMTDate = a.RelatedtoModeledPMTDate
and cre.NoteTransactionDetail.TransactionTypeText in ('PIKInterestPaid','ManagementFee')



END
