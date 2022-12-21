CREATE TABLE [CRE].[JsonTemplateMaster]
(
	[JsonTemplateMasterID] INT IDENTITY (1, 1) NOT NULL,
	[TemplateName] NVARCHAR(50),
	[Comment] VARCHAR(MAX),
	[CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL
	
	CONSTRAINT [PK_JsonTemplateMasterID] PRIMARY KEY CLUSTERED (JsonTemplateMasterID ASC)
)
