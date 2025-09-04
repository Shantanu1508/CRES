Create Table [DW].[NPCEndingBalanceDefaultScenario]
(
	AnalysisID UNIQUEIDENTIFIER,
	Noteid Nvarchar(256) NULL,
	EndingBalance decimal(28,15) NULL,
	PeriodEndDate Date NULL
);