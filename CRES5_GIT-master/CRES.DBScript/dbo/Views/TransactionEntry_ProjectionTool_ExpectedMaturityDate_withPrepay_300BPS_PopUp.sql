CREATE VIEW [dbo].[TransactionEntry_ProjectionTool_ExpectedMaturityDate_withPrepay_300BPS_PopUp]
AS
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
    
Where T.analysisID in ('928387E0-8D5F-4387-98D3-37D8A84F038D') -- (Select analysisID from core.analysis where [Name] in ('Expected Maturity Date (with Prepay, 300BPS Pop Up)') )  

and T.Date >= CAST(DateADD(year,-1,getdate())  as Date)
and T.AccountTypeID = 1 
 
    
