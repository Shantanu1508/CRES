CREATE PROCEDURE [dbo].[usp_GetXIRRInputByConfigID] --32,''
(
	@XIRRConfigID int,
	@UserID nvarchar(256)
)
AS
BEGIN

	Select  --ReturnName,a.Name as Senario,
	d.DealName,
	cast(d.CREDealID as nvarchar) as DealID,
	cast(n.CRENoteID as nvarchar) as NoteID,
	ac.Name
	,TransactionDate
	,Amount
	,TransactionType
	,xc.SpreadPercentage as  Spread  
	,xc.[OriginalIndex]  as  [Original Index]
	,xc.[IndexValue]  as  [Index Value]
	,xc.[EffectiveRate]  as  [Effective Rate]
	,xc.RemitDate as [Remit Date]
	,xc.[FeeName] as [Fee Name]
	,n.ActualPayOffDate
	--,Cast(Format(n.ActualPayOffDate,'MM/dd/yyyy') as nvarchar(256)) as ActualPayOffDate
	,lpool.name as PoolName
	,lprop.PropertyTypeMajorDesc as ProductType
	,[StateFromProperty] as [State]
	,ldt.DealTypeName as DealType
	,(CASE WHEN tblActivedeal.dealid IS NOT NULL THEN 'Unrealized' ELSE 'Realized' END) as LoanStatus
	,d.MSA_NAME  as MSA   
	,YEAR(d.InquiryDate) as VintageYear
	--,Cast(Format(TransactionDate,'MM/dd/yyyy') as nvarchar(256)) as TransactionDate 
	
	From [CRE].[XIRRInputCashflow] xc
	LEFT JOIN [CORE].[Analysis] a on a.AnalysisID = xc.AnalysisID
	LEFT JOIN [CRE].[Deal] d on d.AccountID = xc.DealAccountID
	LEFT JOIN [CORE].[Account] ac on ac.AccountID = xc.NoteAccountID
	LEFT JOIN [CRE].[Note] n on n.Account_AccountID = xc.NoteAccountID
	Left join core.lookup lpool on lpool.lookupid = n.poolid
	Left join [CRE].[PropertyTypeMajor] lprop on lprop.PropertyTypeMajorID = d.PropertyTypeMajorID
	Left Join cre.DealTypeMaster ldt on ldt.DealTypeMasterID = d.DealTypeMasterID
	Left Join(
		Select Distinct d.dealid,n.actualPayoffdate
		from cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		Where acc.isdeleted <> 1 and n.actualPayoffdate is null
	)tblActivedeal on tblActivedeal.DealID = d.DealID
	where XIRRConfigID = @XIRRConfigID
	Order by DealName,NoteID,TransactionDate,TransactionType

	--ReturnName,a.Name,
END
