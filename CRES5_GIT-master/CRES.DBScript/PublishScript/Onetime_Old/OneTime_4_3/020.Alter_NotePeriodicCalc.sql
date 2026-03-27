ALTER TABLE CRE.Noteperiodiccalc ADD [AccountId] UNIQUEIDENTIFIER  NULL

go

UPDATE CRE.Noteperiodiccalc SET CRE.Noteperiodiccalc.Accountid = a.accountid
From(
    Select noteid,acc.accountid from cre.note n
    inner join core.account acc on acc.accountid = n.account_accountid
    where acc.isdeleted <> 1
)a
Where CRE.Noteperiodiccalc.noteid = a.noteid
and CRE.Noteperiodiccalc.noteid in 
(
       Select noteid --,''''+cAST(noteid as nvarchar(256))+''',' 
       from cre.note n
    inner join core.account acc on acc.accountid = n.account_accountid
    where acc.isdeleted <> 1
)


go



Drop index nci_wi_NotePeriodicCalc_CA36AE89D965FB43B80BC3D87E3CC660 On [CRE].[NOtePeriodicCalc] 
Drop index nci_wi_NotePeriodicCalc_E09009C71827099A855273A4F7BB0D9B On [CRE].[NOtePeriodicCalc] 
Drop index IX_NotePeriodicCalc_NoteID On [CRE].[NOtePeriodicCalc]
Drop index NotePeriodicCalc_AI_Client On [CRE].[NOtePeriodicCalc]
 
ALTER  TABLE [CRE].[NOtePeriodicCalc] DROP CONSTRAINT FK_NotePeriodicCalc_NoteID

ALTER  TABLE [CRE].[NOtePeriodicCalc] DROP COLUMN NoteID

ALTER  TABLE [CRE].[NOtePeriodicCalc] ADD CONSTRAINT [FK_NOtePeriodicCalc_Account_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [CORE].[Account] ([AccountID])



---Create INdex
CREATE NONCLUSTERED INDEX [IX_NotePeriodicCalc_AccountID] ON [CRE].[NotePeriodicCalc] ([AccountID]) INCLUDE ([PeriodEndDate], [TotalCouponStrippedforthePeriod], [OriginationFeeStripping], [ExitFeeStrippingExcldfromLevelYield], [AddlFeesStrippingExcldfromLevelYield])
CREATE NONCLUSTERED INDEX [nci_wi_NotePeriodicCalc_374A6F8F737D2A164B9A04E52B9D20A3] ON [CRE].[NotePeriodicCalc] ([AccountID], [PeriodEndDate], [AnalysisID]) INCLUDE ([EndingBalance])
CREATE NONCLUSTERED INDEX [nci_wi_NotePeriodicCalc_CA36AE89D965FB43B80BC3D87E3CC660] ON [CRE].[NotePeriodicCalc] ([AnalysisID], [AccountID]) INCLUDE ([UpdatedDate])
CREATE NONCLUSTERED INDEX [nci_wi_NotePeriodicCalc_E09009C71827099A855273A4F7BB0D9B] ON [CRE].[NotePeriodicCalc] ([AnalysisID], [AccountID]) INCLUDE ([UpdatedBy], [UpdatedDate])
CREATE NONCLUSTERED INDEX [NotePeriodicCalc_AI_Client] ON [CRE].[NotePeriodicCalc] ([NotePeriodicCalcAutoID], [AccountID], [AnalysisID], [Month])