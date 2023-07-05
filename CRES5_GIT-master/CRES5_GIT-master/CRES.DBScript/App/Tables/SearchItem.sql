CREATE TABLE [App].[SearchItem] (
    [SearchItemID]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [SearchDate]          DATETIME         NULL,
    [Object_ObjectAutoID] UNIQUEIDENTIFIER NULL,
    [SearchText]          VARCHAR (256)    NULL,
    [Rank]                INT              NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    [SearchObjectType]    INT              NULL,
    CONSTRAINT [PK_SearchItemID] PRIMARY KEY CLUSTERED ([SearchItemID] ASC),
    CONSTRAINT [PK_SearchItem_Object_ObjectAutoID] FOREIGN KEY ([Object_ObjectAutoID]) REFERENCES [App].[Object] ([ObjectAutoID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SearchItem_SearchText]
    ON [App].[SearchItem]([SearchText] ASC)
    INCLUDE([Object_ObjectAutoID], [Rank]);

