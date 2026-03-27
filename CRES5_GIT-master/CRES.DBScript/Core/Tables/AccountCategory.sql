CREATE TABLE [Core].[AccountCategory] (
    [AccountCategoryID] INT            IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (256) NOT NULL,
    [Type]              NVARCHAR (256) NULL,
    [AssetOrLiability]  INT            NULL,
    [Priority]          SMALLINT       NOT NULL,
    [CreatedBy]         NVARCHAR (256) NULL,
    [CreatedDate]       DATETIME       NULL,
    [UpdatedBy]         NVARCHAR (256) NULL,
    [UpdatedDate]       DATETIME       NULL,
	[SortOrder]			INT            NULL,
    CONSTRAINT [PK_AccountCategoryID] PRIMARY KEY CLUSTERED ([AccountCategoryID] ASC)
);


GO
ALTER TABLE [Core].[AccountCategory] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO

