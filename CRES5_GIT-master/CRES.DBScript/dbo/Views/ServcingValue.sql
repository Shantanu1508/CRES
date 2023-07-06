CREATE View [dbo].[ServcingValue]
as
Select Distinct CRENOTEID, 'Yes' As SevcingValues from cre.NoteTransactionDetail T
Inner join Cre.Note N on N.NoteID = T.Noteid
