CREATE view PIKnbetweenWireConfirmAuospreadStartDate
as

Select Distinct d.dealid,d.CREDealID,dealname
from cre.Note n
inner join cre.Deal d on n.DealID = d.DealID
inner join core.Account acc on acc.accountid = n.account_accountid
left join core.lookup l on l.lookupid = d.Status

Inner join(
	Select dealid,MAX_Wire_Date,MIN_PayDown_Date,date
	from (
		Select df.dealid,MAX(df.date) as MAX_Wire_Date,tblPayDown.MIN_PayDown_Date,tbltr.date
		from cre.DealFunding df
		INNER JOIN(
			Select dealid,MIN(date) as MIN_PayDown_Date
			from cre.DealFunding 
			where applied <> 1 and PurposeID = 631
			group by dealid
		)tblPayDown on tblPayDown.dealid = df.DealID
		inner  Join(
			Select d.dealid,n.noteid,tr.Date,tr.amount 
			from cre.TransactionEntry tr
			Inner join cre.note n on n.Account_AccountID = tr.AccountID
			inner join cre.deal d on d.dealid = n.dealid
			where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and [Type] = 'PIKPrincipalFunding'
		)tblTr on  tblTr.dealid = df.dealid 
		where df.applied = 1
		group by df.dealid,tblPayDown.MIN_PayDown_Date,tbltr.date

	)z
	--where (date >= MAX_Wire_Date
	--and date <= (Case when Cast(Getdate() as date)< MIN_PayDown_Date THEN Cast(Getdate() as date) else MIN_PayDown_Date end))
	Where Date>=  MIN_PayDown_Date

)tbldealsBtwRange on tbldealsBtwRange.dealid = d.DealID


where d.isdeleted <> 1 and acc.IsDeleted <> 1 
and n.ActualPayoffDate is null
and l.name = 'Active'
--and UseRuletoDetermineNoteFunding = 3