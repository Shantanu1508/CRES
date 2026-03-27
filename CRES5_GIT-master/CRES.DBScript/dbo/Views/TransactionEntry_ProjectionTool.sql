    
-- View    
CREATE View [dbo].[TransactionEntry_ProjectionTool]    
as     
select     
T.NoteID as NoteKey,    
T.CRENoteID as NoteID,    
--ISNULL(TransactionDateByRule,Date) as Date,
(CASE WHEN T.Type like '%Interest%' THEN ISNULL(TransactionDateByRule,Date) ELSE T.Date END)  as Date,    
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
    
Where T.analysisID in ('C10F3372-0FC2-4861-A9F5-148F1F80804F','45CF083B-4755-4A8C-982A-7DC6D7B8E5F2') --- (Select analysisID from core.analysis where [Name] in ('Default','Fully Extended (FWCV)') )  

and T.Date >= CAST(DateADD(year,-1,getdate())  as Date) 
and T.AccountTypeID = 1 
 
    