CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForSuspenseTransaction] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	Select DealName,CRENoteID,ActualDelta,Tr_Amount as SuspenceTran,(ActualDelta + tr_Amount) as Delta_Diff
	from (
		select d.dealname,n.crenoteid,nt.noteid ,SUM(nt.ActualDelta) ActualDelta,tr.Amount as tr_Amount
		from cre.notetransactiondetail nt
		inner join cre.note n on n.noteid = nt.noteid
		inner join cre.deal d on d.dealid = n.dealid
		inner join core.account acc on acc.accountid = n.account_accountid
		Left Join (
			Select n.noteid,Amount 
			from cre.transactionentry tr
			inner join core.account acc on acc.accountid = tr.AccountID
			inner join cre.note n on n.Account_AccountID = acc.AccountID
			where  analysisid = 'c10f3372-0fc2-4861-a9f5-148f1f80804f'		
			and [type] = 'AccruedInterestSuspense'
			and acc.AccountTypeID = 1
		)tr on tr.noteid = nt.noteid
		where acc.isdeleted <> 1	
		and TransactionTypeText in (Select TransactionName from cre.TransactionTypes where TransactionGroup = 'Interest')
		and n.enablem61Calculations = 3
		and d.DealName NOT LIKE '%copy%'
		group by nt.noteid,tr.Amount,d.dealname,n.crenoteid
	)a
	where ActualDelta <> 0
	and (ActualDelta + tr_Amount)  <> 0
	order by dealname,crenoteid


 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END     