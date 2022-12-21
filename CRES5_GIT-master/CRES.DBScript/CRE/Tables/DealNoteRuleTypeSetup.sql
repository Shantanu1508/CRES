CREATE TABLE [CRE].[DealNoteRuleTypeSetup] (
	[DealNoteRuleTypeSetupID]            Int IDENTITY (1, 1) NOT NULL,	
	AnalysisID	UNIQUEIDENTIFIER null,
	DealID	UNIQUEIDENTIFIER null,
	NoteID	UNIQUEIDENTIFIER null,
	RuleTypeMasterID	int null,
	RuleTypeDetailID	int null,
	
	[CreatedBy]          NVARCHAR (256)   NULL,
	[CreatedDate]        DATETIME         NULL,
	[UpdatedBy]          NVARCHAR (256)   NULL,
	[UpdatedDate]        DATETIME         NULL,   
   
    CONSTRAINT [PK_DealNoteRuleTypeSetup] PRIMARY KEY CLUSTERED ([DealNoteRuleTypeSetupID] ASC)
);
