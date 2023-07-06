-- drop INDEX NotePeriodicCalc_AI_Client ON cre.NotePeriodicCalc

CREATE INDEX NotePeriodicCalc_AI_Client
ON cre.NotePeriodicCalc (NotePeriodicCalcAutoID, NoteId, AnalysisID,[Month]);