
Create View [dbo].[NotesafterNoteTransfer]
As
Select N.Noteid, dealName, n.ClosingDate from Note N
Inner join (
Select D.DealKey, DealName, Max(ClosingDate)ClosingDate from [DealMultiClosingDates] D
Inner join Note N on D.DealKey = N.DealKey
Group By DealName,d.DealKey)x
on N.DealKey = X.DealKey and x.Closingdate = N.closingdate

