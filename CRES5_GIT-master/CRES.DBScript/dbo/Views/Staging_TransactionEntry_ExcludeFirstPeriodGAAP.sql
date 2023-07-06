CREATE View [dbo].[Staging_TransactionEntry_ExcludeFirstPeriodGAAP]
as

Select T.Noteid, T.Date,T.Amount,T.Type, T.Notekey from DBO.Staging_Transactionentry T
Left join dbo.Note N On T.Notekey = N.NoteKey
Where Type = 'EndingGAAPBookValue' and Eomonth(ClosingDate,0) <>  T.Date

