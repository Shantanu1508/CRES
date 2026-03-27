---[dbo].[usp_GetXIRRFilterExtractData]  '56'

CREATE PROCEDURE [dbo].[usp_GetXIRRFilterExtractData]  
	@XIRRConfigID int
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


Declare @AnalysisID UNIQUEIDENTIFIER
Declare @Group1_LableName nvarchar(256)
Declare @Group2_LableName nvarchar(256)
Declare @Group1_ColumnAliasName nvarchar(256)
Declare @Group2_ColumnAliasName nvarchar(256)
Declare @Config_Type nvarchar(256)

Select @Group1_LableName = g1.Name 
,@Group2_LableName = g2.Name 
,@AnalysisID = xc.AnalysisID
,@Group1_ColumnAliasName = g1.[ReferenceColumnAliasName] 
,@Group2_ColumnAliasName = g2.[ReferenceColumnAliasName] 
,@Config_Type = xc.Type
from cre.xirrconfig xc 
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
Where xc.xirrconfigID = @XIRRConfigID



IF OBJECT_ID('tempdb..#tblXIRRSetup') IS NOT NULL         
	DROP TABLE #tblXIRRSetup

CREATE TABLE #tblXIRRSetup(  
xirrconfigID	int,
ReturnName	nvarchar(256),
Type	nvarchar(256),
Comments	nvarchar(max),
FileName	nvarchar(256),
Group1	nvarchar(256),
Group2	nvarchar(256),
LableName	nvarchar(256),
FilterDropDownValue	nvarchar(256),
SortOrder	int,
--LookupTableName	 nvarchar(256),
--LookupColumnName	nvarchar(256),
ReferenceColumnName	nvarchar(256),
ReferenceTableName nvarchar(256)
)

INSERT INTO #tblXIRRSetup(xirrconfigID,ReturnName,Type,Comments,[FileName],Group1,Group2,LableName,FilterDropDownValue,SortOrder,ReferenceColumnName,ReferenceTableName) --,LookupTableName,LookupColumnName
Select xc.xirrconfigID
,xc.ReturnName
,xc.[Type]
,xc.Comments
,xc.filename_input as [FileName]
,g1.Name as Group1
,g2.Name as Group2
,xfs.Name as [LableName]
,xcf.FilterDropDownValue
,xfs.SortOrder
--,xfs.[LookupTableName]   
--,xfs.[LookupColumnName]   
,xfs.[ReferenceColumnName]
,xfs.[ReferenceTableName] 
from cre.xirrconfig xc
left Join [CRE].[XIRRConfigFilter] xcf on xcf.XIRRConfigID = xc.XIRRConfigID
Inner Join cre.XIRRFilterSetup xfs on xfs.XIRRFilterSetupID = xcf.XIRRFilterSetupID
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
where xc.xirrconfigID = @XIRRConfigID
Order by SortOrder



 IF OBJECT_ID('tempdb..#tblLableName') IS NOT NULL         
	DROP TABLE #tblLableName

CREATE TABLE #tblLableName( 
ID int IDENTITY(1,1) not null,
LableName	nvarchar(256),
SortOrder int
)
INSERT INTO #tblLableName(LableName,SortOrder)
Select Distinct LableName,SortOrder from #tblXIRRSetup
Order by SortOrder



IF OBJECT_ID('tempdb..#tblNoteList') IS NOT NULL         
	DROP TABLE #tblNoteList

CREATE TABLE #tblNoteList( 
	AccountID UNIQUEIDENTIFIER,
	NoteID UNIQUEIDENTIFIER
)
--====================================


--Select * from #tblXIRRSetup
--Select * from #tblLableName
--====================================
Declare @query nvarchar(max) = '';
Declare @queryWhereStatement nvarchar(max) = '';
Declare @LableName nvarchar(256)

Declare @Filtercolumn nvarchar(256) = ''
 
IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	Select LableName from #tblLableName ---where LableName in ('pool', 'State')
)
OPEN CursorDeal 
FETCH NEXT FROM CursorDeal
INTO @LableName
WHILE @@FETCH_STATUS = 0
BEGIN

	Declare @where_column nvarchar(256) = (Select Distinct ReferenceColumnName from #tblXIRRSetup where LableName = @LableName)

	DECLARE @where_values varchar(256) 
	SET @where_values = null
	Select   @where_values = COALESCE( @where_values + ',''','''') + FilterDropDownValue + ''''
	from #tblXIRRSetup where LableName = @LableName

	SET @queryWhereStatement = @queryWhereStatement + ' and ' + @where_column + ' in (' + @where_values + ')'

	SET @Filtercolumn = @Filtercolumn + ',' + @where_column 
	
FETCH NEXT FROM CursorDeal
INTO @LableName
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal


IF(NULLIF(@queryWhereStatement,'') IS NOT NULL)
BEGIN

	
	--Print(@Filtercolumn)
	SET @query = N'			
	Select n.Account_Accountid,n.NoteID From cre.note n
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner join cre.deal d on d.dealid = n.dealid
	Where acc.isdeleted <> 1'

	SET @query = @query + @queryWhereStatement

	--print (@query)

	INSERT INTO #tblNoteList(AccountID,NoteID)
	exec (@query)

END
ELSE   ----Calculate all deals at once
BEGIN
	IF EXISTS(Select * from cre.xirrconfig xc
	left Join [CRE].[XIRRConfigFilter] xcf on xcf.XIRRConfigID = xc.XIRRConfigID
	left Join cre.XIRRFilterSetup xfs on xfs.XIRRFilterSetupID = xcf.XIRRFilterSetupID
	Where xc.XIRRConfigID = @XIRRConfigID and xc.Type = 'Deal')
	BEGIN
		SET @query = N'			
		Select n.Account_Accountid,n.NoteID From cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		Where acc.isdeleted <> 1'	

		print (@query)
		Delete from #tblNoteList
		INSERT INTO #tblNoteList(AccountID,NoteID)
		exec (@query)
	END
END


----If there is tag, then filter list again
IF EXISTS(Select ObjectID from [CRE].[XIRRConfigDetail] Where [objectType] = 'Tag' and XIRRConfigID = @XIRRConfigID)
BEGIN
	Delete From #tblNoteList where AccountID not in (
		Select Distinct mapp.AccountID
		from [CRE].[TagAccountMappingXIRR] mapp
		Where mapp.TagMasterXIRRID in (
			Select ObjectID as TagMasterXIRRID
			from [CRE].[XIRRConfigDetail] 
			Where [objectType] = 'Tag' and XIRRConfigID = @XIRRConfigID
		)
	)
END


Declare @g1_query nvarchar(256) = '+''_''+ (CASE WHEN g1.Name = '''+@Group1_LableName+''' THEN CAST('+@Group1_ColumnAliasName+' as nvarchar(256)) ELSE '''' END)'
Declare @g2_query nvarchar(256) = '+''_''+ (CASE WHEN g2.Name= '''+@Group2_LableName+''' THEN CAST('+@Group2_ColumnAliasName+' as nvarchar(256)) ELSE '''' END)'

Declare @g3_query nvarchar(256)
IF(@Config_Type = 'Deal')
BEGIN
	SET @g3_query = '+''_''+ CREDealID'
END

Declare @queryMain nvarchar(max)
SET @queryMain = N'Select 
 y.[XIRRConfigID]
,y.[Type]
,y.[AnalysisID]
,y.[DealAccountID]
,y.[NoteAccountID]
,y.[ReturnName]
,y.[ChildReturnName]
,y.[PoolID]
,y.PoolName
,y.[ProductTypeID]
,y.[ProductType]
,y.[State]
,y.[DealTypeID]
,y.[DealType]
,y.[Group1]
,y.[Group2]
,LoanStatus
,MSA
,VintageYear
From(
Select z.XIRRConfigID,xc.ReturnName
,xc.ReturnName '+ISNULL(@g1_query,'') + ISNULL(@g2_query,'') + ISNULL(@g3_query,'') +'+''_''+ LoanStatus  as ChildReturnName
,xc.[Type]
,g1.Name as Group1Text
,g2.Name as Group2Text
,dealid,noteid,PoolID,PoolName,ProductTypeID,ProductType,State,DealTypeID,DealType
,xc.AnalysisID
,DealAccountID
,NoteAccountID
,xc.Group1  
,xc.Group2 
,LoanStatus
,MSA
,VintageYear
From(
	Select '+CAST(@XIRRConfigID as nvarchar(256))+' as XIRRConfigID
	,d.CREdealid
	,d.dealid,n.noteid
	,n.poolid as PoolID
	,lpool.name as PoolName
	,d.PropertyTypeMajorID as ProductTypeID
	,lprop.PropertyTypeMajorDesc as ProductType
	,[StateFromProperty] as [State]
	,d.DealTypeMasterID as DealTypeID
	,ldt.DealTypeName as DealType
	,d.AccountID as DealAccountID
	,n.Account_AccountID as NoteAccountID
	,(CASE WHEN tblActivedeal.dealid IS NOT NULL THEN ''Unrealized'' ELSE ''Realized'' END) as LoanStatus
	,d.MSA_NAME  as MSA   
	,YEAR(d.InquiryDate) as VintageYear
	from cre.note n
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner join cre.deal d on d.dealid = n.dealid
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
	Where acc.isdeleted <> 1
	and noteid in (Select noteid from #tblNoteList)
)z
Inner join cre.xirrconfig xc on xc.XIRRConfigID = z.XIRRConfigID
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
)y'
Print(@queryMain)


IF OBJECT_ID('tempdb..#tblXIRRCalculationInput') IS NOT NULL         
	DROP TABLE #tblXIRRCalculationInput

CREATE TABLE #tblXIRRCalculationInput( 
[XIRRConfigID] int,
[Type] nvarchar(256),
[AnalysisID] UNIQUEIDENTIFIER,
[DealAccountID] UNIQUEIDENTIFIER,
[NoteAccountID] UNIQUEIDENTIFIER,
[ReturnName] nvarchar(256),
[ChildReturnName] nvarchar(256),
[PoolID] int,
[PoolName] nvarchar(256),
[ProductTypeID]  int,
[ProductType]  nvarchar(256),
[State] nvarchar(256),
[DealTypeID]  int,
[DealType]  nvarchar(256),
[Group1]  int,
[Group2]  int,
LoanStatus nvarchar(256),
MSA nvarchar(256),
VintageYear nvarchar(256)
)
INSERT INTO #tblXIRRCalculationInput
([XIRRConfigID]
,[Type]
,[AnalysisID]
,[DealAccountID]
,[NoteAccountID]
,[ReturnName]
,[ChildReturnName]
,[PoolID]
,[PoolName]
,[ProductTypeID]
,[ProductType]
,[State]
,[DealTypeID]
,[DealType]
,[Group1]
,[Group2]
,LoanStatus
,MSA
,VintageYear)

EXEC(@queryMain)



Select xi.[ReturnName]
,d.DealName,d.CREDealID as DealID
,n.CRENoteID as NoteID,acc.name as NoteName
,xi.[PoolName]
,xi.[ProductType]
,xi.[State]
,xi.[DealType]
,xi.LoanStatus
,xi.MSA
,xi.VintageYear
From #tblXIRRCalculationInput xi
Inner join cre.Note n on n.account_accountid = xi.NoteAccountID
Inner join core.account acc on acc.accountid = n.account_accountid
Inner join cre.deal d on d.dealid = n.dealid
Order by d.DealName,n.CRENoteID




END