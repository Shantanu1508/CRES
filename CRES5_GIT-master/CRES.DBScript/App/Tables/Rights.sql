CREATE TABLE [App].[Rights] (
    [RightsID]    UNIQUEIDENTIFIER CONSTRAINT [DF__Rights__RightsID__7F80E8EA] DEFAULT (newid()) NOT NULL,
    [RightsName]  VARCHAR (84)     NOT NULL,
    [StatusID]    INT              NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_Rights] PRIMARY KEY CLUSTERED ([RightsID] ASC)
);

