-- View
CREATE VIEW [dbo].[vw_Recon_PortfolioReconSum]
AS

Select d.DealName, d.CreDealID, n.CRENoteID, ISNULL(a.Type,b.type) as [Type],SUM(DevAmount) as DevAmount ,SUM(StgAmount) as StagAmount, 
(ISNULL(SUM(DevAmount),0)- ISNULL(SUM(StgAmount),0)) as Delta,
ABS((ISNULL(SUM(DevAmount),0)- ISNULL(SUM(StgAmount),0))) as ABS_Delta, n.ActualPayoffDate, c.Status as Calculation_Status,EndTime as CalculatedOn, le.Name as EnableM61Calculations, (Select Name from core.analysis where analysisid = 'C10f3372-0fc2-4861-a9f5-148f1f80804f') as Scenario
from (
	Select n.NoteID, Type, SUM(Amount) as DevAmount,AnalysisID  
	from Cre.TransactionEntry te
	Inner Join Cre.Note N on N.Account_Accountid = te.AccountID	

	Where AnalysisID='C10f3372-0fc2-4861-a9f5-148f1f80804f'
	Group by NoteID, Type,  AnalysisID 
) a
full outer join (
	Select NoteID, Type, SUM(Amount) as StgAmount, AnalysisID 
	from Dw.Staging_TransactionEntry ste
	Where AnalysisID='C10f3372-0fc2-4861-a9f5-148f1f80804f'
	Group by NoteID, Type, AnalysisID 
) b on a.NoteID=b.NoteID and a.Type=b.type 

left join cre.Note n on n.NoteID=ISNULL(a.NoteID ,b.noteid)
left join core.account acc on acc.accountID=n.account_accountID
left join cre.Deal d on d.DealID=n.DealID
left join core.Lookup le on le.LookupID=n.EnableM61Calculations
left join (
	Select CreNoteID, l.Name as Status, EndTime from cre.Note n
	left join core.CalculationRequests cr on n.Account_AccountID=cr.AccountId
	left join core.Lookup l on l.LookupID=cr.StatusID 
	Where cr.AnalysisID='C10f3372-0fc2-4861-a9f5-148f1f80804f') c on c.CRENoteID=n.CRENoteID

Where acc.isdeleted <> 1 and iSNULL(a.AnalysisID,b.AnalysisID) ='C10f3372-0fc2-4861-a9f5-148f1f80804f' 
--and n.EnableM61Calculations=3
and ABS((ISNULL((DevAmount),0)- ISNULL((StgAmount),0))) > 0
and ISNULL(a.Type,b.type) Not in ( 'EndingPVGAAPBookValue') 
--and ISNULL(a.Type,b.type) in ( 'FundingOrRepayment', 'InitialFunding')
--and n.CRENoteID in ('14356')
--and d.CREDealID='17-0435'
--and c.Status like '%Failed%'
Group by d.DealName,d.CreDealID, n.CRENoteID, ISNULL(a.Type,b.type), le.Name,  n.ActualPayoffDate, c.Status , n.EnableM61Calculations,EndTime
--Order by d.DealName, CRENoteID, Type

