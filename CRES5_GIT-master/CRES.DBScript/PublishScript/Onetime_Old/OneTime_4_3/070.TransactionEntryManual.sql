ALTER TABLE CRE.TransactionentryManual ADD [AccountId] UNIQUEIDENTIFIER  NULL

 

go

 

UPDATE CRE.TransactionentryManual SET CRE.TransactionentryManual.Accountid = a.accountid
From(
    Select noteid,acc.accountid from cre.note n
    inner join core.account acc on acc.accountid = n.account_accountid
    where acc.isdeleted <> 1
)a
Where CRE.TransactionentryManual.noteid = a.noteid

 
go

 

ALTER  TABLE CRE.TransactionentryManual DROP CONSTRAINT FK_TransactionEntryManual_Note_NoteID
ALTER  TABLE [CRE].[TransactionEntryManual] DROP COLUMN NoteID

 

ALTER  TABLE [CRE].[TransactionEntryManual] ADD CONSTRAINT [FK_TransactionEntryManual_Account_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [CORE].[Account] ([AccountID])