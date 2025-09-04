UPDATE DW.TransactionentryBI SET DW.TransactionentryBI.AllInCouponRate = a.AllInCouponRate
From(
    Select AnalysisID,TransactionEntryID,AllInCouponRate
	from cre.Transactionentry tr
    inner join core.account acc on acc.accountid = tr.accountid
	where acc.isdeleted <> 1
	and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and AllInCouponRate is not null
)a
Where DW.TransactionentryBI.TransactionEntryID = a.TransactionEntryID and DW.TransactionentryBI.AnalysisID = a.AnalysisID
and DW.TransactionentryBI.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'