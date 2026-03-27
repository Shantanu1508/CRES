CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntry_ParentAccountId]
    ON [CRE].[TransactionEntry]([AnalysisID] ASC, [AccountID] ASC, ParentAccountId ASC)
    INCLUDE([Amount], [Date], [FeeName], [RemitDate], [TransactionDateServicingLog], [Type]);




  CREATE NONCLUSTERED INDEX [nci_wi_TransactionEntryBI_type]
    ON [DW].[TransactionEntryBI]([AnalysisID] ASC, [NoteID] ASC, [type] ASC)
    INCLUDE([Amount], [Date]);



CREATE NONCLUSTERED INDEX [nci_wi_XIRRInputCashflow]
ON [CRE].[XIRRInputCashflow](XIRRConfigID ASC,[AnalysisID] ASC )
INCLUDE([TransactionType],[Amount], [TransactionDate]);


CREATE NONCLUSTERED INDEX [nci_wi_XIRRInputCashflow_XIRRReturnGroupID]
ON [CRE].[XIRRInputCashflow](XIRRConfigID ASC,XIRRReturnGroupID,DealAccountID,[AnalysisID] ASC )
INCLUDE([TransactionType],[Amount], [TransactionDate]);