

CREATE VIEW [dbo].[vw_Recon_Final_TransactionEntry_SameDB_Default_Vs_FullyExtendedFWCV] 
 AS  

Select ISNULL(Test.DealID,Stg.CREDealID) as DealID, ISNULL(Test.DealName,Stg.DealName) as DealName, DealStatus as DealStatus, ISNULL(Test.CreNoteID,Stg.CreNoteID) As NoteID, ISNULL(Test.NoteName,Stg.NoteName) as NoteName, ISNULL(Test.DevDate,stg.stgDate) as TransactionDate, ISNULL(Test.DevType,Stg.stgType) as TransactionType
, SUM(test.DevAmount) as DevAmount, SUM(Stg.StgAmount) as StgAmount, SUM(ISNULL(Test.DevAmount,0)-ISNULL(Stg.StgAmount,0)) as Delta, Test.ClosingDate, Test.ActualPayoffDate, Test.CalcStatus, Test.CalcEngineType  as DefaultCalcEngine,  stg.StgCalcEngineType as StgCalcEngineType
from   (
Select CREDealID as DealID,DealName,lds.name as DealStatus,CRENoteID,acc.name as NoteName,n.ClosingDate,n.ActualPayoffDate,cr.Calc_Status as CalcStatus,cr.CalcEngineType
, Type as DevType, Date as DevDate,SUM(Amount) as DevAmount ,a.Name as DevScenario
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
Where acc.isdeleted <> 1 and n.EnableM61Calculations=3
and te.AnalysisID='c10f3372-0fc2-4861-a9f5-148f1f80804f' 	
Group by NoteID, Type, date, te.AnalysisID ,a.Name ,CREDealID,DealName,CRENoteID,acc.name ,cr.Calc_Status,cr.CalcEngineType,n.ClosingDate,n.ActualPayoffDate,lds.name
) Test

full outer join (
Select 
d.credealid,d.dealname,acc.name as NoteName, l.Name as Status, n.CreNoteID as CreNoteID, Date as StgDate, SUM(Amount) as StgAmount, Type as StgType, a.Name as StgScenario, cr.CalcEngineType as StgCalcEngineType
from Cre.TransactionEntry ste
	Inner JOin cre.note n on n.Account_AccountID = ste.AccountId
	Inner join cre.deal d on d.dealid = n.dealid
	Inner join core.account acc on acc.accountid = n.Account_AccountID
	Inner Join core.lookup l on l.LookupID=d.Status
	Left join(
	Select Accountid,l.name as [Calc_Status],leng.name as CalcEngineType
	From core.CalculationRequests cr 
	left join core.Lookup l on l.LookupID=cr.StatusID 
	left join core.Lookup leng on leng.LookupID=cr.CalcEngineType 
	Where cr.AnalysisID='45cf083b-4755-4a8c-982a-7dc6d7b8e5f2' 
)cr on cr.AccountId = n.Account_AccountID
Inner join core.Analysis a on a.AnalysisID = ste.AnalysisID
Where ste.AnalysisID='45cf083b-4755-4a8c-982a-7dc6d7b8e5f2' 
Group by d.credealid,d.dealname,acc.name , l.Name , n.CreNoteID, Date , Type , a.Name, cr.CalcEngineType
) stg
on Test.CRENoteID=Stg.CreNoteID and Test.devDate=Stg.stgDate and Test.DevType=Stg.stgType 
Where ABS(ISNULL(Test.DevAmount,0)-ISNULL(Stg.StgAmount,0)) > 0.01
   and ISNULL(Test.DevType,Stg.StgType) not in ('EndingPVGAAPBookValue')
  --and test.CalcEngineType = 'V1 (New)' 
   --and DealID='20-1525' 
   --and ISNULL(Test.CreNoteID,Stg.CreNoteID)='24824'

Group by ISNULL(Test.DealID,Stg.CREDealID) , ISNULL(Test.DealName,Stg.DealName) , DealStatus, ISNULL(Test.CreNoteID,Stg.CreNoteID) , ISNULL(Test.NoteName,Stg.NoteName) , ISNULL(Test.DevDate,stg.stgDate) , ISNULL(Test.DevType,Stg.stgType) 
, Test.ClosingDate, Test.ActualPayoffDate, Test.CalcStatus, Test.CalcEngineType,  stg.StgCalcEngineType

--Order By ISNULL(Test.DealName,Stg.DealName),ISNULL(Test.CreNoteID,Stg.CreNoteID), ISNULL(Test.DevDate,Stg.stgDate), ISNULL(Test.DevType,Stg.stgType)