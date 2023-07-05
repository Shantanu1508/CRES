CREATE TABLE [App].[UserRoleMap] (
    [UserRoleMapID] UNIQUEIDENTIFIER CONSTRAINT [DF__UserRoleM__UserR__3B0BC30C] DEFAULT (newid()) NOT NULL,
    [UserID]        UNIQUEIDENTIFIER NOT NULL,
    [RoleID]        UNIQUEIDENTIFIER NOT NULL,
    [StatusID]      INT              NOT NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    CONSTRAINT [PK_UserRoleMapID] PRIMARY KEY CLUSTERED ([UserRoleMapID] ASC),
    CONSTRAINT [FK_UserRoleMap_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [App].[Role] ([RoleID]),
    CONSTRAINT [FK_UserRoleMap_UserID] FOREIGN KEY ([UserID]) REFERENCES [App].[User] ([UserID])
);

