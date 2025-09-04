CREATE TABLE [CRE].[TagMasterXIRR] (
    [TagMasterXIRRID]    INT            IDENTITY (1, 1) NOT NULL,    
	[TagMasterXIRRGUID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]        NVARCHAR (256) NOT NULL,   
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
  
    CONSTRAINT [PK_TagMasterXIRRID] PRIMARY KEY CLUSTERED ([TagMasterXIRRID] ASC)
);





