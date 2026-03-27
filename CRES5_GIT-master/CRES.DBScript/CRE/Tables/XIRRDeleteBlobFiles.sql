CREATE TABLE [CRE].[XIRRDeleteBlobFiles]
(
	[XIRRDeleteBlobFilesID] INT IDENTITY(1,1) NOT NULL,
	[FileName] nvarchar(256),
	[Path] nvarchar(256),
	[IsDelete] BIT  NULL,
	[CreatedDate] DateTime default getdate() NOT NULL,
	[UpdatedDate] [datetime] NULL,
	CONSTRAINT [PK_XIRRDeleteBlobFiles] PRIMARY KEY CLUSTERED ([XIRRDeleteBlobFilesID] ASC)
)
