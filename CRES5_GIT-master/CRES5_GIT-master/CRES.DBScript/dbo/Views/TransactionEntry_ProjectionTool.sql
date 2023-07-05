    
-- View    
CREATE View [dbo].[TransactionEntry_ProjectionTool]    
as     
select     
T.NoteID as NoteKey,    
T.CRENoteID as NoteID,    
Date,    
Amount,    
Type,    
T.CreatedBy,    
T.CreatedDate,    
T.UpdatedBy,    
T.UpdatedDate ,    
( T.crenoteid+'_'+ Type + '_' + CONVERT (VARCHAR(10),Date, 110)  ) Note_Type_Date,      
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
    
Where T.analysisID in (Select analysisID from core.analysis where [Name] in ('Default','Fully Extended (FWCV)') )  

and T.Date >= CAST(DateADD(year,-1,getdate())  as Date) 
 
    