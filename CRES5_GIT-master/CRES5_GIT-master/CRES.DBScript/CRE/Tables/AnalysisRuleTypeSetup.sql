

CREATE TABLE [CRE].[AnalysisRuleTypeSetup] (
	[AnalysisRuleTypeSetupID]            Int IDENTITY (1, 1) NOT NULL,		
	AnalysisID	UNIQUEIDENTIFIER null,
	RuleTypeMasterID	int null,
	RuleTypeDetailID	int null,
	
	[CreatedBy]          NVARCHAR (256)   NULL,
	[CreatedDate]        DATETIME         NULL,
	[UpdatedBy]          NVARCHAR (256)   NULL,
	[UpdatedDate]        DATETIME         NULL,   
   
    CONSTRAINT [PK_AnalysisRuleTypeSetupID] PRIMARY KEY CLUSTERED ([AnalysisRuleTypeSetupID] ASC)
);
