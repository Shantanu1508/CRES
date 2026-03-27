CREATE TABLE [IO].[L_M61AddinLandingTagXIRR] (
    [M61AddinLandingTagXIRRID] INT     IDENTITY (1, 1) NOT NULL,
    [BatchLogGenericID] INT            NULL,
    [TableName]         NVARCHAR (256) NULL,
	[ObjectID]          NVARCHAR (256) NULL,
	[TagID]             INT            NULL,
	[TagName]           NVARCHAR (256) NULL,
	[Status]            NVARCHAR (100) NULL,
	[Comment]           NVARCHAR (MAX) NULL,
    [CreatedDate]       DATETIME       NULL,
	[CreatedBy]         NVARCHAR (256) NULL,
    [UpdatedDate]       DATETIME       NULL,
	[UpdatedBy]         NVARCHAR (256) NULL,
	CONSTRAINT [PK_M61AddinLandingTagXIRRID] PRIMARY KEY CLUSTERED ([M61AddinLandingTagXIRRID] ASC)
);
    
