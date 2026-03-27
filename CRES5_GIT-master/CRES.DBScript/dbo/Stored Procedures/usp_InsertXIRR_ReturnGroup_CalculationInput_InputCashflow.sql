-- Procedure
--[dbo].[usp_InsertXIRRCalculationInput]  '107','B0E6697B-3534-4C09-BE0A-04473401AB93'
--[dbo].[usp_InsertXIRR_ReturnGroup_CalculationInput_InputCashflow]  3,'B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_InsertXIRR_ReturnGroup_CalculationInput_InputCashflow]  
	@XIRRConfigID int,
	@UserID nvarchar(256)
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


--Declare @XIRRConfigID int = 9
--Declare @UserID nvarchar(256) ='B0E6697B-3534-4C09-BE0A-04473401AB93'
----------------------------------------------------------------------

Delete From [CRE].[XIRRReturnGroup]      where XIRRConfigID = @XIRRConfigID
Delete From [CRE].[XIRRCalculationInput] where XIRRConfigID = @XIRRConfigID
Delete From [CRE].[XIRRInputCashflow]	 where XIRRConfigID = @XIRRConfigID
Delete From [CRE].[XIRRCalculationRequests] where XIRRConfigID = @XIRRConfigID

---------------------------------------------------------------
Declare @AnalysisID UNIQUEIDENTIFIER
Declare @Group1_LableName nvarchar(256)
Declare @Group2_LableName nvarchar(256)
Declare @Group1_ColumnAliasName nvarchar(256)
Declare @Group2_ColumnAliasName nvarchar(256)
Declare @Config_Type nvarchar(256)
Declare @CutOffDate Date



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

Select 
@CutOffDate = xi.CutoffDateOverride
from [CRE].[XIRROutputDealLevel] xi
Where xi.xirrconfigID = @XIRRConfigID


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
	Where acc.isdeleted <> 1 and d.isdeleted <> 1  and d.dealname not like ''%copy%'' '     -----n.debttypeid <> 444

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

	SET @query = N'			
	Select n.Account_Accountid,n.NoteID From cre.note n
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner join cre.deal d on d.dealid = n.dealid
	Where acc.isdeleted <> 1 and d.isdeleted <> 1  and d.dealname not like ''%copy%'' '	

	print (@query)
	Delete from #tblNoteList
	INSERT INTO #tblNoteList(AccountID,NoteID)
	exec (@query)
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

