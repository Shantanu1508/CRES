INSERT INTO CRE.TransactionEntry(AnalysisID
,AccountID
,Date
,Amount	
,[Type]
,CreatedBy	
,CreatedDate	
,UpdatedBy	
,UpdatedDate	
,EndingBalance
,Flag	
,ParentAccountId)

Select 
AnalysisID
,AccountID
,Date
,0 as Amount	
,(CASE WHEN [Type] Like '%Equity%' THEN 'EquityCapitalAllocation' WHEN [Type] Like '%Subline%' THEN 'SublineAllocation' ELSE [Type] END) as Type_New	
,CreatedBy	
,CreatedDate	
,UpdatedBy	
,UpdatedDate	
,EndingBalance
,Flag	
,ParentAccountId
from cre.transactionentry where accountid in (

	Select AccountID from(
		Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,ac.name
		from cre.Debt d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
		where IsDeleted<> 1
		and ac.name = 'Subline'

		UNION ALL

		Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Equity' as LibFlag
		from cre.Equity d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
		where IsDeleted<> 1
	)a
)

and [type] in ('EquityCapitalCall','EquityCapitalDistribution','SublineAdvance','SublinePaydown')
and ABS(Amount) <> 0
and ABS(Amount) > 1
---order by accountid,date

---=======================================================================

Update cre.transactionentry set cre.transactionentry.type = z.Type_New
From(
	Select TransactionEntryID,AccountID,Date,Amount,Type,AnalysisID,(CASE WHEN [Type] Like '%Equity%' THEN 'EquityCapitalCall' WHEN [Type] Like '%Subline%' THEN 'SublineCall' ELSE [Type] END) as Type_New
	from cre.transactionentry where accountid in (

		Select AccountID from(
			Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,ac.name
			from cre.Debt d 
			Inner Join core.Account acc on acc.AccountID =  d.AccountID 
			Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
			where IsDeleted<> 1
			and ac.name = 'Subline'

			UNION ALL

			Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Equity' as LibFlag
			from cre.Equity d 
			Inner Join core.Account acc on acc.AccountID =  d.AccountID 
			Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
			where IsDeleted<> 1
		)a
	)

	and [type] in ('EquityCapitalCall','EquityCapitalDistribution','SublineAdvance','SublinePaydown')
	and ABS(Amount) <> 0
	and ABS(Amount) > 1
	--order by accountid,date
)z
Where cre.transactionentry.TransactionEntryID =z.TransactionEntryID

---=======================================================================

Update cre.transactionentry set cre.transactionentry.type = z.Type_New
From(

	Select TransactionEntryID,AccountID,Date,Amount,Type,AnalysisID,(CASE WHEN [Type] Like '%Equity%' THEN 'EquityCapitalAllocation' WHEN [Type] Like '%Subline%' THEN 'SublineAllocation' ELSE [Type] END) as Type_New
	from cre.transactionentry where accountid in (

		Select AccountID from(
			Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,ac.name
			from cre.Debt d 
			Inner Join core.Account acc on acc.AccountID =  d.AccountID 
			Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
			where IsDeleted<> 1
			and ac.name = 'Subline'

			UNION ALL

			Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Equity' as LibFlag
			from cre.Equity d 
			Inner Join core.Account acc on acc.AccountID =  d.AccountID 
			Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
			where IsDeleted<> 1
		)a
	)

	and [type] in ('EquityCapitalCall','EquityCapitalDistribution','SublineAdvance','SublinePaydown')
	and ABS(ROUND(Amount,0)) = 0
	--OR ABS(Amount) < 1
	--order by accountid,date
)z
Where cre.transactionentry.TransactionEntryID =z.TransactionEntryID


---=======================================================================

Update cre.transactionentryliability set cre.transactionentryliability.TransactionType = z.Type_New
From(

	Select liabilitynoteaccountid,transactionentryliabilityID,liabilityaccountid,Date,Amount,TransactionType,AnalysisID,(CASE WHEN TransactionType Like '%Equity%' THEN 'EquityCapitalAllocation' WHEN TransactionType Like '%Subline%' THEN 'SublineAllocation' ELSE TransactionType END) as Type_New
	from cre.transactionentryliability where  TransactionType in ('EquityCapitalCall','EquityCapitalDistribution','SublineAdvance','SublinePaydown')
	--order by liabilityaccountid,date
)z
Where cre.transactionentryliability.transactionentryliabilityID =z.transactionentryliabilityID