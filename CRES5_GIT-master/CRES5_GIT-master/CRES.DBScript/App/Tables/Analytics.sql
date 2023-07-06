CREATE TABLE [App].[Analytics] (
    [AnalyticsID]         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EvenTypeID]          INT              NOT NULL,
    [EventTimestamp]      DATETIME         NOT NULL,
    [Browser]             VARCHAR (256)    NOT NULL,
    [IPv4]                VARCHAR (15)     NULL,
    [IPv6]                VARCHAR (45)     NULL,
    [LoggedInUserID]      INT              NULL,
    [Object_ObjectAutoID] UNIQUEIDENTIFIER NOT NULL,
    [User_UserID]         UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [PK_AnalyticsID] PRIMARY KEY CLUSTERED ([AnalyticsID] ASC),
    CONSTRAINT [PK_Analytics_Object_ObjectAutoID] FOREIGN KEY ([Object_ObjectAutoID]) REFERENCES [App].[Object] ([ObjectAutoID]),
    CONSTRAINT [PK_Analytics_User_UserID] FOREIGN KEY ([User_UserID]) REFERENCES [App].[User] ([UserID])
);

