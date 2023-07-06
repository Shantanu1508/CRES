CREATE TABLE [App].[UserEx] (
    [UserExID]   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserID]     UNIQUEIDENTIFIER NULL,
    [Color]      NVARCHAR (MAX)   NULL,
    [ProfilePic] NVARCHAR (MAX)   NULL,
    [TimeZone]   NVARCHAR (256)   NULL,
    CONSTRAINT [PK_UserExID] PRIMARY KEY CLUSTERED ([UserExID] ASC),
    CONSTRAINT [FK_UserEx_UserID] FOREIGN KEY ([UserID]) REFERENCES [App].[User] ([UserID])
);

