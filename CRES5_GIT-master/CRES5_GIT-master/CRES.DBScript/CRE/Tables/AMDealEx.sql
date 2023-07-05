CREATE TABLE [CRE].[AMDealEx] (
    [AMDealExID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Deal_DealID] UNIQUEIDENTIFIER NOT NULL,
    [User_UserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_AMDealExID] PRIMARY KEY CLUSTERED ([AMDealExID] ASC),
    CONSTRAINT [FK_AMDealEx_Deal_DealID] FOREIGN KEY ([Deal_DealID]) REFERENCES [CRE].[Deal] ([DealID]),
    CONSTRAINT [FK_AMDealEx_User_UserId] FOREIGN KEY ([User_UserId]) REFERENCES [App].[User] ([UserID])
);

