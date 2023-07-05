CREATE TABLE [App].[EmailNotification] (
    [EmailId]             NVARCHAR (50) NULL,
    [ModuleId]            INT           NULL,
    [Status]              BIT           CONSTRAINT [DF_App.EmailNotification_Status] DEFAULT ((1)) NULL,
    [EmailNotificationID] INT           IDENTITY (1, 1) NOT NULL,
    [Type]                NVARCHAR (256) NULL
);
go
ALTER TABLE [App].EmailNotification
ADD CONSTRAINT PK_EmailNotification_EmailNotificationID PRIMARY KEY ([EmailNotificationID]);
