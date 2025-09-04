
CREATE VIEW [dbo].[vw_Transaction_DefaultVsFullyExtended_With_FWCV]
AS
	Select  a.AnalysisName as AnalysisDefault,b.AnalysisName as AnalysisOther
,d.DealName,d.CREDealID, n.CRENoteID, ISNULL(a.Type,b.type) as [Type],a.date as Default_Date, b.date as Other_Date, Default_Amount,Other_Amount, 
(ISNULL(Default_Amount,0)- ISNULL(Other_Amount,0)) as Delta,
ABS((ISNULL(Default_Amount,0)- ISNULL(Other_Amount,0))) as ABS_Delta,n.ClosingDate, ISNULL(n.ActualPayoffDate,'') as PayoffDate
from (
	Select n.NoteID, Type, date,SUM(Amount) as Default_Amount,te.AnalysisID,a.name as AnalysisName
	from Cre.TransactionEntry te
	Inner Join cre.note n on n.account_accountid = te.AccountID
	Inner join core.account acc on acc.accountid = n.account_accountid
	Inner join core.Analysis a on a.AnalysisID = te.AnalysisID
	Inner JOIN(
		Select transactionname from cre.TransactionTypes where Cash_NonCash = 'Cash'
	)tr on tr.TransactionName = te.[Type]
	Where te.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and acc.statusID <> 2
	and te.Date <= CAST(getdate() as date)
	--and n.crenoteid = '11736'
	Group by n.NoteID, Type, date, te.AnalysisID ,a.name
) a
full outer join (
	Select NoteID, Type,date, SUM(Amount) as Other_Amount, ste.AnalysisID,a.name as AnalysisName
	from Cre.TransactionEntry ste
	Inner Join cre.note n on n.account_accountid = ste.AccountID
	Inner join core.account acc on acc.accountid = n.account_accountid
	Inner join core.Analysis a on a.AnalysisID = ste.AnalysisID
	Inner JOIN(
		Select transactionname from cre.TransactionTypes where Cash_NonCash = 'Cash'
	)tr on tr.TransactionName = ste.[Type]
	Where ste.AnalysisID='45cf083b-4755-4a8c-982a-7dc6d7b8e5f2'
	and acc.statusID <> 2
	and ste.Date <= CAST(getdate() as date)
	--and n.crenoteid = '11736'
	Group by NoteID, Type,date, ste.AnalysisID 	,a.name
) b on a.NoteID=b.NoteID and a.Type=b.type and a.date=b.date
 
left join cre.Note n on n.NoteID=ISNULL(a.NoteID ,b.noteid)
left join core.account acc on acc.accountID=n.account_accountID
left join cre.Deal d on d.DealID=n.DealID
left join core.Lookup le on le.LookupID=n.EnableM61Calculations
left join core.Lookup l2 on l2.LookupID=acc.StatusID
left join core.Lookup l3 on l3.LookupID=d.CalcEngineType

Where acc.isdeleted <> 1 
and (iSNULL(a.AnalysisID,b.AnalysisID) = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  OR iSNULL(a.AnalysisID,b.AnalysisID) ='726671FA-16A9-44F6-AF71-5D54492E7E82')
and n.EnableM61Calculations=3
and ABS((ISNULL(Default_Amount,0)- ISNULL(Other_Amount,0))) > 0.1
and d.DealName not like '%Copy%'