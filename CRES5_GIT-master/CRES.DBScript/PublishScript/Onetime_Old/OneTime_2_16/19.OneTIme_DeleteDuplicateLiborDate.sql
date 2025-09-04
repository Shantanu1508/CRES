
Print('Delete duplicate libor date')
go

Delete from core.indexes  where IndexesIntId in (
	Select IndexesIntId from(
		Select IndexesIntId,IndexesMasterID,Date,IndexType,
		ROW_NUMBER() Over (Partition by IndexesMasterID,IndexType,Date order by IndexesMasterID,IndexType,Date) rno
		from core.indexes 
		where IndexesMasterID = 1		
	)a
	where a.rno > 1
)

GO

Delete from core.indexes  where IndexesIntId in (
	Select IndexesIntId from(
		Select IndexesIntId,IndexesMasterID,Date,IndexType,
		ROW_NUMBER() Over (Partition by IndexesMasterID,IndexType,Date order by IndexesMasterID,IndexType,Date) rno
		from core.indexes 
		where IndexesMasterID = 2	
	)a
	where a.rno > 1
)

GO

Delete from core.indexes  where IndexesIntId in (
	Select IndexesIntId from(
		Select IndexesIntId,IndexesMasterID,Date,IndexType,
		ROW_NUMBER() Over (Partition by IndexesMasterID,IndexType,Date order by IndexesMasterID,IndexType,Date) rno
		from core.indexes 
		where IndexesMasterID = 3	
	)a
	where a.rno > 1
)