----,xc.ReturnName +''_''+ (CASE WHEN g1.Name = '''+@Group1_LableName+''' THEN '+@Group1_ColumnAliasName+' ELSE '''' END) +''_''+ (CASE WHEN g2.Name= '''+@Group2_LableName+''' THEN '+@Group2_ColumnAliasName+' ELSE '''' END) + ''_''+ LoanStatus  as ChildReturnName


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
,y.[ProductTypeID]
,y.[State]
,y.[DealTypeID]
,y.[Group1]
,y.[Group2]
,'''+CAST(@UserID as nvarchar(256))+''' as [CreatedBy]
,getdate() as [CreatedDate]
,'''+CAST(@UserID as nvarchar(256))+''' as [UpdatedBy]
,getdate() as [UpdatedDate]
,LoanStatus
,MSA
,VintageYear
,ChildReturnName_ColumnTotal
,ChildReturnName_RowTotal
,ChildReturnName_OverallTotal
,ChildReturnName_OverallColumnTotal
,ChildReturnName_GroupTotal
From(
Select z.XIRRConfigID,xc.ReturnName
,xc.ReturnName '+ISNULL(@g1_query,'') + ISNULL(@g2_query,'') + ISNULL(@g3_query,'') +'+''_''+ LoanStatus  as ChildReturnName
,xc.ReturnName '+ISNULL(@g1_query,'') + ISNULL(@g2_query,'') + '+''_''+ ''ColumnTotal''  as ChildReturnName_ColumnTotal
,xc.ReturnName '+ISNULL(@g1_query,'') +'+''_''+ LoanStatus + ''_RowTotal''  as ChildReturnName_RowTotal
,xc.ReturnName '+'+''_''+ ''OverallTotal''  as ChildReturnName_OverallTotal
,xc.ReturnName '+ ISNULL(@g2_query,'') + '+''_''+ ''OverallColumnTotal''  as ChildReturnName_OverallColumnTotal
,xc.ReturnName '+ISNULL(@g1_query,'') +'+''_''+ ''GroupTotal''  as ChildReturnName_GroupTotal
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
		UNION
		Select Distinct d.dealid,n.actualPayoffdate
		from cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		Where acc.isdeleted <> 1 and n.actualPayoffdate is not null and n.actualPayoffdate > ISNULL(CONVERT(nvarchar(MAX), ''' + CONVERT(nvarchar, @CutOffDate, 101) + '''), '''')
	)tblActivedeal on tblActivedeal.DealID = d.DealID
	Where acc.isdeleted <> 1
	and noteid in (Select noteid from #tblNoteList)
)z
Inner join cre.xirrconfig xc on xc.XIRRConfigID = z.XIRRConfigID
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
)y'
--Print(@queryMain)


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
[ProductTypeID]  int,
[State] nvarchar(256),
[DealTypeID]  int,
[Group1]  int,
[Group2]  int,
[CreatedBy] nvarchar(256),
[CreatedDate] date,
[UpdatedBy] nvarchar(256),
[UpdatedDate] date,
LoanStatus nvarchar(256),
MSA nvarchar(256),
VintageYear nvarchar(256),
ChildReturnName_ColumnTotal nvarchar(256),
ChildReturnName_RowTotal nvarchar(256),
ChildReturnName_OverallTotal nvarchar(256),
ChildReturnName_OverallColumnTotal nvarchar(256),
ChildReturnName_GroupTotal nvarchar(256)
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
,[ProductTypeID]
,[State]
,[DealTypeID]
,[Group1]
,[Group2]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,LoanStatus
,MSA
,VintageYear
,ChildReturnName_ColumnTotal
,ChildReturnName_RowTotal
,ChildReturnName_OverallTotal
,ChildReturnName_OverallColumnTotal
,ChildReturnName_GroupTotal)

EXEC(@queryMain)

-----------------------------------

INSERT INTO [CRE].[XIRRReturnGroup]
([XIRRConfigID]
,[Type]
,[ReturnName]
,[ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,LoanStatus
)
Select Distinct [XIRRConfigID]
,[Type]
,[ReturnName]
,[ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,LoanStatus
From #tblXIRRCalculationInput

UNION ALL

Select Distinct [XIRRConfigID]
,[Type] +'_ColumnTotal'
,[ReturnName]
,ChildReturnName_ColumnTotal [ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,NULL as LoanStatus
From #tblXIRRCalculationInput
Where [Type] = 'Portfolio'

UNION ALL

Select Distinct [XIRRConfigID]
,[Type] +'_RowTotal'
,[ReturnName]
,ChildReturnName_RowTotal [ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,LoanStatus
From #tblXIRRCalculationInput
Where [Type] = 'Portfolio'

UNION ALL

Select Distinct [XIRRConfigID]
,[Type] +'_OverallTotal'
,[ReturnName]
,ChildReturnName_OverallTotal [ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,null as LoanStatus
From #tblXIRRCalculationInput
Where [Type] = 'Portfolio'


UNION ALL

Select Distinct [XIRRConfigID]
,[Type] +'_OverallColumnTotal'
,[ReturnName]
,ChildReturnName_OverallColumnTotal [ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,null as LoanStatus
From #tblXIRRCalculationInput
Where [Type] = 'Portfolio'

UNION ALL

Select Distinct [XIRRConfigID]
,[Type] +'_GroupTotal'
,[ReturnName]
,ChildReturnName_GroupTotal [ChildReturnName]
,[Group1]
,[Group2]
,[AnalysisID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,null as LoanStatus
From #tblXIRRCalculationInput
Where [Type] = 'Portfolio'


---------------------------------------------------
INSERT INTO [CRE].[XIRRCalculationInput]
([XIRRConfigID]
,[Type]
,[AnalysisID]
,[DealAccountID]
,[NoteAccountID]
,[ReturnName]
,[ChildReturnName]
,[PoolID]
,[ProductTypeID]
,[State]
,[DealTypeID]
,[Group1]
,[Group2]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[XIRRReturnGroupID]
,LoanStatus
,MSA
,VintageYear
,ChildReturnName_ColumnTotal
,ChildReturnName_RowTotal
,ChildReturnName_OverallTotal
,ChildReturnName_OverallColumnTotal
,ChildReturnName_GroupTotal

,XIRRReturnGroupID_ColumnTotal 
,XIRRReturnGroupID_RowTotal
,XIRRReturnGroupID_OverallTotal 
,XIRRReturnGroupID_OverallColumnTotal
,XIRRReturnGroupID_GroupTotal)

Select xi.[XIRRConfigID]
,xi.[Type]
,xi.[AnalysisID]
,xi.[DealAccountID]
,xi.[NoteAccountID]
,xi.[ReturnName]
,xi.[ChildReturnName]
,xi.[PoolID]
,xi.[ProductTypeID]
,xi.[State]
,xi.[DealTypeID]
,xi.[Group1]
,xi.[Group2]
,xi.[CreatedBy]
,xi.[CreatedDate]
,xi.[UpdatedBy]
,xi.[UpdatedDate]
,xr.[XIRRReturnGroupID]
,xi.LoanStatus
,xi.MSA
,xi.VintageYear
,xi.ChildReturnName_ColumnTotal
,xi.ChildReturnName_RowTotal
,xi.ChildReturnName_OverallTotal
,xi.ChildReturnName_OverallColumnTotal
,xi.ChildReturnName_GroupTotal

,xr_ColumnTotal.[XIRRReturnGroupID] as XIRRReturnGroupID_ColumnTotal 
,xr_RowTotal.[XIRRReturnGroupID] as XIRRReturnGroupID_RowTotal
,xr_OverallTotal.[XIRRReturnGroupID] as XIRRReturnGroupID_OverallTotal 
,xr_OverallColumnTotal.[XIRRReturnGroupID] as XIRRReturnGroupID_OverallColumnTotal 
,xr_GroupTotal.[XIRRReturnGroupID] as XIRRReturnGroupID_GroupTotal 

From #tblXIRRCalculationInput xi
Left Join [CRE].[XIRRReturnGroup] xr on xi.XIRRConfigID = xr.XIRRConfigID and xi.ChildReturnName = xr.ChildReturnName
Left Join [CRE].[XIRRReturnGroup] xr_ColumnTotal on xi.XIRRConfigID = xr_ColumnTotal.XIRRConfigID and xi.ChildReturnName_ColumnTotal = xr_ColumnTotal.ChildReturnName
Left Join [CRE].[XIRRReturnGroup] xr_RowTotal on xi.XIRRConfigID = xr_RowTotal.XIRRConfigID and xi.ChildReturnName_RowTotal = xr_RowTotal.ChildReturnName
Left Join [CRE].[XIRRReturnGroup] xr_OverallTotal on xi.XIRRConfigID = xr_OverallTotal.XIRRConfigID and xi.ChildReturnName_OverallTotal = xr_OverallTotal.ChildReturnName
Left Join [CRE].[XIRRReturnGroup] xr_OverallColumnTotal on xi.XIRRConfigID = xr_OverallColumnTotal.XIRRConfigID and xi.ChildReturnName_OverallColumnTotal = xr_OverallColumnTotal.ChildReturnName
Left Join [CRE].[XIRRReturnGroup] xr_GroupTotal on xi.XIRRConfigID = xr_GroupTotal.XIRRConfigID and xi.ChildReturnName_GroupTotal = xr_GroupTotal.ChildReturnName
---------------------------------------------------

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-------------------Commented below section as shifting to another procedure-----------------
-------------------------------usp_InsertXIRR_InputCashflow---------------------------------
--------------------------------------------------------------------------------------------
/*
Declare @tblPertable as table
(
	Noteid	UNIQUEIDENTIFIER,
	Date	date,
	LIBORPercentage	decimal(28,15),
	PIKInterestPercentage	decimal(28,15),
	SpreadPercentage	decimal(28,15),
	PIKLiborPercentage decimal(28,15),
	RawIndexPercentage decimal(28,15),
	RawPIKIndexPercentage decimal(28,15)
)

INSERT INTO @tblPertable (Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage
from(
	select 
	n.Noteid,
	te.[Date] ,
	te.Amount,
	te.[Type] ValueType
	from  CRE.TransactionEntry te 
	inner join core.Account acc on acc.AccountID=te.AccountID		
	inner join Cre.Note n on n.Account_accountid=te.AccountID	
	where acc.IsDeleted=0
	AND ISNULL(acc.StatusID,1) = 1
	AND te.AnalysisID = @AnalysisID
	AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
	and te.AccountID in (Select AccountID from #tblNoteList)
)a
PIVOT (
	SUM(Amount)
	FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
) pvt


-------------------------------
Declare @tblTranType as Table(
TransType nvarchar(256)
)

INSERT INTO @tblTranType(TransType)
Select TransType from(
	Select [Name] as TransType from core.Lookup where ParentID = 94
	UNION ALL
	Select 'InterestPaid' as TransType
	UNION ALL
	Select 'FloatInterest' as TransType
	UNION ALL
	Select 'PIKInterestPaid' as TransType
)a


INSERT INTO [CRE].[XIRRInputCashflow]
([XIRRConfigID]
,[DealAccountID]
,[NoteAccountID]
,TransactionType
,TransactionDate
,Amount
,RemitDate
,AnalysisID
,ReturnName
,ChildReturnName
,[XIRRReturnGroupID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,LoanStatus
,MSA
,VintageYear
,XIRRReturnGroupID_ColumnTotal 
,XIRRReturnGroupID_RowTotal
,XIRRReturnGroupID_OverallTotal
,XIRRReturnGroupID_OverallColumnTotal
,TransactionDateByRule
,XIRRReturnGroupID_GroupTotal

,SpreadPercentage  
,[OriginalIndex]  
,[IndexValue]  
,[EffectiveRate]  
,[FeeName]
)
Select 
 z.[XIRRConfigID]
,z.DealAccountID
,z.NoteAccountID
,z.TransactionType
,z.TransactionDate
,z.Amount
,z.RemitDate
,z.AnalysisID
,xi.ReturnName as ReturnName
,xi.ChildReturnName as ChildReturnName
,xi.XIRRReturnGroupID as [XIRRReturnGroupID]
,z.[CreatedBy]
,z.[CreatedDate]
,z.[UpdatedBy]
,z.[UpdatedDate]
,xi.LoanStatus
,xi.MSA
,xi.VintageYear
,xi.XIRRReturnGroupID_ColumnTotal 
,xi.XIRRReturnGroupID_RowTotal
,xi.XIRRReturnGroupID_OverallTotal
,xi.XIRRReturnGroupID_OverallColumnTotal
,z.TransactionDateByRule
,xi.XIRRReturnGroupID_GroupTotal

,z.SpreadPercentage  
,z.[OriginalIndex]  
,z.[IndexValue]  
,z.[EffectiveRate]  
,z.[FeeName]
From(
	Select @XIRRConfigID as XIRRConfigID
	,tr.accountid as NoteAccountID
	,d.AccountID as DealAccountID
	,tr.[type] as TransactionType
	--,tr.date as TransactionDate
	,(CASE WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(tr.[type],' ','')) = 1) > 0 
		THEN ISNULL(tr.TransactionDateByRule,tr.date)
		ELSE tr.date
	END) AS TransactionDate

	,tr.amount
	,tr.RemitDate 
	,@AnalysisID as AnalysisID	
	,@UserID as [CreatedBy]
	,getdate() as [CreatedDate]
	,@UserID as [UpdatedBy]
	,getdate() as [UpdatedDate]
	,(CASE WHEN tblActivedeal.dealid IS NOT NULL THEN 'Unrealized' ELSE 'Realized' END) as LoanStatus
	,d.MSA_NAME as MSA 
	,Year(d.InquiryDate) as VintageYear
	,tr.TransactionDateByRule

	,(case 	when tr.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
	when tr.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') 
	then Cast(tblTr.PIKInterestPercentage as nvarchar(256))  else null end) as  SpreadPercentage

	,(case when tr.[Type] in ('InterestPaid','StubInterest')  then Cast(tblTr.RawIndexPercentage  as nvarchar(256)) 
	when tr.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') 
	then Cast(tblTr.RawPIKIndexPercentage as nvarchar(256)) else null end) as [OriginalIndex]

	--,tbltr.LIBORPercentage  as [IndexValue]
	,(case 
	when tr.[Type] in ( 'InterestPaid','StubInterest') then tblTr.LIBORPercentage 
	when tr.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.PIKLiborPercentage  
	else null end) as [IndexValue]

	,tr.AllInCouponRate [EffectiveRate]
	,tr.FeeName [FeeName]

	from cre.transactionentry tr
	Inner Join cre.Note n on n.account_accountid = tr.accountid
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner Join cre.deal d on d.dealid = n.dealid
	Left Join(
		Select Distinct d.dealid,n.actualPayoffdate
		from cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		Where acc.isdeleted <> 1 and n.actualPayoffdate is null
	)tblActivedeal on tblActivedeal.DealID = d.DealID
	LEFT JOIN
	(
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage from @tblPertable

	)tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = tr.[Date]

	where acc.isdeleted <> 1 and n.debttypeid != 444  ---3rd party
	and tr.analysisid = @AnalysisID
	and tr.[Type] in (
		Select TransactionName from [CRE].[TransactionTypes] where UsedInXIRR = 3
		and TransactionName not in (
			Select ty.TransactionName from [CRE].[XIRRConfigDetail] xd
			Inner JOin [CRE].[TransactionTypes] ty on ty.TransactionTypesID = xd.ObjectID
			where xd.ObjectType = 'Transaction' and xd.XIRRConfigID = @XIRRConfigID
		)
	)
	and tr.AccountID in (Select AccountID from #tblNoteList)
	
)z
Left Join [CRE].[XIRRCalculationInput] xi on xi.XIRRConfigID = z.XIRRConfigID and xi.AnalysisID = z.AnalysisID  and xi.NoteAccountID = z.NoteAccountID 


Delete From [CRE].[XIRRInputCashflow] where XIRRConfigID = @XIRRConfigID and TransactionType = 'UnusedFeeExcludedFromLevelYield' and RemitDate IS NULL
*/



--Select * From [CRE].[XIRRReturnGroup]      where XIRRConfigID = @XIRRConfigID
--Select * From [CRE].[XIRRCalculationInput] where XIRRConfigID = @XIRRConfigID
--Select * From [CRE].[XIRRInputCashflow]	 where XIRRConfigID = @XIRRConfigID


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

