-- Procedure
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForDuplicateTransactions] 
AS
BEGIN
	SET NOCOUNT ON;

Select Distinct z.Scenario,z.DealName,z.credealid as DealID,z.crenoteid as NoteID,lCalcEngineType.name as CalcEngineType  ---z.TransactionType ,
from (
	Select (Select a.name from core.analysis a where a.analysisid = tr.analysisid) as Scenario
	,d.credealid,d.dealid,d.DealName,n.crenoteid,tr.[type] as TransactionType,tr.AnalysisID,tr.AccountID,tr.[Date],COUNT(tr.AccountID) cnt  
	from cre.transactionentry tr
	Inner Join cre.note n on n.Account_accountid = tr.Accountid
	Inner join core.account acc on acc.accountid = n.Account_accountid
	Inner Join cre.deal d on d.dealid = n.dealid
	INNER JOIN CORE.AnalysisParameter AP ON AP.AnalysisID = tr.AnalysisID
	where  acc.isdeleted <> 1 and n.enableM61Calculations = 3
	and [type] in ('InterestPaid','EndingGAAPBookValue')
	AND AP.IncludeInDiscrepancy = 3
	--and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	Group by d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.[type],d.credealid 
	Having COUNT(tr.AccountID) > 1

	UNION
 
	Select (Select a.name from core.analysis a where a.analysisid = tr.analysisid) as Schenario
	,d.credealid,d.dealid,d.DealName,n.crenoteid,tr.[type] as TransactionType,tr.AnalysisID,tr.AccountID,tr.[Date],COUNT(tr.AccountID) cnt  
	from cre.transactionentry tr
	Inner Join cre.note n on n.Account_accountid = tr.Accountid
	Inner join core.account acc on acc.accountid = n.Account_accountid
	Inner Join cre.deal d on d.dealid = n.dealid
	INNER JOIN CORE.AnalysisParameter AP ON AP.AnalysisID = tr.AnalysisID
	where  acc.isdeleted <> 1 and n.enableM61Calculations = 3
	and [type] in ('PIKInterest')
	AND AP.IncludeInDiscrepancy = 3
	--and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	Group by d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.[type],d.credealid ,tr.Comment
	Having COUNT(tr.AccountID) > 1
)z
Inner join core.CalculationRequests cl on cl.accountid = z.accountid and cl.AnalysisID = z.AnalysisID
Left join core.lookup lCalcEngineType on lCalcEngineType.lookupid = cl.CalcEngineType
 

END
GO

