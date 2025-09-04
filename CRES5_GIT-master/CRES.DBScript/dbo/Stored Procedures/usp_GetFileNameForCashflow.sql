

--[dbo].[usp_GetFileNameForCashflow]  107,'Delphi I','CA','Realized',''

CREATE PROCEDURE [dbo].[usp_GetFileNameForCashflow]
	@XIRRConfigID int,
	@GValue1 nvarchar(256) = null,
	@GValue2 nvarchar(256) = null,
	@LoanStatus nvarchar(256) = null,
	@Type nvarchar(256) = null
AS  
BEGIN    
  
SET NOCOUNT ON; 

Declare @AnalysisID nvarchar(256) =(Select analysisid from cre.xirrconfig where XIRRConfigID = @XIRRConfigID)

Declare @Group1_LableName nvarchar(256)
Declare @Group2_LableName nvarchar(256)
Declare @Group1_ColumnAliasName nvarchar(256)
Declare @Group2_ColumnAliasName nvarchar(256)
Declare @XIRRConfigType nvarchar(256)

Select @Group1_LableName = g1.Name 
,@Group2_LableName = g2.Name 
,@AnalysisID = xc.AnalysisID
,@Group1_ColumnAliasName = g1.[ReferenceColumnAliasName] 
,@Group2_ColumnAliasName = g2.[ReferenceColumnAliasName] 
,@XIRRConfigType = xc.[Type]
from cre.xirrconfig xc 
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
Where xc.xirrconfigID = @XIRRConfigID

Declare @query_Where nvarchar(MAX) = ''


