CREATE VIEW [dbo].[vw_Recon_StgEnv_TransactionEntry_Default]
AS
Select 
d.credealid,d.dealname,acc.name as NoteName, l.Name as Status, n.CreNoteID as CreNoteID, Date as StgDate, SUM(Amount) as StgAmount, Type as StgType, a.Name as StgScenario
from Dw.Staging_TransactionEntry ste
	Inner JOin cre.note n on n.crenoteid = ste.crenoteid
	Inner join cre.deal d on d.dealid = n.dealid
	Inner join core.account acc on acc.accountid = n.Account_AccountID
	Inner Join core.lookup l on l.LookupID=d.Status
Inner join core.Analysis a on a.AnalysisID = ste.AnalysisID
Where ste.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'
Group by d.credealid,d.dealname,acc.name , l.Name , n.CreNoteID, Date , Type , a.Name