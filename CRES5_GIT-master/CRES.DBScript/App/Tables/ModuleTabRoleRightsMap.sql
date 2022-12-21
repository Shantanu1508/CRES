CREATE TABLE [App].[ModuleTabRoleRightsMap] (
    [ModuleTabRoleRightsMapID] UNIQUEIDENTIFIER CONSTRAINT [DF__ModuleTab__Modul__07220AB2] DEFAULT (newid()) NOT NULL,
    [RoleRightsMapID]          UNIQUEIDENTIFIER NOT NULL,
    [ModuleTabMasterID]        INT              NOT NULL,
    [StatusID]                 INT              NOT NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_ModuleTabRoleRightsMapID] PRIMARY KEY CLUSTERED ([ModuleTabRoleRightsMapID] ASC),
    CONSTRAINT [FK_ModuleTabRoleRightsMap_ModuleTabMasterID] FOREIGN KEY ([ModuleTabMasterID]) REFERENCES [App].[ModuleTabMaster] ([ModuleTabMasterID]),
    CONSTRAINT [FK_ModuleTabRoleRightsMap_RoleRightsMapID] FOREIGN KEY ([RoleRightsMapID]) REFERENCES [App].[RoleRightsMap] ([RoleRightsMapID])
);

