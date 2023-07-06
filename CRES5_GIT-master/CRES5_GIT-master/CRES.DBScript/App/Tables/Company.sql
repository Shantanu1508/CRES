CREATE TABLE [App].[Company] (
    [CompanyID]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]             VARCHAR (128)    NOT NULL,
    [StatusID]         INT              NOT NULL,
    [LogoUrl]          VARCHAR (1028)   NOT NULL,
    [StartDate]        DATETIME         NOT NULL,
    [DefaultTheme]     VARCHAR (128)    NOT NULL,
    [CurrentVersion]   VARCHAR (16)     NOT NULL,
    [LastUpgradeDate]  DATETIME         NOT NULL,
    [DeafultBrowserID] INT              NOT NULL,
    [DefaultTimeZone]  INT              NOT NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    CONSTRAINT [PK_CompanyID] PRIMARY KEY CLUSTERED ([CompanyID] ASC)
);

