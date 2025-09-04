Update cre.note set cre.note.NoteType = z.NoteType_Update
From(
	Select n.noteid, ISNULL(lNoteType.[Name],'Debt') as NoteType,ISNULL(n.NoteType,902) as NoteType_Update
	from CRE.Deal D 
	INNER JOIN CRE.Note N on D.DealID = N.DealID
	INNER JOIN Core.Account accN ON accN.AccountID = N.Account_AccountID
	LEFT JOIN Core.Lookup lNoteType ON lNotetype.LookupID = N.NoteType
	Left  join core.lookup lstatus on lstatus.LookupID = d.[Status]
	Where accN.IsDeleted <> 1
	and lstatus.name <> 'Inactive'	--order by D.DealName

)z
Where cre.note.NoteID = z.NoteID


