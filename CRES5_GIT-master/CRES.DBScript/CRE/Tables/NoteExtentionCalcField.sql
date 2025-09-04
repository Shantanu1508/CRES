CREATE TABLE [CRE].[NoteExtentionCalcField] (
	[NoteExtentionCalcFieldID]	INT IDENTITY(1,1) NOT NULL,
	[AccountID]					UNIQUEIDENTIFIER NOT NULL,
	[AnalysisID]				UNIQUEIDENTIFIER NOT NULL,
	[SelectedMaturityDate]		Date,
    [CreatedBy]					NVARCHAR (256)   NULL,
	[CreatedDate]				DATETIME         NULL,
	[UpdatedBy]					NVARCHAR (256)   NULL,
	[UpdatedDate]				DATETIME         NULL,
	CONSTRAINT [PK_NoteExtentionCalcFieldID] PRIMARY KEY CLUSTERED ([NoteExtentionCalcFieldID] ASC)
);