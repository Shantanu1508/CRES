

ALTER TABLE [Core].[CalculationRequests] ADD [AccountId] UNIQUEIDENTIFIER  NULL

go

UPDATE [Core].[CalculationRequests] SET [Core].[CalculationRequests].Accountid = a.accountid
From(
    Select noteid,acc.accountid from cre.note n
    inner join core.account acc on acc.accountid = n.account_accountid
    where acc.isdeleted <> 1
)a
Where [Core].[CalculationRequests].noteid = a.noteid




Drop index nci_wi_CalculationRequests_544B98748F2B64520F6B556014288438 On [Core].[CalculationRequests] 
Drop index nci_wi_CalculationRequests_52101B57D283EEB38580F0ABBE5ABCA0 On [Core].[CalculationRequests] 

ALTER  TABLE [Core].[CalculationRequests] DROP COLUMN NoteID
