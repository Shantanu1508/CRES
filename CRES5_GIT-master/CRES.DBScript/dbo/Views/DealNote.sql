-- View
Create View DealNote
As 
Select creDealid, Crenoteid, DealName from Dw.NoteBI N
Inner join Dw.DealBI D on N.dealid = D.Dealid