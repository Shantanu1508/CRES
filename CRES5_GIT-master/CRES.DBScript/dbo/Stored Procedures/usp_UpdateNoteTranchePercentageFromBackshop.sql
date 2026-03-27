CREATE PROCEDURE [dbo].[usp_UpdateNoteTranchePercentageFromBackshop]
@CRENoteId nvarchar(256)
AS
	BEGIN
	
	Declare @tblNoteDelphiPercentage as table
(
	NoteId_F nvarchar(256) null,
	SoldDate	Date null,
	TrancheName	 nvarchar(256) null,
	PercentofNote decimal(28,15) null,
	ShardName nvarchar(256) null
)

declare @qry nvarchar(max) = N'SELECT NoteId_F,SoldDate,TrancheName,PercentofNote
FROM [acore].[vw_AcctNoteExitPlan] n where NoteId_F='''+CAST(@CRENoteId as nvarchar(256))+''''


INSERT INTO @tblNoteDelphiPercentage (NoteId_F,SoldDate,TrancheName,PercentofNote,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt=@qry


Update CRE.Note set 
CRE.Note.RSLIC = a.RSLIC,
CRE.Note.SNCC = a.SNCC,
CRE.Note.PIIC = a.PIIC,
CRE.Note.TMR = a.TMR,
CRE.Note.HCC = a.HCC,
CRE.Note.USSIC = a.USSIC,
CRE.Note.TMNF = a.TMNF,
CRE.Note.HAIH = a.HAIH,
CRE.Note.TotalParticipation = a.TotalParticipation,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
From(
	SELECT NoteId_F 
	,pivot_table.RSLIC
	,pivot_table.SNCC
	,pivot_table.PIIC
	,pivot_table.TMR
	,pivot_table.HCC
	,pivot_table.USSIC
	,pivot_table.TMNF
	,pivot_table.HAIH
	,(ISNULL(pivot_table.RSLIC,0)+ISNULL(pivot_table.SNCC,0)+ISNULL(pivot_table.PIIC,0)+ISNULL(pivot_table.TMR,0)+ISNULL(pivot_table.HCC,0)+ISNULL(pivot_table.USSIC,0)+ISNULL(pivot_table.TMNF,0)+ISNULL(pivot_table.HAIH,0)) TotalParticipation
	FROM   
	(
		Select NoteId_F,TrancheName,PercentofNote  from @tblNoteDelphiPercentage
	) t 
	PIVOT(
		SUM(PercentofNote) 
		FOR TrancheName IN (RSLIC,SNCC,PIIC,TMR,HCC,USSIC,TMNF,HAIH)
	) AS pivot_table
	inner join cre.note n on n.crenoteid = pivot_table.noteid_f

	Where (
	iSNULL(pivot_table.RSLIC,0) <> iSNULL(n.RSLIC,0) OR
	iSNULL(pivot_table.SNCC,0) <> iSNULL(n.SNCC,0) OR
	iSNULL(pivot_table.PIIC,0) <> iSNULL(n.PIIC,0) OR
	iSNULL(pivot_table.TMR,0) <> iSNULL(n.TMR,0) OR
	iSNULL(pivot_table.HCC,0) <> iSNULL(n.HCC,0) OR
	iSNULL(pivot_table.USSIC,0) <> iSNULL(n.USSIC,0) OR
	iSNULL(pivot_table.TMNF,0) <> iSNULL(n.TMNF,0) OR
	iSNULL(pivot_table.HAIH,0) <> iSNULL(n.HAIH,0) 
	)

)a
WHERE CRE.Note.crenoteid = CAST(a.NoteId_F as varchar(256))
------------------------------------------------------------

delete from CRE.NoteTranchePercentage where CRENoteId=@CRENoteId
INSERT INTO CRE.NoteTranchePercentage (CRENoteID,SoldDate,TrancheName,PercentofNote)
Select NoteId_F,SoldDate,TrancheName,PercentofNote from @tblNoteDelphiPercentage
END