IF(@GValue1 is not null)
BEGIN
	SET @query_Where = N' and '+CAst(@Group1_ColumnAliasName as nvarchar(256)) +' in (''' + CAst(@GValue1 as nvarchar(256))+ ''')'
END
IF(@GValue2 is not null)
BEGIN
	SET @query_Where = @query_Where + N' and '+CAst(@Group2_ColumnAliasName as nvarchar(256)) +' in (''' + CAst(@GValue2 as nvarchar(256))+ ''')'
END



IF(@query_Where IS NULL)
	SET @query_Where = ''


Declare @g2_query nvarchar(MAX) = ' '

IF(@LoanStatus is not null)
BEGIN
	SET @g2_query  = ' and xrg.LoanStatus = '''+Cast(@LoanStatus as nvarchar(256))+'''  '
END

IF(@Type is not null)
BEGIN
	SET @g2_query = @g2_query + ' and xrg.[Type] = '''+Cast(@Type as nvarchar(256))+'''   '
END
ELSE
BEGIN
	SET @g2_query = @g2_query + ' and xrg.[Type] = '''+Cast(@XIRRConfigType as nvarchar(256))+'''   '
END


print(@g2_query)

Declare @query nvarchar(MAX)
Declare @query1 nvarchar(MAX)

IF (@XIRRConfigType = 'Portfolio')
BEGIN
SET @query1 = N'SELECT Distinct x.XIRRConfigID,x.XIRRReturnGroupID,xrg.FileName_Input,xrg.[Type]		
	FROM [CRE].[XIRROutputPortfolioLevel] x
	Inner join cre.XIRRConfig xc on xc.XIRRConfigID = x.XIRRConfigID
	Inner Join cre.XIRRReturnGroup xrg on xrg.XIRRConfigID = x.XIRRConfigID and xrg.XIRRReturnGroupID = x.XIRRReturnGroupID
	--JOIN CRE.Deal d on d.AccountID=x.dealAccountID
	JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
	Left Join(
		Select Distinct xi.XIRRConfigID	,xi.XIRRReturnGroupID,xi.[Type],xi.AnalysisID,xi.DealAccountID,xi.PoolID,xi.ProductTypeID,xi.[State],xi.DealTypeID,lpool.name as PoolName,lprop.PropertyTypeMajorDesc as ProductType		
		,ldt.DealTypeName as DealType,xi.LoanStatus,xi.VintageYear,xi.MSA
		from (
			Select xii.XIRRConfigID	,xii.XIRRReturnGroupID,xii.[Type],xii.AnalysisID,xii.NoteAccountID,xii.DealAccountID,xii.PoolID,xii.ProductTypeID,xii.[State],xii.DealTypeID,xii.LoanStatus,xii.VintageYear,xii.MSA 
			from cre.XIRRCalculationInput xii
			WHERE xii.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
			and xii.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 

			UNION ALL

			Select xii.XIRRConfigID	,xii.XIRRReturnGroupID_ColumnTotal as XIRRReturnGroupID,xii.[Type],xii.AnalysisID,xii.NoteAccountID,xii.DealAccountID,xii.PoolID,xii.ProductTypeID,xii.[State],xii.DealTypeID,xii.LoanStatus,xii.VintageYear,xii.MSA 
			from cre.XIRRCalculationInput xii
			WHERE xii.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
			and xii.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 

			UNION ALL

			Select xii.XIRRConfigID	,xii.XIRRReturnGroupID_RowTotal as XIRRReturnGroupID,xii.[Type],xii.AnalysisID,xii.NoteAccountID,xii.DealAccountID,xii.PoolID,xii.ProductTypeID,xii.[State],xii.DealTypeID,xii.LoanStatus,xii.VintageYear,xii.MSA 
			from cre.XIRRCalculationInput xii
			WHERE xii.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
			and xii.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 

			UNION ALL

			Select xii.XIRRConfigID	,xii.XIRRReturnGroupID_OverallColumnTotal as XIRRReturnGroupID,xii.[Type],xii.AnalysisID,xii.NoteAccountID,xii.DealAccountID,xii.PoolID,xii.ProductTypeID,xii.[State],xii.DealTypeID,xii.LoanStatus,xii.VintageYear,xii.MSA 
			from cre.XIRRCalculationInput xii
			WHERE xii.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
			and xii.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 

			UNION ALL

			Select xii.XIRRConfigID	,xii.XIRRReturnGroupID_OverallTotal as XIRRReturnGroupID,xii.[Type],xii.AnalysisID,xii.NoteAccountID,xii.DealAccountID,xii.PoolID,xii.ProductTypeID,xii.[State],xii.DealTypeID,xii.LoanStatus,xii.VintageYear,xii.MSA 
			from cre.XIRRCalculationInput xii
			WHERE xii.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
			and xii.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 

			UNION ALL

			Select xii.XIRRConfigID	,xii.XIRRReturnGroupID_GroupTotal as XIRRReturnGroupID,xii.[Type],xii.AnalysisID,xii.NoteAccountID,xii.DealAccountID,xii.PoolID,xii.ProductTypeID,xii.[State],xii.DealTypeID,xii.LoanStatus,xii.VintageYear,xii.MSA 
			from cre.XIRRCalculationInput xii
			WHERE xii.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
			and xii.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''
		)xi
		Inner join cre.note n on n.Account_AccountID = xi.NoteAccountID
		Inner join cre.deal d on d.dealid = n.dealid
		Left join core.lookup lpool on lpool.lookupid = n.poolid
		Left join [CRE].[PropertyTypeMajor] lprop on lprop.PropertyTypeMajorID = d.PropertyTypeMajorID
		Left Join cre.DealTypeMaster ldt on ldt.DealTypeMasterID = d.DealTypeMasterID
		WHERE xi.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
		and xi.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 
	)xinp on xinp.XIRRConfigID = x.XIRRConfigID and xinp.XIRRReturnGroupID = x.XIRRReturnGroupID 
	WHERE x.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
	and x.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 
	'+ISNULL(@g2_query,'')+'
	'
END
IF (@XIRRConfigType = 'Deal')
BEGIN
SET @query1 = N'SELECT Distinct x.XIRRConfigID,x.XIRRReturnGroupID,xrg.FileName_Input		
	FROM [CRE].[XIRROutputDealLevel] x
	Inner join cre.XIRRConfig xc on xc.XIRRConfigID = x.XIRRConfigID
	Inner Join cre.XIRRReturnGroup xrg on xrg.XIRRConfigID = x.XIRRConfigID and xrg.XIRRReturnGroupID = x.XIRRReturnGroupID
	JOIN CRE.Deal d on d.AccountID=x.dealAccountID
	JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
	Left Join(
		Select Distinct xi.XIRRConfigID	,xi.XIRRReturnGroupID,xi.[Type],xi.AnalysisID,xi.DealAccountID,xi.PoolID,xi.ProductTypeID,xi.[State],xi.DealTypeID,lpool.name as PoolName,lprop.PropertyTypeMajorDesc as ProductType		
		,ldt.DealTypeName as DealType,xi.LoanStatus,xi.VintageYear,xi.MSA
		from cre.XIRRCalculationInput xi
		Inner join cre.note n on n.Account_AccountID = xi.NoteAccountID
		Inner join cre.deal d on d.dealid = n.dealid
		Left join core.lookup lpool on lpool.lookupid = n.poolid
		Left join [CRE].[PropertyTypeMajor] lprop on lprop.PropertyTypeMajorID = d.PropertyTypeMajorID
		Left Join cre.DealTypeMaster ldt on ldt.DealTypeMasterID = d.DealTypeMasterID
		WHERE xi.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
		and xi.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 
	)xinp on xinp.XIRRConfigID = x.XIRRConfigID and xinp.DealAccountID = x.DealAccountID 
	WHERE x.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
	and x.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+''' 
	'+ISNULL(@g2_query,'')+'
	'
END



	SET @query = (@query1) +' '+ @query_Where 
	
	Print(@query)
	EXEC(@query)

END






