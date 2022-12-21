CREATE TABLE [App].[UserObjectTag] (
    [UserObjectTagID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [TagTypeID]           INT              NOT NULL,
    [Object_ObjectAutoID] UNIQUEIDENTIFIER NOT NULL,
    [User_UserID]         UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [PK_UserObjectTagID] PRIMARY KEY CLUSTERED ([UserObjectTagID] ASC),
    CONSTRAINT [PK_UserObjectTag_ObjectAutoID] FOREIGN KEY ([Object_ObjectAutoID]) REFERENCES [App].[Object] ([ObjectAutoID]),
    CONSTRAINT [PK_UserObjectTag_User_UserID] FOREIGN KEY ([User_UserID]) REFERENCES [App].[User] ([UserID])
);

