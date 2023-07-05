CREATE TABLE [CRE].[JsonTemplate]
(
	[Id] INT IDENTITY (1, 1) NOT NULL,
	[Key] NVARCHAR(50),
	[Value] VARCHAR(MAX),
	[Type] NVARCHAR(100),
	[FileName] NVARCHAR(500),
	JsonTemplateMasterID int  

	CONSTRAINT [PK_JsonTemplate_ID] PRIMARY KEY CLUSTERED (Id ASC)
)
