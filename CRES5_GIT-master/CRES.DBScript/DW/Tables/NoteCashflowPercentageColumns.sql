CREATE TABLE [DW].[NoteCashflowPercentageColumns] (
    [NoteCashflowPercentageColumnsID]           INT              IDENTITY (1, 1) NOT NULL,	
	analysisID	UNIQUEIDENTIFIER  NULL,
	Noteid	UNIQUEIDENTIFIER  NULL, 
	date_dt	date,
	LIBORPercentage	decimal(28,15) null,
	PIKInterestPercentage	decimal(28,15) null,
	SpreadPercentage	decimal(28,15) null,
	PIKLiborPercentage	decimal(28,15) null,
	RawIndexPercentage	decimal(28,15) null,
	RawPIKIndexPercentage decimal(28,15) null,
	EffectiveRate decimal(28,15) null

    CONSTRAINT [PK_NoteCashflowPercentageColumnsID] PRIMARY KEY CLUSTERED ([NoteCashflowPercentageColumnsID] ASC)
);



go

CREATE INDEX idx_NoteCashflowPercentageColumn_noteid_date_dt_analysisID
ON  [DW].[NoteCashflowPercentageColumns]  (NoteId, AnalysisID,date_dt);


