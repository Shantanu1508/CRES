CREATE TABLE [CRE].[Cash] (
    [CashID]      INT              IDENTITY (1, 1) NOT NULL,
    [CashGUID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]   UNIQUEIDENTIFIER NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_CashID] PRIMARY KEY CLUSTERED ([CashID] ASC),
    CONSTRAINT [PK_Cash_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID])
);


GO
ALTER TABLE [CRE].[Cash] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO




