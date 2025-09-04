--[dbo].[usp_GetXIRROutputPortfolioLevel]  137,'B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_GetXIRROutputPortfolioLevel]  
	@XIRRConfigID int,
	@UserID nvarchar(256)
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


---Declare @XIRRConfigID int = 9
Declare @AnalysisID nvarchar(256) =(Select analysisid from cre.xirrconfig where XIRRConfigID = @XIRRConfigID)
---Declare @UserID nvarchar(256) = @UserID ---'B0E6697B-3534-4C09-BE0A-04473401AB93'


Declare @Group1_LableName nvarchar(256)
Declare @Group2_LableName nvarchar(256)
Declare @Group1_ColumnAliasName nvarchar(256)
Declare @Group2_ColumnAliasName nvarchar(256)


Select @Group1_LableName = g1.Name 
,@Group2_LableName = g2.Name 
,@AnalysisID = xc.AnalysisID
,@Group1_ColumnAliasName = g1.[ReferenceColumnAliasName] 
,@Group2_ColumnAliasName = g2.[ReferenceColumnAliasName] 
from cre.xirrconfig xc 
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
Where xc.xirrconfigID = @XIRRConfigID


--Select Group1_LableName = g1.Name 
--,Group2_LableName = g2.Name 
--,AnalysisID = xc.AnalysisID
--,Group1_ColumnAliasName = g1.[ReferenceColumnAliasName] 
--,Group2_ColumnAliasName = g2.[ReferenceColumnAliasName] 
--from cre.xirrconfig xc 
--left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
--left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
--Where xc.xirrconfigID = @XIRRConfigID
--------------------------------------------------

Declare @g2_query nvarchar(256) = '(CASE WHEN Group2 = '''+@Group2_LableName+''' THEN (CASE WHEN [Type] in ( ''Portfolio_RowTotal'',''Portfolio_OverallTotal'',''Portfolio_GroupTotal'') THEN ''Total'' ELSE '+@Group2_ColumnAliasName+' END) ELSE '''' END) '

Declare @queryFinal nvarchar(MAX)
Declare @query1 nvarchar(MAX)
Declare @query2 nvarchar(MAX)

SET @query1 = N'
Select Distinct XIRROutputPortfolioLevelID,XIRRConfigID,XIRRReturnGroupID,XIRRValue,ReturnName,ChildReturnName,LoanStatus--,Group1,Group2
,(CASE WHEN Group1 = '''+@Group1_LableName+''' THEN (CASE WHEN [Type] in ( ''Portfolio_OverallTotal'',''Portfolio_OverallColumnTotal'') THEN ''OverallTotal''ELSE cast('+@Group1_ColumnAliasName+'  as nvarchar(256)) END) ELSE '''' END) as [G1_Hidden]
,(CASE WHEN Group1 = '''+@Group1_LableName+''' THEN (CASE WHEN [Type] in ( ''Portfolio_OverallTotal'',''Portfolio_OverallColumnTotal'') THEN ''OverallTotal''ELSE cast('+@Group1_ColumnAliasName+'  as nvarchar(256)) END) ELSE '''' END) as [Y_Axis]
,'+ISNULL(@g2_query,'(CASE WHEN [Type] in ( ''Portfolio_RowTotal'',''Portfolio_OverallTotal'',''Portfolio_GroupTotal'') THEN ''Total'' ELSE ''XIRR'' END)')+'  as [X_Axis]
from(
	Select  
	 xop.XIRROutputPortfolioLevelID
	,xop.XIRRConfigID
	,xop.XIRRReturnGroupID
	,xop.XIRRValue
	,xop.AnalysisID
	,xi.ReturnName
	,xi.ChildReturnName
	--,lpool.name as PoolName
	,xi.PoolName
	,lprop.PropertyTypeMajorDesc as ProductType
	--,[StateFromProperty] as [State]
	,xi.[State]
	,ldt.DealTypeName as DealType
	,g1.Name as Group1
	,g2.Name as Group2
	,xi.LoanStatus
	,YEAR(d.InquiryDate) as VintageYear
	,xi.MSA
	,xr.[Type]
	from  [CRE].[XIRROutputPortfolioLevel] xop
	Inner JOin (	
			Select XIRRConfigID,AnalysisID,NoteAccountID,ReturnName,ChildReturnName,Group1,Group2,XIRRReturnGroupID,LoanStatus,MSA,VintageYear ,PoolID,lpool.name as [PoolName],[State]
			from cre.XIRRCalculationInput xii
			Left join core.lookup lpool on lpool.lookupid = xii.poolid
			where XIRRConfigID ='''+Cast(@XIRRConfigID as nvarchar(256))+'''		

			UNION
		
			Select XIRRConfigID,AnalysisID,NoteAccountID,ReturnName,ChildReturnName_ColumnTotal as ChildReturnName,Group1,Group2,XIRRReturnGroupID_ColumnTotal as XIRRReturnGroupID,''ColumnTotal'' as LoanStatus,MSA,VintageYear ,PoolID,lpool.name as [PoolName],[State]
			from cre.XIRRCalculationInput xii
			Left join core.lookup lpool on lpool.lookupid = xii.poolid
			where XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''
		
			UNION
		
			Select XIRRConfigID,AnalysisID,NoteAccountID,ReturnName,ChildReturnName_RowTotal as ChildReturnName,Group1,Group2,XIRRReturnGroupID_RowTotal as XIRRReturnGroupID,LoanStatus,MSA,VintageYear ,PoolID,lpool.name  as [PoolName],[State]
			from cre.XIRRCalculationInput xii
			Left join core.lookup lpool on lpool.lookupid = xii.poolid
			where XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''
		
			UNION
		
			Select XIRRConfigID,AnalysisID,NoteAccountID,ReturnName,ChildReturnName_OverallTotal as ChildReturnName,Group1,Group2,XIRRReturnGroupID_OverallTotal as XIRRReturnGroupID,''OverallTotal''  as LoanStatus,MSA,VintageYear ,PoolID,lpool.name as [PoolName],[State]
			from cre.XIRRCalculationInput xii
			Left join core.lookup lpool on lpool.lookupid = xii.poolid
			where XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''

			UNION
		
			Select XIRRConfigID,AnalysisID,NoteAccountID,ReturnName,ChildReturnName_OverallColumnTotal as ChildReturnName,Group1,Group2,XIRRReturnGroupID_OverallColumnTotal as XIRRReturnGroupID,''OverallTotal''  as LoanStatus,MSA,VintageYear ,PoolID,lpool.name as [PoolName],[State]
			from cre.XIRRCalculationInput xii
			Left join core.lookup lpool on lpool.lookupid = xii.poolid
			where XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''

			UNION
		
			Select XIRRConfigID,AnalysisID,NoteAccountID,ReturnName,ChildReturnName_GroupTotal as ChildReturnName,Group1,Group2,XIRRReturnGroupID_GroupTotal as XIRRReturnGroupID,''ColumnTotal''  as LoanStatus,MSA,VintageYear ,PoolID,lpool.name as [PoolName],[State]
			from cre.XIRRCalculationInput xii
			Left join core.lookup lpool on lpool.lookupid = xii.poolid
			where XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''
	
	)xi on xi.AnalysisID = xop.AnalysisID and xi.XIRRConfigID = xop.XIRRConfigID and xi.XIRRReturnGroupID = xop.XIRRReturnGroupID'

	SET @query2 = N'
	Inner join cre.note n on n.Account_AccountID = xi.NoteAccountID
	Inner join cre.deal d on d.dealid = n.dealid
	Left join core.lookup lpool on lpool.lookupid = n.poolid
	Left join [CRE].[PropertyTypeMajor] lprop on lprop.PropertyTypeMajorID = d.PropertyTypeMajorID
	Left Join cre.DealTypeMaster ldt on ldt.DealTypeMasterID = d.DealTypeMasterID
	left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xi.Group1
	left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xi.Group2
	Inner join cre.XIRRReturnGroup xr on xr.XIRRConfigID = xop.XIRRConfigID and xr.XIRRReturnGroupID = xop.XIRRReturnGroupID
	where  xop.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''
	and xop.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''
)z'

Print(@query1)
Print(@query2)

SET @queryFinal = @query1 + @query2




IF OBJECT_ID('tempdb..#tblXIRROutput') IS NOT NULL         
	DROP TABLE #tblXIRROutput

CREATE TABLE #tblXIRROutput( 
	XIRROutputPortfolioLevelID	int,
	XIRRConfigID	int,
	XIRRReturnGroupID	int,
	XIRRValue	decimal(28,15),
	ReturnName	nvarchar(256),
	ChildReturnName	nvarchar(256),
	LoanStatus nvarchar(256),
	G1_Hidden nvarchar(256),
	Y_Axis	nvarchar(256),
	X_Axis	nvarchar(256)
)

