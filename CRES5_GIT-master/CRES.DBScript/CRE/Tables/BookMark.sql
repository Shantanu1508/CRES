CREATE TABLE [CRE].[BookMark] (
    [BookMarkID]                              INT IDENTITY (1, 1) NOT NULL,
    [AccountID]                               UNIQUEIDENTIFIER NULL,
	[UserID]                                  NVARCHAR (256)   NULL,
	[CreatedBy]                               NVARCHAR (256)   NULL,
    [CreatedDate]                             DATETIME         NULL,
    [UpdatedBy]                               NVARCHAR (256)   NULL,
    [UpdatedDate]                             DATETIME         NULL

	CONSTRAINT [PK_BookMarkID] PRIMARY KEY CLUSTERED ([BookMarkID] ASC)
);

GO