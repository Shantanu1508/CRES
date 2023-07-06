CREATE TABLE [App].[QuickbookConfig] (
    [QuickbookConfigId]     INT            IDENTITY (1, 1) NOT NULL,
    [Code]                  NVARCHAR (256) NULL,
    [RealmID]               NVARCHAR (256) NULL,
    [Accesstokenexpiresin]  INT            NULL,
    [RefreshToken]          NVARCHAR (256) NULL,
    [AccessToken]           NVARCHAR (256) NULL,
    [Refreshtokenexpiresin] INT            NULL,
    [CreatedBy]             NVARCHAR (256) NULL,
    [CreatedDate]           DATETIME       NULL,
    [UpdatedBy]             NVARCHAR (256) NULL,
    [UpdatedDate]           DATETIME       NULL,
    CONSTRAINT [PK_QuickbookConfigId] PRIMARY KEY CLUSTERED ([QuickbookConfigId] ASC)
);

