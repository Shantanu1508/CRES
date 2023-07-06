CREATE TABLE [App].[Group] (
    [GroupID]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [GroupName]      VARCHAR (256)    NOT NULL,
    [StatusID]       INT              NOT NULL,
    [ExpirationDate] DATETIME         NOT NULL,
    [IsADGroup]      BIT              NOT NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_GroupID] PRIMARY KEY CLUSTERED ([GroupID] ASC)
);

