CREATE VIEW [dbo].[TransactionEntry_ProjectionTool_ExpectedMaturityDate_withPrepay_FWCVShiftUpward50bps]
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
    
Where T.analysisID in ('81F49F3A-C196-4E10-829E-AAF593552889') ---(Select analysisID from core.analysis where [Name] in ('Expected Maturity Date (with Prepay, FWCV Shift Upward)') )  

and T.Date >= CAST(DateADD(year,-1,getdate())  as Date)
and T.AccountTypeID = 1 
 
    
