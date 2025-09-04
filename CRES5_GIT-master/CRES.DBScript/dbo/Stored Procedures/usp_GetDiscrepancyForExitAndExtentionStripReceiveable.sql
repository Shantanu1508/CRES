-- Procedure
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForExitAndExtentionStripReceiveable] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
	
IF OBJECT_ID('tempdb..#tblTranDiscre') IS NOT NULL         
	DROP TABLE #tblTranDiscre

CREATE TABLE #tblTranDiscre(  
scenario nvarchar(256),
AccountID	UNIQUEIDENTIFIER,
analysisid	UNIQUEIDENTIFIER,
dealid	nvarchar(256),
amount decimal(28,15),
[type] nvarchar(256)
)
INSERT INTO #tblTranDiscre(scenario,AccountID,analysisid,dealid,amount,[type])
Select a.Name,tr.AccountID,tr.analysisid,d.dealid,tr.amount,tr.[type]
from cre.Transactionentry tr
Inner join core.Account acc on acc.AccountID = tr.AccountID
inner join cre.note n on n.Account_AccountID = acc.AccountID
inner join cre.deal d on N.Dealid = D.Dealid
Inner join core.Analysis a on a.AnalysisID = tr.AnalysisID
INNER JOIN CORE.AnalysisParameter AP ON AP.AnalysisID = a.AnalysisID
where acc.AccountTypeID = 1
and acc.IsDeleted <> 1 and d.IsDeleted <> 1
and [type] in ('ExtensionFeeStrippingExcldfromLevelYield','ExtensionFeeStripReceivable','ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable','OriginationFeeStripping','OriginationFeeStripReceivable')
AND AP.IncludeInDiscrepancy=3
 
 ---=========================================


Select  Scenario,DealName as [Deal Name],
		DealID as [Deal ID],
		REPLACE('$' + ISNULL(CONVERT(varchar , CAST(ExtentionFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [ExtentionFeeStrip + Receivable],
		REPLACE('$' + ISNULL(CONVERT(varchar , CAST(ExitFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [ExitFeeStrip + Receivable] ,
		REPLACE('$' + ISNULL(CONVERT(varchar , CAST(OriginationFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [OriginationFeeStrip + Receivable]
		
from (

	Select Distinct scenario,d.credealid as dealid,d.dealname,tblExtentionfee.ExtentionFee,tblExitfee.ExitFee,tblOriginationFee.OriginationFee 
	from #tblTranDiscre tr
	Inner join core.Account acc on acc.AccountID = tr.AccountID
	inner join cre.note n on n.Account_AccountID = acc.AccountID
	inner join cre.deal d on N.DealID = D.DealID
	left join core.Lookup lStatus on lStatus.LookupID= d.[Status]

	left join(
		Select tr.analysisid,tr.dealid,SUM(tr.amount) as ExtentionFee 
		from #tblTranDiscre tr
		where [type] in ('ExtensionFeeStrippingExcldfromLevelYield','ExtensionFeeStripReceivable')
		group by tr.dealid,tr.AnalysisID
	)as tblExtentionfee on tblExtentionfee.dealid = d.dealid and tblExtentionfee.AnalysisID = tr.AnalysisID

	left join(
		Select tr.analysisid,tr.dealid,SUM(tr.amount) as ExitFee 
		from #tblTranDiscre tr
		where [type] in ('ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable')
		group by tr.dealid,tr.AnalysisID		
	)as tblExitfee on tblExitfee.dealid = d.dealid and tblExitfee.AnalysisID = tr.AnalysisID

	left join(
		Select tr.analysisid,tr.dealid,SUM(tr.amount) as OriginationFee 
		from #tblTranDiscre tr
		where [type] in ('OriginationFeeStripping','OriginationFeeStripReceivable')
		group by tr.dealid,tr.AnalysisID		
	)as tblOriginationFee on tblOriginationFee.dealid = d.dealid and tblOriginationFee.AnalysisID = tr.AnalysisID

	where lStatus.[Name] = 'Active'
	and  d.CREDealID in (Select Distinct d1.credealid from cre.deal d1
	inner join cre.note n on n.dealid = d1.dealid
	where n.Actualpayoffdate is null and d1.[Status] = 323)
	AND d.DealName NOT LIKE '%copy%'

	--And scenario = 'Default' --and type like '%exten%'
)a
where ROUND(ExtentionFee,2) <> 0 or ROUND(ExitFee,2) <> 0 or ROUND(OriginationFee,2) <> 0 
order by scenario,DealName


 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END     