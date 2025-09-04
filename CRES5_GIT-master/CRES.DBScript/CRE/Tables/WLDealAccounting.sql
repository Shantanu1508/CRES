CREATE TABLE [CRE].[WLDealAccounting] (
    [WLDealAccountingID]            Int IDENTITY (1, 1) NOT NULL,
    [DealID]          UNIQUEIDENTIFIER NOT NULL,  
	[StartDate] DATE             NULL,
	[EndDate] DATE             NULL,
	[TypeID]        INT              NULL,    
    [Comment]          NVARCHAR (MAX)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
   
   
    CONSTRAINT [PK_WLDealAccountingID] PRIMARY KEY CLUSTERED ([WLDealAccountingID] ASC),
    CONSTRAINT [FK_WLDealAccounting_DealID] FOREIGN KEY (DealID) REFERENCES [CRE].[Deal] (DealID)
);

