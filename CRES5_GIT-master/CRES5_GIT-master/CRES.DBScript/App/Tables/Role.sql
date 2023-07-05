CREATE TABLE [App].[Role] (
    [RoleID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [RoleName]    VARCHAR (84)     NOT NULL,
    [StatusID]    INT              NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_RoleID] PRIMARY KEY CLUSTERED ([RoleID] ASC)
);

