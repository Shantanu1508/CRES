CREATE TABLE [CRE].[RuleTypeMaster] (
	[RuleTypeMasterID]            Int IDENTITY (1, 1) NOT NULL,
	RuleTypeName	nvarchar(256) null,
	Comments	nvarchar(256) null,
	IsActive	bit null,
	
	[CreatedBy]          NVARCHAR (256)   NULL,
	[CreatedDate]        DATETIME         NULL,
	[UpdatedBy]          NVARCHAR (256)   NULL,
	[UpdatedDate]        DATETIME         NULL,   
   GroupName Nvarchar(255) NULL
    CONSTRAINT [PK_RuleTypeMasterID] PRIMARY KEY CLUSTERED ([RuleTypeMasterID] ASC)
);

