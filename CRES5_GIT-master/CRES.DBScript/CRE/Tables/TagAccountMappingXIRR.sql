CREATE TABLE [CRE].[TagAccountMappingXIRR] (
    [TagAccountMappingXIRRID]    INT            IDENTITY (1, 1) NOT NULL,    
	[TagAccountMappingXIRRGUID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]        UNIQUEIDENTIFIER NOT NULL,   
	[TagMasterXIRRID]    INT NOT NULL,   
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
   [ColumnForDeleteAndTesting] INT              NULL,
    CONSTRAINT [PK_TagAccountMappingXIRRID] PRIMARY KEY CLUSTERED ([TagAccountMappingXIRRID] ASC),

	CONSTRAINT [FK_Account_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID]),
	CONSTRAINT [FK_TagMasterXIRR_TagMasterXIRRID] FOREIGN KEY (TagMasterXIRRID) REFERENCES [CRE].[TagMasterXIRR] (TagMasterXIRRID),
);





