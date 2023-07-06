CREATE TABLE [App].[QuickBookUser] (
    [QuickBookUserID] INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (256) NULL,
    [LastName]        NVARCHAR (256) NULL,
    [AgentToken]      NVARCHAR (256) NULL,
    [CompanyId]       NVARCHAR (256) NULL,
    [ExternalId]      NVARCHAR (256) NULL,
    [ID]              NVARCHAR (256) NULL,
    [isActive]        BIT            NOT NULL,
    [CreatedBy]       NVARCHAR (256) NULL,
    [CreatedDate]     DATETIME       NULL,
    [UpdatedBy]       NVARCHAR (256) NULL,
    [UpdatedDate]     DATETIME       NULL,
    CONSTRAINT [PK_QuickBookUserID] PRIMARY KEY CLUSTERED ([QuickBookUserID] ASC)
);

