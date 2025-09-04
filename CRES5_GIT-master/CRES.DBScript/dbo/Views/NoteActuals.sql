
CREATE view [dbo].[NoteActuals]          
as           
          
Select NoteTransactionDetailAutoID ,          
NoteTransactionDetailID ,          
na.NoteID as NoteKey,          
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
na.comments,          
ServicerMasterBI as SourceType,          
PostedDate,          
ServicerMasterID,          
Deleted ,          
na.CreatedBy   ,          
na.CreatedDate ,          
na.UpdatedBy   ,          
na.UpdatedDate ,          
TranscationReconciliationID ,          
          
(CASE WHEN OverrideValue <> 0 then OverrideValue          
WHEN M61Value = 1 then CalculatedAmount          
WHEN ServicerValue = 1 then ServicingAmount          
WHEN Ignore = 1 then OverrideValue END) as UsedInCalc ,          
          
(crenoteid+'_'+ TransactionTypeText + '_' + CONVERT (VARCHAR(10),(CASE WHEN RelatedtoModeledPMTDate > n.ActualPayoffDate THEN n.ActualPayoffDate ELSE RelatedtoModeledPMTDate END), 110)  ) Note_Type_Date,        
        
OverrideReasonBI as OverrideReason ,         
BerAddlint ,      
InterestAdj,      
AddlInterest as CapitalizedInterest,      
TotalInterest as CashInterest  ,    
BatchLogID    
         
From dw.NoteTransactionDetailBI  na  
left join Note n on n.noteid = na.crenoteid  
          
      
      