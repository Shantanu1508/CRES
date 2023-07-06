
CREATE view [dbo].[NoteActuals]    
as     
    
Select NoteTransactionDetailAutoID ,    
NoteTransactionDetailID ,    
NoteID as NoteKey,    
CRENoteID as NoteID,    
TransactionDate,    
RelatedtoModeledPMTDate as DueDate,    
RemittanceDate as RemitDate,    
TransactionTypeText as TransactionType,    
CalculatedAmount,    
ServicingAmount,    
OverrideValue,    
Delta as CalculateDelta,    
Adjustment,    
ActualDelta,    
M61Value as M61,    
ServicerValue as Servicer,    
Ignore,    
Exception ,    
comments,    
ServicerMasterBI as SourceType,    
PostedDate,    
ServicerMasterID,    
Deleted ,    
CreatedBy   ,    
CreatedDate ,    
UpdatedBy   ,    
UpdatedDate ,    
TranscationReconciliationID ,    
    
(CASE WHEN OverrideValue <> 0 then OverrideValue    
WHEN M61Value = 1 then CalculatedAmount    
WHEN ServicerValue = 1 then ServicingAmount    
WHEN Ignore = 1 then OverrideValue END) as UsedInCalc ,    
    
(crenoteid+'_'+ TransactionTypeText + '_' + CONVERT (VARCHAR(10),RelatedtoModeledPMTDate, 110)  ) Note_Type_Date,  
  
OverrideReasonBI as OverrideReason ,   
BerAddlint ,
InterestAdj,
AddlInterest as CapitalizedInterest,
TotalInterest as CashInterest,
BatchLogID
   
From dw.NoteTransactionDetailBI    
    


	