CREATE TABLE [App].[SearchLog] (
    [SearchLogID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [KeywordsEntered]  VARCHAR (256)    NOT NULL,
    [SelectedObjectID] UNIQUEIDENTIFIER NOT NULL,
    [SearchTime]       DATETIME         NOT NULL,
    [User_UserID]      UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    CONSTRAINT [PK_SearchLogID] PRIMARY KEY CLUSTERED ([SearchLogID] ASC),
    CONSTRAINT [PK_SearchLog_User_UserID] FOREIGN KEY ([User_UserID]) REFERENCES [App].[User] ([UserID])
);

