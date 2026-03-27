CREATE TABLE [App].[UserExtension] (
    [UserExtensionID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserID]          UNIQUEIDENTIFIER NULL,
    [DeviceCode]      NVARCHAR (256)   NULL,
    [DeviceLoginDate] DATETIME         NULL,
    [ExpireDays]      INT              NOT NULL,
    CONSTRAINT [PK_UserExtensionID] PRIMARY KEY CLUSTERED ([UserExtensionID] ASC),
    CONSTRAINT [PK_UserExtension_UserID] FOREIGN KEY ([UserID]) REFERENCES [App].[User] ([UserID])
);

