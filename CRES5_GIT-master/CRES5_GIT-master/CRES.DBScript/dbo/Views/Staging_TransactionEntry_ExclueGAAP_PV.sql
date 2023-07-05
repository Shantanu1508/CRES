CREATE View [dbo].[Staging_TransactionEntry_ExclueGAAP_PV]
as

Select T.Noteid, T.Date,T.Amount,T.Type, T.NoteKey from DBO.Staging_Transactionentry T 
Left join dbo.Note N On T.Notekey = N.NoteKey
Where Type not in ( 'EndingGAAPBookValue','EndingPVBookValue', 'LIBORPercentage', 'SpreadPercentage')  

