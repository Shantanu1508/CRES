CREATE TABLE [App].[GroupUserMap] (
    [GroupUserMapID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [StatusID]       INT              NOT NULL,
    [UserID]         UNIQUEIDENTIFIER NOT NULL,
    [GroupID]        UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_GroupUserMapID] PRIMARY KEY CLUSTERED ([GroupUserMapID] ASC),
    CONSTRAINT [PK_GroupUserMap_GroupID] FOREIGN KEY ([GroupID]) REFERENCES [App].[Group] ([GroupID]),
    CONSTRAINT [PK_GroupUserMap_UserID] FOREIGN KEY ([UserID]) REFERENCES [App].[User] ([UserID])
);