INSERT INTO #tblXIRROutput(XIRROutputPortfolioLevelID,XIRRConfigID,XIRRReturnGroupID,XIRRValue,ReturnName,ChildReturnName,LoanStatus,G1_Hidden,Y_Axis,X_Axis)
EXEC(@queryFinal)


DEclare @ColPivot_ISNULL nvarchar(max)
SET @ColPivot_ISNULL = STUFF((SELECT  ',ISNULL(' + QUOTENAME(cast(X_Axis as nvarchar(256)) ) +',0) as ' + QUOTENAME(cast(X_Axis as nvarchar(256)) )   
		from (
			Select Distinct ISNULL(X_Axis,0) as X_Axis from #tblXIRROutput 
		)a	
		Order by (CASE WHEN X_Axis = 'Total' THEN 'zzz' ELSE X_Axis END)
    FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)')       
   ,1,1,'') 

DEclare @ColPivot nvarchar(max)
SET @ColPivot = STUFF((SELECT  ',' + QUOTENAME(cast(X_Axis as nvarchar(256)) ) 
		from (
			Select Distinct ISNULL(X_Axis,0) as X_Axis from #tblXIRROutput 
		)a	
		Order by (CASE WHEN X_Axis = 'Total' THEN 'zzz' ELSE X_Axis END)
    FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)')       
   ,1,1,'')

Declare @queryPivot nvarchar(MAX)
SET @queryPivot = N'SELECT XIRRConfigID,ReturnName,G1_Hidden,Y_Axis,LoanStatus,'+@ColPivot_ISNULL+' FROM   
(
    Select XIRRConfigID,ReturnName,LoanStatus,XIRRValue,G1_Hidden,Y_Axis,X_Axis from #tblXIRROutput
) t 
PIVOT(
    SUM(XIRRValue) 
    FOR X_Axis IN ('+@ColPivot+')
) AS pivot_table
Order by (CASE WHEN Y_Axis = ''OverallTotal'' THEN ''zzz'' ELSE Y_Axis END),
(CASE WHEN LoanStatus = ''Realized'' THEN 1
WHEN LoanStatus = ''Unrealized'' THEN 2
WHEN LoanStatus = ''ColumnTotal'' THEN 3
WHEN LoanStatus = ''OverallTotal'' THEN 4
ELSE 99 END)'

Print(@queryPivot)
EXEC(@queryPivot)


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END