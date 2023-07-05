CREATE TABLE [App].[UserDefaultSetting] (
    [UserDefaultSettingID] UNIQUEIDENTIFIER CONSTRAINT [DF__UserDefau__UserD__67DE6983] DEFAULT (newid()) NOT NULL,
    [UserID]               UNIQUEIDENTIFIER NULL,
    [Type]                 INT              NULL,
    [Value]                NVARCHAR (MAX)   NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    CONSTRAINT [PK_UserDefaultSettingID] PRIMARY KEY CLUSTERED ([UserDefaultSettingID] ASC),
    CONSTRAINT [FK_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [App].[User] ([UserID])
);

