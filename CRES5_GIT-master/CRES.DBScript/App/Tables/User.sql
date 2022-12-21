CREATE TABLE [App].[User] (
    [UserID]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [FirstName]         NVARCHAR (256)   NOT NULL,
    [LastName]          NVARCHAR (256)   NOT NULL,
    [Email]             NVARCHAR (256)   NOT NULL,
    [Login]             NVARCHAR (256)   NOT NULL,
    [Password]          NVARCHAR (256)   NOT NULL,
    [ExpirationDate]    DATE             NOT NULL,
    [StatusID]          INT              NOT NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    [AuthenticationKey] NVARCHAR (256)   NULL,
    [ContactNo1]        NVARCHAR (256)   NULL,
    [UserToken]         NVARCHAR (50)    CONSTRAINT [DF__User__UserToken__5165187F] DEFAULT (newid()) NULL,
    [IP] Varchar(256)
    CONSTRAINT [PK_UserID] PRIMARY KEY CLUSTERED ([UserID] ASC)
);

