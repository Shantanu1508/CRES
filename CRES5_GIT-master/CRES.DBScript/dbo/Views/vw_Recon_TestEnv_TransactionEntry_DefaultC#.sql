CREATE VIEW DBO.vw_Recon_TestEnv_TransactionEntry_DefaultC#
AS
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
	Where cr.AnalysisID='00b25f98-7037-4c2c-abb1-a23f0854e0d1'
)cr on cr.AccountId = n.Account_AccountID
Where acc.isdeleted <> 1 and n.EnableM61Calculations=3
and te.AnalysisID='00b25f98-7037-4c2c-abb1-a23f0854e0d1'	---and CRENoteID = '10640'	
Group by NoteID, Type, date, te.AnalysisID ,a.Name ,CREDealID,DealName,CRENoteID,acc.name ,cr.Calc_Status,cr.CalcEngineType,n.ClosingDate,n.ActualPayoffDate,lds.name
--Order by CREDealID,CRENoteID,Date,Type