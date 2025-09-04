
CREATE view [dbo].[vw_disc_ForExitAndExtentionStripReceiveable]  as

	
	Select  Scenario,DealName as [Deal Name],
			DealID as [Deal ID],
			REPLACE('$' + ISNULL(CONVERT(varchar , CAST(ExtentionFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [ExtentionFeeStrip + Receivable],
			REPLACE('$' + ISNULL(CONVERT(varchar , CAST(ExitFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [ExitFeeStrip + Receivable] ,
			REPLACE('$' + ISNULL(CONVERT(varchar , CAST(OriginationFee AS DECIMAL(18,2)) ,1),0), '$-','-$') as [OriginationFeeStrip + Receivable]
			
	from (

		Select Distinct a.[name] as Scenario,d.dealid,d.dealname,tblExtentionfee.ExtentionFee,tblExitfee.ExitFee,tblOriginationFee.OriginationFee 
		from dbo.Transactionentry tr
		Inner join core.Account acc on acc.AccountID = tr.AccountID
		inner join note n on n.AccountID = acc.AccountID
		inner join deal d on N.DealKey = D.DealKey
		Inner join core.Analysis a on a.AnalysisID = tr.AnalysisID
		INNER JOIN CORE.AnalysisParameter AP ON AP.AnalysisID = a.AnalysisID
		left join(
			Select tr.Scenario, d.dealid,SUM(tr.amount) as ExtentionFee 
			from dbo.Transactionentry tr
			Inner join core.Account acc on acc.AccountID = tr.AccountID
			inner join note n on n.AccountID = acc.AccountID
			inner join deal d on N.DealKey = D.DealKey
			where acc.AccountTypeID = 1
			and type in ('ExtensionFeeStrippingExcldfromLevelYield','ExtensionFeeStripReceivable')
			group by tr.Scenario,d.dealid
		)as tblExtentionfee on tblExtentionfee.dealid = d.dealid AND tblExtentionfee.Scenario = a.[Name]

		left join(
			Select tr.Scenario, d.dealid,SUM(tr.amount) as ExitFee 
			from dbo.Transactionentry tr
			Inner join core.Account acc on acc.AccountID = tr.AccountID
			inner join note n on n.AccountID = acc.AccountID
			inner join deal d on N.DealKey = D.DealKey
			where acc.AccountTypeID = 1
			and type in ('ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable')
			group by tr.Scenario,d.dealid
		)as tblExitfee on tblExitfee.dealid = d.dealid AND tblExitfee.Scenario = a.[Name]

		left join(
			Select tr.Scenario, d.dealid,SUM(tr.amount) as OriginationFee 
			from dbo.Transactionentry tr
			Inner join core.Account acc on acc.AccountID = tr.AccountID
			inner join note n on n.AccountID = acc.AccountID
			inner join deal d on N.DealKey = D.DealKey
			where acc.AccountTypeID = 1
			and type in ('OriginationFeeStripping','OriginationFeeStripReceivable')
			group by tr.Scenario,d.dealid
		)as tblOriginationFee on tblOriginationFee.dealid = d.dealid AND tblOriginationFee.Scenario = a.[Name]

		where d.[Status] = 'Active'
		AND AP.IncludeInDiscrepancy=3
		and  d.dealid in (Select Distinct d1.credealid from cre.deal d1
		inner join cre.note n on n.dealid = d1.dealid
		where n.Actualpayoffdate is null and d1.[Status] = 323)
		AND d.DealName NOT LIKE '%copy%'

	)a
	where ROUND(ExtentionFee,2) <> 0 or ROUND(ExitFee,2) <> 0 or ROUND(OriginationFee,2) <> 0

GO