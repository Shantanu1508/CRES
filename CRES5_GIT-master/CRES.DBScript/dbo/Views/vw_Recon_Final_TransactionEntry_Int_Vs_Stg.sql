  
CREATE VIEW [dbo].[vw_Recon_Final_TransactionEntry_Int_Vs_Stg]    
    
AS    
  
Select ISNULL(Test.DealID,Stg.CREDealID) as DealID, ISNULL(Test.DealName,Stg.DealName) as DealName, ISNULL(DealStatus, stg.Status) as DealStatus, ISNULL(Test.CreNoteID,Stg.CreNoteID) As NoteID, ISNULL(Test.NoteName,Stg.NoteName) as NoteName, Test.DevDate,stg.stgDate as StgDate, ISNULL(
Test.DevType,Stg.stgType) as TransactionType  
, SUM(test.DevAmount) as DevAmount, SUM(Stg.StgAmount) as StgAmount, SUM((Test.DevAmount)-(Stg.StgAmount)) as Delta, Test.ClosingDate, Test.ActualPayoffDate, ISNULL(Test.CalcStatus,Stg.CalcStatus) as CalcStatus, ISNULL(Test.CalcEngineType,stg.CalcEngineType)  as DevCalcEngine--, EnableM61Calculations  
from   (  
Select CREDealID as DealID,DealName,lds.name as DealStatus,CRENoteID,acc.name as NoteName,n.ClosingDate,n.ActualPayoffDate,cr.Calc_Status as CalcStatus,cr.CalcEngineType  
, Type as DevType, Date as DevDate,SUM(Amount) as DevAmount ,a.Name as DevScenario, n.EnableM61Calculations as EnableM61Calculations  
from Cre.TransactionEntry te  
left join cre.Note n on n.Account_AccountID=te.AccountId  
Inner join core.account acc on acc.AccountID = n.Account_AccountID  
Inner join core.Analysis a on a.AnalysisID = te.AnalysisID  
Inner Join cre.Deal d on d.dealid = n.DealID  
Left join core.lookup lds on lds.lookupid = d.Status  
Left join(  
 Select Accountid,l.name as [Calc_Status],leng.name as CalcEngineType  
 From core.CalculationRequests cr   
 left join core.Lookup l on l.LookupID=cr.StatusID   
 left join core.Lookup leng on leng.LookupID=cr.CalcEngineType   
 Where cr.AnalysisID='c10f3372-0fc2-4861-a9f5-148f1f80804f'  
)cr on cr.AccountId = n.Account_AccountID  
Where acc.isdeleted <> 1 and d.IsDeleted<>1 and n.EnableM61Calculations=3  
and te.AnalysisID='c10f3372-0fc2-4861-a9f5-148f1f80804f' ---and CRENoteID = '10640'   
Group by NoteID, Type, date, te.AnalysisID ,a.Name ,CREDealID,DealName,CRENoteID,acc.name ,cr.Calc_Status,cr.CalcEngineType,n.ClosingDate,n.ActualPayoffDate,lds.name, EnableM61Calculations  
) Test  
full outer join (  
Select   
d.credealid,d.dealname,acc.name as NoteName, l.Name as Status, n.CreNoteID as CreNoteID, Date as StgDate, SUM(Amount) as StgAmount, Type as StgType, a.Name as StgScenario , lcr.Name as CalcEngineType, lsts.Name as CalcStatus
from Dw.Staging_TransactionEntry ste  
 Inner JOin cre.note n on n.crenoteid = ste.crenoteid  
 Inner join cre.deal d on d.dealid = n.dealid  
 Inner join core.account acc on acc.accountid = n.Account_AccountID  
 Inner Join core.lookup l on l.LookupID=d.Status  
 Inner join core.Analysis a on a.AnalysisID = ste.AnalysisID 
 left join core.CalculationRequests cr on cr.AccountId=n.Account_AccountID and cr.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'  
 left join core.lookup lcr on lcr.LookupID=cr.CalcEngineType
 left join core.lookup lsts on lsts.LookupID=cr.StatusID
Where ste.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'  and n.EnableM61Calculations=3
Group by d.credealid,d.dealname,acc.name , l.Name , n.CreNoteID, Date , Type , a.Name ,lcr.Name,lsts.Name
) stg  
on Test.CRENoteID=Stg.CreNoteID and Test.devDate=Stg.stgDate and Test.DevType=Stg.stgType   
Where (ABS(Test.DevAmount-Stg.stgAmount) > 0.01 OR (Test.DevAmount-Stg.stgAmount) is NULL)  
  
-- and test.CalcEngineType = 'V1 (New)'   
--and DealID='20-1525'   
--and ISNULL(Test.CreNoteID,Stg.CreNoteID)='24824'  
  
Group By ISNULL(Test.DealID,Stg.CREDealID), ISNULL(Test.DealName,Stg.DealName), ISNULL(DealStatus, stg.Status) , ISNULL(Test.CreNoteID,Stg.CreNoteID) , ISNULL(Test.NoteName,Stg.NoteName) , ISNULL(Test.DevDate,stg.stgDate) , ISNULL(Test.DevType,Stg.stgType)   
, Test.ClosingDate, Test.ActualPayoffDate, ISNULL(Test.CalcStatus,Stg.CalcStatus), ISNULL(Test.CalcEngineType,stg.CalcEngineType), EnableM61Calculations, Test.DevDate,stg.stgDate  
--Order By ISNULL(Test.DealName,Stg.DealName),ISNULL(Test.CreNoteID,Stg.CreNoteID), ISNULL(Test.DevDate,Stg.stgDate), ISNULL(Test.DevType,Stg.stgType)  