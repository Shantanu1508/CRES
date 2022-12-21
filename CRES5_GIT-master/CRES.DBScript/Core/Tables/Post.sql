CREATE TABLE [Core].[Post] (
    [PostID]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ObjectID]      UNIQUEIDENTIFIER NULL,
    [CommentTypeID] INT              NOT NULL,
    [Comments]      TEXT             NOT NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    CONSTRAINT [PK_PostID] PRIMARY KEY CLUSTERED ([PostID] ASC)
);

