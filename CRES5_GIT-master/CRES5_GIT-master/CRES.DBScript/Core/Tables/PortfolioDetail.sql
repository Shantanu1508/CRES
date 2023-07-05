CREATE TABLE [Core].[PortfolioDetail] (
    [PortfolioDetailID]   INT              IDENTITY (1, 1) NOT NULL,
    [PortfolioDetailGuid] UNIQUEIDENTIFIER CONSTRAINT [DF__Portfolio__Portf__5B438874] DEFAULT (newid()) NOT NULL,
    [PortfolioMasterID]   INT              NOT NULL,
    [ObjectTypeID]        INT              NULL,
    [ObjectID]            INT              NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [PK_PortfolioDetailID] PRIMARY KEY CLUSTERED ([PortfolioDetailID] ASC),
    CONSTRAINT [FK__Portfolio__Portf__63D8CE75] FOREIGN KEY ([PortfolioMasterID]) REFERENCES [Core].[PortfolioMaster] ([PortfolioMasterID])
);

