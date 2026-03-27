--	[dbo].[usp_InsertXIRR_InputCashflow]  8,'B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_InsertXIRR_InputCashflow]  
	@XIRRConfigID int,
	@UserID nvarchar(256)
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


Declare @AnalysisID UNIQUEIDENTIFIER


Select @AnalysisID = xc.AnalysisID
from cre.xirrconfig xc 
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2
Where xc.xirrconfigID = @XIRRConfigID


IF OBJECT_ID('tempdb..#tblXIRRNoteList') IS NOT NULL         
	DROP TABLE #tblXIRRNoteList

CREATE TABLE #tblXIRRNoteList( 
	AccountID UNIQUEIDENTIFIER
)

INSERT INTO #tblXIRRNoteList(AccountID)
Select Distinct NoteAccountID from [CRE].[XIRRCalculationInput] Where XIRRConfigID = @XIRRConfigID



IF OBJECT_ID('tempdb..#tblTransactionType') IS NOT NULL         
	DROP TABLE #tblTransactionType

CREATE TABLE #tblTransactionType( 
	[TransactionType] nvarchar(256) NULL
)

Insert into #tblTransactionType(TransactionType)
Select TransactionName from [CRE].[TransactionTypes] 
where UsedInXIRR = 3 and TransactionName not in (
	Select ty.TransactionName from [CRE].[XIRRConfigDetail] xd
	Inner JOin [CRE].[TransactionTypes] ty on ty.TransactionTypesID = xd.ObjectID
	where xd.ObjectType = 'Transaction' and xd.XIRRConfigID = @XIRRConfigID
)


IF OBJECT_ID('tempdb..#tblTransaction') IS NOT NULL         
	DROP TABLE #tblTransaction

CREATE TABLE #tblTransaction( 
	[AccountID] UNIQUEIDENTIFIER,
	[AnalysisID] UNIQUEIDENTIFIER,
	[Date] Date NULL,
	[Amount] decimal(28,15) NULL,
	[Type] nvarchar(256) NULL,
	[TransactionDateByRule] Date NULL,
	[RemitDate] Date NULL,
	[AllInCouponRate] decimal(28,15) NULL,
	[FeeName] nvarchar(256) NULL,
	[TypeCount] int,
	IndexValue	DECIMAL (28, 15) NULL,
	SpreadValue	DECIMAL (28, 15) NULL,
	OriginalIndex DECIMAL (28, 15) NULL
)

INSERT INTO #tblTransaction([AccountID],[AnalysisID],[Date],[Amount],[Type],[TransactionDateByRule],[RemitDate],[AllInCouponRate],[FeeName],IndexValue,SpreadValue,OriginalIndex)
Select te.[AccountID],te.[AnalysisID],te.[Date],te.[Amount],te.[Type],te.[TransactionDateByRule],te.[RemitDate],te.[AllInCouponRate],te.[FeeName] 
,te.IndexValue,te.SpreadValue,te.OriginalIndex
FROM CRE.TransactionEntry te
inner join core.Account acc on acc.AccountID=te.AccountID
WHERE acc.IsDeleted=0 AND te.AnalysisID = @AnalysisID
AND te.[Type] in 
(
	Select TransactionType from #tblTransactionType

	--UNION

	--Select TransactionName from [CRE].[TransactionTypes] where [TransactionName] in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
)
AND te.AccountID in (Select AccountID from #tblXIRRNoteList)
	

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
	from  #tblTransaction te 
	inner join core.Account acc on acc.AccountID=te.AccountID		
	inner join Cre.Note n on n.Account_accountid=te.AccountID	
	where ISNULL(acc.StatusID,1) = 1
	AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
	
)a
PIVOT (
	SUM(Amount)
	FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
) pvt
*/

-------------------------------
Declare @tblTranType as Table(
TransType nvarchar(256)
)

INSERT INTO @tblTranType(TransType)
	Select [Name] as TransType from core.Lookup where ParentID = 94
	UNION ALL
	Select 'InterestPaid' as TransType
	UNION ALL
	Select 'FloatInterest' as TransType
	UNION ALL
	Select 'PIKInterestPaid' as TransType


	update tr Set 
	tr.[TypeCount] = (Select Count(tt.TransType) from @tblTranType tt where tr.[Type] like CONCAT(tt.transtype,'%')) 
	from #tblTransaction tr
	Inner Join cre.Note n on n.account_accountid = tr.accountid
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner Join cre.deal d on d.dealid = n.dealid
	where  tr.[Type] in (
		Select TransactionType from #tblTransactionType
	)
	---n.debttypeid <> 444 ---3rd party


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
	,(CASE WHEN Typecount > 0 THEN ISNULL(tr.TransactionDateByRule,tr.date) ELSE tr.date END) AS TransactionDate
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

	/*,(case 	when tr.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
	when tr.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') 
	then Cast(tblTr.PIKInterestPercentage as nvarchar(256))  else null end) as  SpreadPercentage*/
	,SpreadValue as  SpreadPercentage

	/*,(case when tr.[Type] in ('InterestPaid','StubInterest')  then Cast(tblTr.RawIndexPercentage  as nvarchar(256)) 
	when tr.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') 
	then Cast(tblTr.RawPIKIndexPercentage as nvarchar(256)) else null end) as [OriginalIndex]*/
	,[OriginalIndex]

	/*,(case 
	when tr.[Type] in ( 'InterestPaid','StubInterest') then tblTr.LIBORPercentage 
	when tr.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.PIKLiborPercentage  
	else null end) as [IndexValue]*/
	,IndexValue

	,tr.AllInCouponRate [EffectiveRate]
	,tr.FeeName [FeeName]

	from #tblTransaction tr
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
	--LEFT JOIN @tblPertable tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = tr.[Date]

	where acc.isdeleted <> 1 
	-----and n.debttypeid <> 444 ---3rd party  
	and tr.[Type] in (
		Select TransactionType from #tblTransactionType
	)
	
)z
Left Join [CRE].[XIRRCalculationInput] xi on xi.XIRRConfigID = z.XIRRConfigID and xi.AnalysisID = z.AnalysisID  and xi.NoteAccountID = z.NoteAccountID 

-----Delete From [CRE].[XIRRInputCashflow] where XIRRConfigID = @XIRRConfigID and TransactionType = 'UnusedFeeExcludedFromLevelYield' and RemitDate IS NULL

EXEC [dbo].[usp_InsertXIRRCalculationRequests] @XIRRConfigID,@UserID   

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END