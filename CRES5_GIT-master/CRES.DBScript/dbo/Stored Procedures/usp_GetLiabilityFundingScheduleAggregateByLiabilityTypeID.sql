---[dbo].[usp_GetLiabilityFundingScheduleAggregateByLiabilityTypeID]  'A3C83A5C-3A70-4359-83DE-5399D5CF78A0'
 
CREATE PROCEDURE [dbo].[usp_GetLiabilityFundingScheduleAggregateByLiabilityTypeID]
 @LiabilityTypeID nvarchar(256)   
AS  
BEGIN  


	Declare @CalcAsOfDate date;	
	SET @CalcAsOfDate = ISNULL((Select MAX(TransactionDate) from CRE.LiabilityFundingScheduleAggregate where Applied = 1 and AccountID in (
			Select distinct ln.LiabilitytypeID
			from cre.LiabilityNote ln  
			Inner Join core.Account acc on acc.AccountID = ln.AccountID  
			Where acc.IsDeleted <> 1  
			and ln.AssetAccountID  in (
				Select ln.AssetAccountID
				from cre.LiabilityNote ln  
				Inner Join core.Account acc on acc.AccountID = ln.AccountID  
				Where acc.IsDeleted <> 1  
				and ln.LiabilityTypeID  = @LiabilityTypeID	
			)
		)
	),getdate())


	 
	Select 
	 a.LiabilityFundingScheduleAggregateID
	,a.[AccountID]
	,a.TransactionDate
	,a.TransactionAmount
	,a.TransactionTypes
	,a.Applied
	,a.Comments
	,a.EndingBalance
	,a.TableName
	,ch.Amount as UnallocatedBalance
	,CalcType
	,[Status]
	,StatusText
	From(
		select LiabilityFundingScheduleAggregateID
		,tr.[AccountID]	
		,tr.TransactionDate as TransactionDate	
		,tr.TransactionAmount as TransactionAmount
		,tr.TransactionTypes as TransactionTypes
		,CAST(Applied as bit) as Applied
		,tr.Comments as Comments
		,tr.EndingBalance
		,'LiabilityFundingScheduleAggregate' as TableName
		,tblChAcc.PortfolioAccountID
		---,(CASE WHEN ac.name = 'Fund' THEN tr.CashBalance WHEN ac.name = 'Subline' THEN tr.SublineBalance  ELSE NULL END)  as UnallocatedBalance
		,null as UnallocatedBalance
		,CalcType
		,tr.[Status]
		,l.Name as StatusText
		From CRE.LiabilityFundingScheduleAggregate tr
		LEFT Join Core.Lookup l on l.LookupID = tr.Status
		Inner join core.Account acc on acc.accountid = tr.accountid
		Inner join core.AccountCategory ac on ac.AccountCategoryID = acc.AccounttypeID
		Left Join(
			Select AccountID,PortfolioAccountID,[Text],[Type]
			From(
				Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Debt' as [Type]  
				from cre.Debt d   
				Inner Join core.Account acc on acc.AccountID =  d.AccountID   
				where  IsDeleted<> 1   
  
				UNION ALL    
  
				Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Equity' as [Type]  
				from cre.Equity d   
				Inner Join core.Account acc on acc.AccountID =  d.AccountID   
				where IsDeleted<> 1   
			)z
		)tblChAcc on tblChAcc.AccountID = tr.AccountID

		Where tr.AccountID = @LiabilityTypeID
		and (tr.TransactionDate <= @CalcAsOfDate or [Status] = 943)
		and isnull(tr.CalcType,0)<>911
	
	
		UNION ALL

		select 0 as LiabilityFundingScheduleAggregateID
		,tr.[AccountID]	
		,tr.date as TransactionDate	
		,tr.amount as TransactionAmount
		,tr.[type] as TransactionTypes
		,CAST(0 as bit) as Applied
		,null as Comments
		,tr.EndingBalance
		,'TransactionEntry' as TableName
		,tblChAcc.PortfolioAccountID
		,null as UnallocatedBalance
		,CalcType
		,942 as [Status]
		,'Projected' as StatusText
		From CRE.transactionentry tr
		Left Join(
			Select AccountID,PortfolioAccountID,[Text],[Type]
			From(
				Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Debt' as [Type]  
				from cre.Debt d   
				Inner Join core.Account acc on acc.AccountID =  d.AccountID   
				where  IsDeleted<> 1   
  
				UNION ALL    
  
				Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Equity' as [Type]  
				from cre.Equity d   
				Inner Join core.Account acc on acc.AccountID =  d.AccountID   
				where IsDeleted<> 1   
			)z
		)tblChAcc on tblChAcc.AccountID = tr.AccountID
		Where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and tr.AccountID = @LiabilityTypeID
		and tr.Date > @CalcAsOfDate
		and isnull(tr.CalcType,0)<>911

		and tr.Date not in (Select TransactionDate from cre.LiabilityFundingScheduleAggregate where AccountID = @LiabilityTypeID and [Status] = 943 and isnull(CalcType,0)<>911)

	)a
	Left Join(
		Select AccountID as PortfolioAccountID,Date,Amount  From cre.TransactionEntry 
		where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and Accountid in (Select AccountID from cre.cash)

	)ch on ch.PortfolioAccountID = a.PortfolioAccountID and ch.[Date] = a.TransactionDate

	order by TransactionDate,TransactionTypes desc

END