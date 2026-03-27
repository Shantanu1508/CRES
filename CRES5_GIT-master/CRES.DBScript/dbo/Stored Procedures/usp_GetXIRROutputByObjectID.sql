-- Procedure
--[dbo].[usp_GetXIRROutputByObjectID] 'deal','044AF32F-7AD6-4125-8A4D-C0C68A2A6163'
--usp_GetXIRROutputByObjectID 'Deal','ffa5b824-e440-4c74-9b77-e9cf11332919'

CREATE PROCEDURE [dbo].[usp_GetXIRROutputByObjectID] 
(
	@ObjectType nvarchar(256),
	@ObjectID nvarchar(256)
	
)
AS
BEGIN


Declare @tblDealAccountID as Table(
	DealAccountID UNIQUEIDENTIFIER
)
INSERT INTO @tblDealAccountID(DealAccountID)
Select DealAccountID
From(
	Select @ObjectID as DealAccountID
	UNION 

	Select AccountID as DealAccountID
	from cre.deal where nullif(LinkedDealIDXIRR,'') in (Select credealid from cre.deal where IsDeleted <> 1 and AccountID = @ObjectID)
)a
---------------------------------

Declare @tblXIRRConfigDetail as Table(
XIRRConfigID	int,
ObjectType	nvarchar(256),
ObjectText nvarchar(MAX)

)

INSERT INTO @tblXIRRConfigDetail(XIRRConfigID,ObjectType,ObjectText)
Select XIRRConfigID,ObjectType,ObjectText from (

Select Distinct xd.XIRRConfigID,xd.ObjectType,tx.Name as [ObjectText]
from cre.XIRRConfigDetail xd 
left join cre.TagMasterXIRR tx on tx.TagMasterXIRRID = xd.ObjectID
where xd.ObjectType = 'Tag'

UNION ALL

Select Distinct xd.XIRRConfigID,xd.ObjectType,ty.TransactionName as [ObjectText]
from cre.XIRRConfigDetail xd 
left join cre.TransactionTypes ty on ty.TransactionTypesID = xd.ObjectID 
where xd.ObjectType = 'Transaction'

)a
ORDER BY XIRRConfigID


Declare @tblXIRRCD as Table(
XIRRConfigID	int,
[Tag]	nvarchar(256),
[Transaction] nvarchar(MAX)
)

INSERT INTO @tblXIRRCD(XIRRConfigID,[Tag],[Transaction])
Select XIRRConfigID,[Tag],[Transaction] From(
Select  Distinct XIRRConfigID,ObjectType
,STUFF((
	Select Distinct  ', '  + xd.ObjectText  
	from (
		Select c.ObjectText
		from @tblXIRRConfigDetail c
		Where c.XIRRConfigID = p.XIRRConfigID
			and c.objectType = p.objectType
	)xd
	FOR XML PATH('') ), 1, 1, '')
	as ObjectText

from @tblXIRRConfigDetail p
)z
PIVOT
(
	MAX(ObjectText) FOR ObjectType IN([Tag],[Transaction])
)AS pivot_table

---================================================

