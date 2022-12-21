

CREATE PROCEDURE [DW].[usp_MergeNoteTranchePercentage]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 



----=============================
----Update Note Delphi Percentage
--Declare @tblNoteDelphiPercentage as table
--(
--	NoteId_F nvarchar(256) null,
--	SoldDate	Date null,
--	TrancheName	 nvarchar(256) null,
--	PercentofNote decimal(28,15) null,
--	ShardName nvarchar(256) null
--)

--INSERT INTO @tblNoteDelphiPercentage (NoteId_F,SoldDate,TrancheName,PercentofNote,ShardName)
--EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
--@stmt = N'SELECT NoteId_F,SoldDate,TrancheName,PercentofNote
--FROM [acore].[vw_AcctNoteExitPlan] n'


--Update CRE.Note set 
--CRE.Note.RSLIC = a.RSLIC,
--CRE.Note.SNCC = a.SNCC,
--CRE.Note.PIIC = a.PIIC,
--CRE.Note.TMR = a.TMR,
--CRE.Note.HCC = a.HCC,
--CRE.Note.USSIC = a.USSIC,
--CRE.Note.TMNF = a.TMNF,
--CRE.Note.HAIH = a.HAIH,
--CRE.Note.TotalParticipation = a.TotalParticipation

--From(
--	SELECT NoteId_F ,RSLIC,SNCC,PIIC,TMR,HCC,USSIC,TMNF,HAIH,(ISNULL(RSLIC,0)+ISNULL(SNCC,0)+ISNULL(PIIC,0)+ISNULL(TMR,0)+ISNULL(HCC,0)+ISNULL(USSIC,0)+ISNULL(TMNF,0)+ISNULL(HAIH,0)) TotalParticipation
--	FROM   
--	(
--		Select NoteId_F,TrancheName,PercentofNote  from @tblNoteDelphiPercentage
--	) t 
--	PIVOT(
--		SUM(PercentofNote) 
--		FOR TrancheName IN (RSLIC,SNCC,PIIC,TMR,HCC,USSIC,TMNF,HAIH)
--	) AS pivot_table
--)a
--WHERE CRE.Note.crenoteid = CAST(a.NoteId_F as varchar(256))
--------------------------------------------------------------

--Truncate table CRE.NoteTranchePercentage 
--INSERT INTO CRE.NoteTranchePercentage (CRENoteID,SoldDate,TrancheName,PercentofNote)
--Select NoteId_F,SoldDate,TrancheName,PercentofNote from @tblNoteDelphiPercentage
------==============================================




---Send to warehouse
TRUNCATE TABLE DW.NoteTranchePercentageBI

INSERT INTO DW.NoteTranchePercentageBI(NoteTranchePercentageID,CRENoteId,SoldDate,TrancheName,PercentofNote)
Select NoteTranchePercentageID,CRENoteId,SoldDate,TrancheName,PercentofNote from cre.NoteTranchePercentage


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

Print(char(9) +'usp_MergeNoteTranchePercentage - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

