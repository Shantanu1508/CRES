CREATE TABLE [CRE].[Fund] (
    [FundID]      INT            IDENTITY (1, 1) NOT NULL,
    [FundName]    NVARCHAR (256) NULL,
    [ClientID]    INT            NULL,
    [Pool]        NVARCHAR (256) NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_FundID] PRIMARY KEY CLUSTERED ([FundID] ASC),
    CONSTRAINT [FK_Fund_ClientID] FOREIGN KEY ([ClientID]) REFERENCES [CRE].[Client] ([ClientID])
);

