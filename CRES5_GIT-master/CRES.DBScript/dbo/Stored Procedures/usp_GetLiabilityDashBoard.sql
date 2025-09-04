---[dbo].[usp_GetLiabilityDashBoard]  '05A96B38-8B22-47B2-AA06-6C84F63C9C67'

CREATE PROCEDURE [dbo].[usp_GetLiabilityDashBoard]  
(  	
	@EquityAccountID UNIQUEIDENTIFIER = null
)     
AS  
BEGIN  
 SET NOCOUNT ON;

IF(@EquityAccountID is  null)
BEGIN
	SET @EquityAccountID = '00000000-0000-0000-0000-000000000000'
END

IF OBJECT_ID('tempdb..#tblliabilityNoteAccountID') IS NOT NULL         
	DROP TABLE #tblliabilityNoteAccountID

CREATE table #tblliabilityNoteAccountID(
	EquityAccountID	UNIQUEIDENTIFIER,
	LiabilityNoteAccountId	UNIQUEIDENTIFIER,
	DealAccountID	UNIQUEIDENTIFIER,
	LiabilityNoteID	nvarchar(256),
	LiabilityTypeID	UNIQUEIDENTIFIER,
	LiabilityTypeName	nvarchar(256),
	Ac_Category nvarchar(256),
	LibFlag nvarchar(256),
	PledgeDate date
)



INSERT INTO #tblliabilityNoteAccountID(EquityAccountID,LiabilityNoteAccountId,DealAccountID,LiabilityNoteID,LiabilityTypeID,LiabilityTypeName,Ac_Category,LibFlag,PledgeDate)
SELECT Distinct sub.LiabilityTypeID as EquityAccountID,ln.AccountID as LiabilityNoteAccountId,ln.DealAccountID,ln.LiabilityNoteID,ln.LiabilityTypeID,tblLibtype.[LiabilityTypeName],tblLibtype.Ac_Category,tblLibtype.LibFlag,ln.PledgeDate
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
	SELECT l.LiabilityTypeID,am.AssetAccountId AS assetnotesid
	FROM cre.liabilitynote l
	INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
	WHERE l.LiabilityTypeID in (Select accountid from cre.equity)
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID

Left Join(  
	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Debt' as LibFlag,ac.name as Ac_Category
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	
	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Equity' as LibFlag,ac.name as Ac_Category 
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	
	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Cash' as LibFlag,ac.name as Ac_Category
	from cre.CASH ch 
	Inner Join core.Account acc on acc.AccountID =  ch.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
where a.IsDeleted <> 1
---=======================




Select eq.AccountID,acc.Name as Equity,ac.name as [Type],d.DealName,dt.LiabilityTypeName as Debt,ISNULL(dt.PledgeDate,tblsub.PledgeDate) as PledgeDate,dt.Ac_Category as DebtType,tblsub.LiabilityTypeName as Subline

from cre.equity eq
Inner Join core.account acc on acc.accountid = eq.accountid
Left Join core.AccountCategory ac on ac.AccountCategoryID = acc.accounttypeid
Left Join cre.LiabilityNote ln on ln.LiabilityTypeID = eq.AccountID
left join cre.deal d on d.AccountID = ln.DealAccountID

Left Join(
	Select EquityAccountID,LiabilityNoteAccountId,DealAccountID,LiabilityNoteID,LiabilityTypeID,LiabilityTypeName,Ac_Category,LibFlag,PledgeDate
	From #tblliabilityNoteAccountID
	Where LibFlag = 'Debt'
	and Ac_Category <> 'subline'
)dt on dt.EquityAccountID = eq.AccountID and dt.DealAccountID = d.AccountID

Left Join(
	Select EquityAccountID,LiabilityNoteAccountId,DealAccountID,LiabilityNoteID,LiabilityTypeID,LiabilityTypeName,Ac_Category,LibFlag,PledgeDate
	From #tblliabilityNoteAccountID
	Where LibFlag = 'Debt'
	and Ac_Category = 'subline'
)tblsub on tblsub.EquityAccountID = eq.AccountID and tblsub.DealAccountID = d.AccountID

where acc.isdeleted <> 1
and 1 = (CASE WHEN @EquityAccountID = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @EquityAccountID <> '00000000-0000-0000-0000-000000000000' and eq.AccountID = @EquityAccountID THEN 1 END)


order by acc.Name,d.DealName



END