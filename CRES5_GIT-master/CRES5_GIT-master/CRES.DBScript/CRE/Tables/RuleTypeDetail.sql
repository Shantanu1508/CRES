
CREATE TABLE [CRE].[RuleTypeDetail] (
	[RuleTypeDetailID]            Int IDENTITY (1, 1) NOT NULL,
	[RuleTypeMasterID]            Int not null,	
	[FileName]	nvarchar(256) null,
	Content	nvarchar(MAX) null,
	DBFileName	nvarchar(256) null,
	IsBalanceAware	bit default(0),
	[Type]	nvarchar(256) null,
	[CreatedBy]          NVARCHAR (256)   NULL,
	[CreatedDate]        DATETIME         NULL,
	[UpdatedBy]          NVARCHAR (256)   NULL,
	[UpdatedDate]        DATETIME         NULL,   
   
    CONSTRAINT [PK_RuleTypeDetailID] PRIMARY KEY CLUSTERED ([RuleTypeDetailID] ASC)
);