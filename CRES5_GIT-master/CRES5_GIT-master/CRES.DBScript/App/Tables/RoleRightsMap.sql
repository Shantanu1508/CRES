CREATE TABLE [App].[RoleRightsMap] (
    [RoleRightsMapID] UNIQUEIDENTIFIER CONSTRAINT [DF__RoleRight__RoleR__025D5595] DEFAULT (newid()) NOT NULL,
    [RoleID]          UNIQUEIDENTIFIER NOT NULL,
    [RightsID]        UNIQUEIDENTIFIER NOT NULL,
    [StatusID]        INT              NOT NULL,
    [CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
    CONSTRAINT [PK_RoleRightsMapID] PRIMARY KEY CLUSTERED ([RoleRightsMapID] ASC),
    CONSTRAINT [FK_RoleRightsMap_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [App].[Role] ([RoleID]),
    CONSTRAINT [FK_RoleRightsMap_UserID] FOREIGN KEY ([RightsID]) REFERENCES [App].[Rights] ([RightsID])
);

