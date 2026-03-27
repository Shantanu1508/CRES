CREATE TABLE [CRE].[WLDealPotentialImpairmentMaster] (
    [WLDealPotentialImpairmentMasterID]            Int IDENTITY (1, 1) NOT NULL,
    [DealID]          UNIQUEIDENTIFIER NOT NULL,  
	[Date] DATE             NULL,	
	[Amount]        decimal(28,15)              NULL,    
    [Comment]          NVARCHAR (MAX)   NULL,
    [Applied]            BIT              NULL,
    [RowNo] int null,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [AdjustmentType]           INT  NUll,
    CONSTRAINT [PK_WLDealPotentialImpairmentMasterID] PRIMARY KEY CLUSTERED ([WLDealPotentialImpairmentMasterID] ASC),
    CONSTRAINT [FK_WLDealPotentialImpairmentMaster_DealID] FOREIGN KEY (DealID) REFERENCES [CRE].[Deal] (DealID)
);

