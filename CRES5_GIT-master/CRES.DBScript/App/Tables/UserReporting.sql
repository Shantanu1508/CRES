CREATE TABLE [App].[UserReporting] (
    [UserID]            UNIQUEIDENTIFIER NOT NULL,
    [FirstName]         NVARCHAR (256)   NOT NULL,
    [LastName]          NVARCHAR (256)   NOT NULL,
    [Email]             NVARCHAR (256)   NOT NULL,
    [Login]             NVARCHAR (256)   NOT NULL, 
	[StatusID]          INT              NOT NULL,
    
	CONSTRAINT [PK_UserReporting_UserID] PRIMARY KEY CLUSTERED ([UserID] ASC)
);

GO
ALTER TABLE [App].[UserReporting] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO