CREATE View [dbo].[TransactionEntry_ExclueGAAP_PV]
as

Select T.Noteid, T.Date,T.Amount,T.Type, T.NoteKey from DBO.Transactionentry T
Left join dbo.Note N On T.Notekey = N.NoteKey
Where Type not in ( 'EndingGAAPBookValue','EndingPVBookValue','LIBORPercentage', 'SpreadPercentage')  
and T.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

and T.AccountTypeID = 1

