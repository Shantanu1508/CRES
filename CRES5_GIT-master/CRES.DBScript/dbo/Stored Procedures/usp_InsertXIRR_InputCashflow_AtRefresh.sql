--	[dbo].[usp_InsertXIRR_InputCashflow_AtRefresh]  8,'B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_InsertXIRR_InputCashflow_AtRefresh]  
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
	AND te.[Type] in (
		Select TransactionType from #tblTransactionType
	)
	AND te.AccountID in (Select AccountID from #tblXIRRNoteList)

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

	UPDATE tr Set 
		tr.[TypeCount] = (Select Count(tt.TransType) from @tblTranType tt where tr.[Type] like CONCAT(tt.transtype,'%')) 
	from #tblTransaction tr
	Inner Join cre.Note n on n.account_accountid = tr.accountid
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner Join cre.deal d on d.dealid = n.dealid
	where tr.[Type] in (
		Select TransactionType from #tblTransactionType
	)
	---n.debttypeid <> 444 ---3rd party
	DELETE FROM [CRE].[XIRRInputCashflow] WHERE XIRRConfigID = @XIRRConfigID and AnalysisID = @AnalysisID;

	INSERT INTO [CRE].[XIRRInputCashflow](
		[XIRRConfigID]
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
		,SpreadValue as  SpreadPercentage
		,[OriginalIndex]
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
		where acc.isdeleted <> 1 
		and tr.[Type] in (
			Select TransactionType from #tblTransactionType
		)
	)z
	Left Join [CRE].[XIRRCalculationInput] xi on xi.XIRRConfigID = z.XIRRConfigID and xi.AnalysisID = z.AnalysisID  and xi.NoteAccountID = z.NoteAccountID 

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END