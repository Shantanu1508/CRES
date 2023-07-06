CREATE TABLE [IO].[IN_UnderwritingAccount] (
    [IN_UnderwritingAccountID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ClientNoteID]             NVARCHAR (256)   NULL,
    [Name]                     NVARCHAR (256)   NULL,
    [PayFrequency]             INT              NULL,
    [StatusID]                 INT              NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingAccountID] PRIMARY KEY CLUSTERED ([IN_UnderwritingAccountID] ASC)
);

