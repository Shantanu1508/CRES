-- View
CREATE view [dbo].[DailyInterestAccruals]
as 

select DailyInterestAccrualsID,
	DailyInterestAccrualsGUID,
	NoteID as NoteKey,
	CreNoteID as NoteID,
	[Date],
    [DailyInterestAccrual],
	[AnalysisID],
	AnalysisName as Scenario,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate
From [DW].DailyInterestAccrualsBI


