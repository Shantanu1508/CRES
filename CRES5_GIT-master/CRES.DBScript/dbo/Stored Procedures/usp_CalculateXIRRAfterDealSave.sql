CREATE PROCEDURE [dbo].[usp_CalculateXIRRAfterDealSave]
	@DealAccountid nvarchar(256),
	@UserId nvarchar(256),
	@CalcStatus int  = null
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


---Queue xirr to CalcSubmit after deal save, then it will go to processing after deal calculate "usp_CalculateXIRRAfterDealCalculate"

IF((Select [Value] from [App].[AppConfig] where [Key] = 'CalculateXIRRAfterDealSave') = 1)
BEGIN

	--Declare @xirrConfigIDs nvarchar(MAX)

	--Select @xirrConfigIDs = STRING_AGG(a.xirrconfigid,',') 
	--From(
	--Select Distinct top 2 xc.xirrconfigid
	--from cre.XIRRCalculationInput xi
	--Inner join cre.xirrconfig xc on xc.xirrconfigid = xi.xirrconfigid
	--where xc.[Type] = 'Deal'
	--and xi.DealAccountid = @DealAccountid
	--)a

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


	Declare @XIRRConfigID int
	Declare @AnalysisID UNIQUEIDENTIFIER
	Declare @Type nvarchar(256)
	

	IF CURSOR_STATUS('global','CursorDealXIRR')>=-1
	BEGIN
		DEALLOCATE CursorDealXIRR
	END

	DECLARE CursorDealXIRR CURSOR 
	for
	(
		Select Distinct xc.XIRRConfigID,xc.AnalysisID,xc.[Type]
		from cre.XIRRCalculationInput xi
		Inner join cre.xirrconfig xc on xc.xirrconfigid = xi.xirrconfigid
		Inner join cre.deal d on d.AccountID = xi.DealAccountID
		where xc.[Type] = 'Deal'
		and xi.DealAccountid = @DealAccountid
		and xc.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and xc.ShowReturnonDealScreen = 3
		and d.DealName not like '%copy%'
		and d.isdeleted <> 1 
	)
	OPEN CursorDealXIRR 
	FETCH NEXT FROM CursorDealXIRR
	INTO @XIRRConfigID,@AnalysisID,@Type ---,@PortfolioID

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		Delete From [CRE].[XIRRInputCashflow] where XIRRConfigID = @XIRRConfigID and [DealAccountID] = @DealAccountid
		Delete From [CRE].[XIRRCalculationRequests] where XIRRConfigID = @XIRRConfigID and [DealAccountID] = @DealAccountid

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

			where acc.isdeleted <> 1 
			----and n.debttypeid != 444  ---3rd party			
			and tr.analysisid = @AnalysisID
			and tr.[Type] in (
				Select TransactionName from [CRE].[TransactionTypes] where UsedInXIRR = 3
				and TransactionName not in (
					Select ty.TransactionName from [CRE].[XIRRConfigDetail] xd
					Inner JOin [CRE].[TransactionTypes] ty on ty.TransactionTypesID = xd.ObjectID
					where xd.ObjectType = 'Transaction' and xd.XIRRConfigID = @XIRRConfigID
				)
			)
			and tr.AccountID in (Select distinct NoteAccountID from [CRE].[XIRRCalculationInput] where xirrconfigid = @XIRRConfigID and dealaccountid = @DealAccountid)
	
		)z
		Inner Join [CRE].[XIRRCalculationInput] xi on xi.XIRRConfigID = z.XIRRConfigID and xi.AnalysisID = z.AnalysisID  and xi.NoteAccountID = z.NoteAccountID 


		---Delete From [CRE].[XIRRInputCashflow] where XIRRConfigID = @XIRRConfigID and DealAccountID = @DealAccountid and TransactionType = 'UnusedFeeExcludedFromLevelYield' and RemitDate IS NULL
		------------------------------------------------------
		
		INSERT INTO [CRE].[XIRRCalculationRequests]
		([XIRRConfigID]
		,XIRRReturnGroupID
		,AnalysisID
		,[Type]
		,DealAccountID
		,[Status]
		,RequestTime
		,[StartTime]
		,[EndTime]
		,[ErrorMessage]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate])

		Select Distinct
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID as XIRRReturnGroupID
		,xm.AnalysisID 
		,xr.[Type] as [Type] 
		,inp.DealAccountID as DealAccountID 
		,ISNULL(@CalcStatus,882) as [Status]  ---292
		,getdate() as RequestTime
		,null as StartTime
		,null as EndTime
		,null as ErrorMessage
		,@UserID as [CreatedBy]
		,getdate() as [CreatedDate]
		,@UserID as [UpdatedBy]
		,getdate() as [UpdatedDate]
		From [CRE].[XIRRReturnGroup] xr
		Inner JOin [CRE].[XIRRCalculationInput] inp on inp.XIRRReturnGroupID = xr.XIRRReturnGroupID
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Where xm.[type] = 'Deal'
		and xm.XIRRConfigID  = @XIRRConfigID and [DealAccountID] = @DealAccountid



	FETCH NEXT FROM CursorDealXIRR
	INTO @XIRRConfigID,@AnalysisID,@Type --,@PortfolioID
	END
	CLOSE CursorDealXIRR   
	DEALLOCATE CursorDealXIRR

	
END

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END