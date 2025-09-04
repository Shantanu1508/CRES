-- Procedure
 
CREATE PROCEDURE [dbo].[usp_InsertUpdateNotePeriodicCalcByNoteID_V1] 
	@tbltypeNotePeriodicCalc [tbltype_NotePeriodicCalc_V1] READONLY,
	@AnalysisID UNIQUEIDENTIFIER,
	@CreatedBy nvarchar(256)
AS
BEGIN
 
	IF(@AnalysisID is not null)
	BEGIN
		
		Delete from CRE.NotePeriodicCalc where AnalysisID = @AnalysisID and AccountID in (
			Select n.Account_AccountID --n.noteid 
			FROM cre.note n 	
			WHERE n.creNoteID in (Select distinct note from @tbltypeNotePeriodicCalc)
			
		)
		

		INSERT INTO [CRE].[NotePeriodicCalc]
		(--[NoteID]
		AccountID
		,[PeriodEndDate]
		,[Month]
		,[BeginningBalance]
		,[EndingBalance]
		,[ScheduledPrincipal]
		,[TotalDiscretionaryCurtailmentsforthePeriod]
		,AnalysisID
		,createdby
		,createddate
		,updatedby
		,updateddate
		)
		Select 
		--n.noteid
		n.Account_AccountID
		,[Date]	
		,(CASE WHEN EOMONTH([Date]) = [Date] THEN MONTH([Date]) ELSE null END) as [Month]
		,[initbal]			
		,[endbal]			
		,[schprin]			
		,[funding_fundpydn]
		,@AnalysisID
		,@CreatedBy
		,getdate()
		,@CreatedBy
		,getdate()
		From  @tbltypeNotePeriodicCalc t
		inner join cre.note n on n.crenoteid = t.note

	END

END
GO

