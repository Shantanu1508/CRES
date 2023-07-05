CREATE TABLE [Core].[Account] (
    [AccountID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountTypeID]  INT              NULL,
    [StatusID]       INT              NULL,
    [Name]           VARCHAR (256)    NULL,
    [StartDate]      DATE             NULL,
    [EndDate]        DATE             NULL,
    [BaseCurrencyID] INT              NULL,
    [PayFrequency]   INT              NULL,
    [ClientNoteID]   NVARCHAR (256)   NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    [IsDeleted]      BIT              DEFAULT ((0)) NULL,
    CONSTRAINT [PK_AccountID] PRIMARY KEY CLUSTERED ([AccountID] ASC)
);


GO
ALTER TABLE [Core].[Account] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO
CREATE NONCLUSTERED INDEX [IX_Account_IsDeleted]
    ON [Core].[Account]([IsDeleted] ASC)
    INCLUDE([StatusID]);

