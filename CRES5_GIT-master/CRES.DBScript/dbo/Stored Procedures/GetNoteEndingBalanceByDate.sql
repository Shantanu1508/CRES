

Create Procedure dbo.GetNoteEndingBalanceByDate
(
@Dealid varchar(50),
@BalanceAsofDate datetime
)
as 
BEGIN

select 
n.noteid as NoteID,
acc.Name as 'Name',
di.date as Date,
di.EndingBalance as EndingBalance
from [CRE].[DailyInterestAccruals] di
Inner join cre.note n on n.noteid = di.noteid
Inner join core.account acc on acc.accountid = n.account_accountid
Inner join cre.deal d on d.dealid = n.dealid
where di.AnalysisID= 'c10f3372-0fc2-4861-a9f5-148f1f80804f'
and acc.isdeleted <> 1
and d.dealid = @Dealid
and di.date=@BalanceAsofDate
Order by n.noteid,di.date,di.EndingBalance

END