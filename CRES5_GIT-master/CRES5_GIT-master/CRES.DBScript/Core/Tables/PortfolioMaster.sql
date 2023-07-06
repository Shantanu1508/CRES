CREATE TABLE [Core].[PortfolioMaster] (
    [PortfolioMasterID]   INT              IDENTITY (1, 1) NOT NULL,
    [PortfolioMasterGuid] UNIQUEIDENTIFIER CONSTRAINT [DF__Portfolio__Portf__58671BC9] DEFAULT (newid()) NOT NULL,
    [PortfoliName]        NVARCHAR (256)   NULL,
    [Description]         NVARCHAR (2000)  NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    [AllowWholeDeal]      BIT              CONSTRAINT [DF__Portfolio__Allow__60083D91] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PortfolioMasterID] PRIMARY KEY CLUSTERED ([PortfolioMasterID] ASC)
);

