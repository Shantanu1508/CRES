-- View        
CREATE View [dbo].[RealizedCashFlow_TransactionEntry]        
as    
  
Select NoteKey,  
NoteID,  
Date,  
SUM(Amount)Amount,  
TransactionTypeBI,  
DateBI,  
CreatedBy,  
CreatedDate,  
UpdatedBy,  
UpdatedDate,  
(noteid+'_'+ TransactionTypeBI + '_' + CONVERT (VARCHAR(10),Date, 110)  ) Note_Type_Date ,  
NoteID_Date_Scenario,  
AnalysisID,  
Scenario,  
--FeeName,  
InitialIndexValueOverride,  
NoteID_Date,  
DealName,  
DealID,  
NoteName,  
TR_CashFlow_Date,  
TR_TransactionDate,  
TR_DueDate,  
TR_RemitDate  
From(  
    
Select NoteKey,  
NoteID,  
Date,  
Amount,  
Type,  
TransactionTypeBI=(CASE WHEN Type like 'AdditionalFee%' THEN 'AdditionalFee'    
  WHEN Type like 'OriginationFee%' THEN 'OriginationFee'    
  WHEN Type like 'ExitFee%' THEN 'ExitFee'    
  WHEN Type like 'ExtensionFee%' THEN 'ExtensionFee'   
 ELSE Type END)  ,  
DateBI = Case when Type = 'InterestPaid' Then  EOMonth( IsNULL(TR_RemitDate,Date),0) else Date end,  
CreatedBy,  
CreatedDate,  
UpdatedBy,  
UpdatedDate,  
( a.noteid+'_'+ a.Type + '_' + CONVERT (VARCHAR(10),a.Date, 110)  ) Note_Type_Date,  
NoteID_Date_Scenario,  
AnalysisID,  
Scenario,  
FeeName,  
InitialIndexValueOverride,  
NoteID_Date,  
DealName,  
DealID,  
NoteName,  
TR_CashFlow_Date,  
TR_TransactionDate,  
TR_DueDate,  
TR_RemitDate  
From(  
 select  T.NoteID as NoteKey,        
 T.CRENoteID as NoteID,        
 Date,        
 Amount,        
 (  
 CASE WHEN Type like 'Extension%' and FeeName not like 'Additional%' then 'ExtensionFee'  
 WHEN Type like 'Origination%' and FeeName not like 'Additional%' then 'OriginationFee'  
 WHEN Type like 'AdditionalFee%'  THEN 'AdditionalFee'  
 WHEN Feename like 'Additional%' THEN 'AdditionalFee'   
 ELSE Type  
 END  
 )as Type,     
     
 T.CreatedBy,        
 T.CreatedDate,        
 T.UpdatedBy,        
 T.UpdatedDate ,        
 null as Note_Type_Date,          
 T.crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110) + AnalysisName   NoteID_Date_Scenario,          
 AnalysisID,        
 AnalysisName as Scenario,        
 FeeName,        
 InitialIndexValueOverride,        
 T.crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110)  NoteID_Date ,      
 DealName,      
 CreDealID as DealID,      
 N.Name as NoteName,      
      
 ISNULL(TransactionDateByRule,Date) as TR_CashFlow_Date,      
 TransactionDateServicingLog as TR_TransactionDate,      
 Date as TR_DueDate,      
 RemitDate as TR_RemitDate      
      
 From [DW].[TransactionEntryBI] T        
 left join DW.NoteBI N on N.Noteid = T.NoteID        
 where AnalysisName = 'Default'    
   
 and T.TransactionEntryID not in  ---Ignore ballon and FundingOrRepayment  
 (  
  Select b.TransactionEntryID  
  From(  
   Select T.TransactionEntryID,T.CreNoteID,T.type,T.Date,T.Amount   
   From [DW].[TransactionEntryBI] T        
   where AnalysisName = 'Default' and type ='Balloon'  
  
   UNION ALL  
  
   Select TF.TransactionEntryID,TF.CreNoteID,TF.type,TF.Date,TF.Amount   
   From [DW].[TransactionEntryBI] TF    
   INNER JOIN(  
    Select TransactionEntryID,CreNoteID,Date,Amount From [DW].[TransactionEntryBI] T        
    where AnalysisName = 'Default' and type ='Balloon'  
   )TB on TF.CreNoteID = TB.CreNoteID and TF.Date = TB.Date  
   where TF.AnalysisName = 'Default' and TF.type ='FundingOrRepayment'  and TF.Amount > 0  
  
   UNION ALL  
  
   Select T.TransactionEntryID,T.CreNoteID,T.type,T.Date,T.Amount   
   From [DW].[TransactionEntryBI] T        
   left join DW.NoteBI N on N.Noteid = T.NoteID  
   where AnalysisName = 'Default' and type ='FundingOrRepayment' and T.Date = N.ActualPayOffDate  
  )b   
 )  
  
)a  
--where a.noteid = '2702'  
  
)z  
Group by NoteKey,  
NoteID,  
Date,  
  
TransactionTypeBI,  
DateBI,  
CreatedBy,  
CreatedDate,  
UpdatedBy,  
UpdatedDate,  
--Note_Type_Date,  
NoteID_Date_Scenario,  
AnalysisID,  
Scenario,  
--FeeName,  
InitialIndexValueOverride,  
NoteID_Date,  
DealName,  
DealID,  
NoteName,  
TR_CashFlow_Date,  
TR_TransactionDate,  
TR_DueDate,  
TR_RemitDate



