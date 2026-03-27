
ALTER TABLE CRE.Transactionentry ADD [AccountId] UNIQUEIDENTIFIER  NULL

go


UPDATE CRE.Transactionentry SET CRE.Transactionentry.Accountid = a.accountid
From(
    Select noteid,acc.accountid from cre.note n
    inner join core.account acc on acc.accountid = n.account_accountid
    where acc.isdeleted <> 1
)a
Where CRE.Transactionentry.noteid = a.noteid
and CRE.Transactionentry.noteid in 
(
    Select noteid --,''''+cAST(noteid as nvarchar(256))+''','
    from cre.note n
    inner join core.account acc on acc.accountid = n.account_accountid
    where acc.isdeleted <> 1
)





go



Drop index nci_wi_TransactionEntry_67744DE156B187E67EAACCD78DF84D89 On [CRE].[TransactionEntry] 
Drop index nci_wi_TransactionEntry_C1B11EC5A1F89BFB9B19FDFE7AA18E31 On [CRE].[TransactionEntry] 
ALTER  TABLE [CRE].[TransactionEntry] DROP CONSTRAINT FK_TransactionEntry_Note_NoteID


ALTER  TABLE [CRE].[TransactionEntry] DROP COLUMN NoteID

ALTER  TABLE [CRE].[TransactionEntry] ADD CONSTRAINT [FK_TransactionEntry_Account_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [CORE].[Account] ([AccountID])


---Create Index

CREATE NONCLUSTERED INDEX [Index_TransactionEntry_AnalysisID_AccountID_Date]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [AccountID] ASC, [Date] ASC)
    INCLUDE([Amount], [FeeName], [Type]);


GO
CREATE NONCLUSTERED INDEX [Index_TransactionEntry_AnalysisID_AccountID_TransactionDateByRule]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [AccountID] ASC, [TransactionDateByRule] ASC)
    INCLUDE([Amount], [Date], [FeeName], [RemitDate], [TransactionDateServicingLog], [Type]);