Select 
XIRRConfigID
,XIRRReturnGroupID
,ReturnName
,Scenario
,DealID
,DealName
,XIRR
,LoanStatus
,ProductType
,Comments
,PoolName
,State
,DealType
,VintageYear
,MSA
,ClosingDate
,Maturity
,UpdatedDate
,[Status]
,Tags
,ISNULL(IsOverride,0) as IsOverride
,DealAccountID
,GrossMultiples
From(
	SELECT Distinct x.XIRRConfigID,x.XIRRReturnGroupID
	,xc.ReturnName
	,a.name as Scenario
	,d.CREDealID as DealID
	,d.DealName as [DealName]
	,[XIRRValue] as XIRR 
	,xinp.LoanStatus	
	,xinp.ProductType 
	 ,xc.Comments
	--,null as PoolName	
	,STUFF((SELECT ', ' + CAST(PoolName AS VARCHAR(256)) [text()]
	From(
		Select Distinct d1.AccountID,lpool.name  as PoolName
		from cre.note n 
		Inner Join core.account acc on acc.accountid = n.account_accountid		
		Inner join cre.deal d1 on d1.dealid = n.dealid
		Left join core.lookup lpool on lpool.lookupid = n.poolid
		WHERE acc.isdeleted <> 1	
		and d1.AccountID = d.AccountID
	)a
	FOR XML PATH(''), TYPE)
	.value('.','NVARCHAR(MAX)'),1,1,'') PoolName

	,xinp.[State]
	,xinp.DealType
	,xinp.VintageYear as [VintageYear]	
	,xinp.MSA as [MSA]	
	,dl.closingdate as ClosingDate
	,dl.Maturity as Maturity
	,x.UpdatedDate
	,cr.[Status] 

	,xc.UpdateXIRRLinkedDeal
	,d.[Status] as DealStatus
	,(CASE WHEN d.[Status] = 323 THEN 1  WHEN xc.UpdateXIRRLinkedDeal = 3 and d.[Status] = 325 THEN 1 ELSE 0 END) IsShowPhantom
	,tg.Tag  as Tags
	,XovR.IsOverride
	,x.DealAccountID
	,x.MultipleCalculation as GrossMultiples
	FROM [CRE].[XIRROutputDealLevel] x
	Inner join cre.XIRRConfig xc on xc.XIRRConfigID = x.XIRRConfigID
	Inner Join cre.XIRRReturnGroup xrg on xrg.XIRRConfigID = x.XIRRConfigID and xrg.XIRRReturnGroupID = x.XIRRReturnGroupID
	JOIN CRE.Deal d on d.AccountID=x.dealAccountID
	JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
	LEFT JOIN(
		Select d.dealname,d.dealid,MIN(n.closingdate) as closingdate,MAX(ISNULL(n.ActualPayOffDate,n.FullyExtendedMaturityDate)) as Maturity
		from cre.note n
		Inner JOIN CRE.Deal d on d.dealid=n.dealid
		Inner Join core.account acc on acc.accountid = n.account_accountid		
		where acc.isdeleted <> 1	
		GROUP BY d.dealname,d.dealid
	)dl on dl.dealid = d.dealid	
	Left Join(
		Select Distinct xi.XIRRConfigID	,xi.XIRRReturnGroupID,xi.[Type],xi.AnalysisID,xi.DealAccountID,xi.PoolID,xi.ProductTypeID,xi.[State],xi.DealTypeID,lpool.name as PoolName,lprop.PropertyTypeMajorDesc as ProductType		
		,ldt.DealTypeName as DealType,xi.LoanStatus,xi.VintageYear,xi.MSA
		from cre.XIRRCalculationInput xi
		Inner join cre.note n on n.Account_AccountID = xi.NoteAccountID
		Inner join cre.deal d on d.dealid = n.dealid
		Left join core.lookup lpool on lpool.lookupid = n.poolid
		Left join [CRE].[PropertyTypeMajor] lprop on lprop.PropertyTypeMajorID = d.PropertyTypeMajorID
		Left Join cre.DealTypeMaster ldt on ldt.DealTypeMasterID = d.DealTypeMasterID	
		
	)xinp on xinp.XIRRConfigID = x.XIRRConfigID and xinp.DealAccountID = x.DealAccountID 

	Left Join(
		Select DIstinct XIRRConfigID,XIRRReturnGroupID,AnalysisID,Type,DealAccountID,lstatus.name as [Status]
		From [CRE].[XIRRCalculationRequests] t
		Left Join core.lookup lstatus on lstatus.lookupid = t.[Status]
		Where DealAccountID is not null
	)cr on cr.XIRRConfigID = x.XIRRConfigID and cr.DealAccountID = x.DealAccountID and cr.XIRRReturnGroupID = x.XIRRReturnGroupID and cr.AnalysisID = x.AnalysisID 	
	Left Join(
	 Select XIRRConfigID,Tag from @tblXIRRCD
	)tg on tg.XIRRConfigID = x.XIRRConfigID
	LEFT JOIN [CRE].[XIRROverride] XovR ON XovR.XIRRConfigID = x.XIRRConfigID AND XovR.DealAccountID = x.DealAccountID
	WHERE  d.AccountID in (Select DealAccountID from @tblDealAccountID )
	and xc.ShowReturnonDealScreen = 3
)z
Where z.IsShowPhantom = 1
Order By z.ReturnName



--Declare @tblXIRRConfigTags as Table(
--xirrconfigid int,
--Multi_Tags nvarchar(256)
--)

--INSERT INTO @tblXIRRConfigTags(xirrconfigid,Multi_Tags)
--Select xirrconfigid,
--(Select STUFF((
--	Select Distinct  ', '  + tm.Name  
--	from (
--		Select XIRRConfigID,ObjectID as TagMasterXIRR 
--		from [CRE].[XIRRConfigDetail] xcd
--		Where ObjectType = 'Tag' and xcd.xirrconfigid = xm.xirrconfigid
--	)xd
--	Inner join cre.TagMasterXIRR tm on xd.TagMasterXIRR = tm.TagMasterXIRRID
--	FOR XML PATH('') ), 1, 2, '') as a
--	) as Multi_Tags
--from cre.xirrconfig xm
--where xm.xirrconfigid in (Select xirrconfigid from [CRE].[XIRROutput] where objectType = @ObjectType and ObjectID = @ObjectID)

  

--IF (@ObjectType='Deal')
--BEGIN

--	SELECT x.xirrconfigid,x.UpdatedDate as [LastCalculatedDate]
--	,[ReturnName]
--	,isnull(tags.Multi_Tags,'') as Tags	
--	,[XIRRValue] as XIRR	
--	,a.[Name] as Scenario
--	,[Comments]
     
--	FROM [CRE].[XIRROutput] x
--	JOIN CRE.Deal d on d.AccountID=x.ObjectID
--	JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
--	Left join(
--		Select xirrconfigid,Multi_Tags from @tblXIRRConfigTags
--	)tags on tags.xirrconfigid = x.xirrconfigid
--	WHERE x.ObjectType = @ObjectType and ObjectID = @ObjectID


--END
--ELSE IF (@ObjectType='Portfolio')
--BEGIN

--	SELECT x.xirrconfigid,x.UpdatedDate as [LastCalculatedDate]
--	,[ReturnName]
--	,isnull(tags.Multi_Tags,'') as Tags	
--	,[XIRRValue] as XIRR	
--	,a.[Name] as Scenario
--	,[Comments]
     
--	FROM [CRE].[XIRROutput] x
--	JOIN core.PortfolioMaster p on p.PortfolioMasterGuid=x.ObjectID
--	JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
--	Left join(
--		Select xirrconfigid,Multi_Tags from @tblXIRRConfigTags
--	)tags on tags.xirrconfigid = x.xirrconfigid
--	WHERE x.ObjectType = @ObjectType and ObjectID = @ObjectID




--END


END
GO

