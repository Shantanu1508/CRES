CREATE TABLE [App].[GroupRoleMap] (
    [GroupRoleMapID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [RoleID]         UNIQUEIDENTIFIER NOT NULL,
    [GroupID]        UNIQUEIDENTIFIER NOT NULL,
    [StatusID]       INT              NOT NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_GroupRoleMapID] PRIMARY KEY CLUSTERED ([GroupRoleMapID] ASC),
    CONSTRAINT [PK_GroupRoleMap_GroupID] FOREIGN KEY ([GroupID]) REFERENCES [App].[Group] ([GroupID]),
    CONSTRAINT [PK_GroupRoleMap_UserID] FOREIGN KEY ([RoleID]) REFERENCES [App].[Role] ([RoleID])
);

