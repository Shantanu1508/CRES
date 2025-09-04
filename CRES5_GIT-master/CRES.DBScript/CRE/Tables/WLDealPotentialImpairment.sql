CREATE TABLE [CRE].[WLDealPotentialImpairment] (
    [WLDealPotentialImpairmentID]            Int IDENTITY (1, 1) NOT NULL,
    [DealID]          UNIQUEIDENTIFIER NOT NULL,  
	[EffectiveDate] DATE             NULL,	
	[Amount]        decimal(28,15)              NULL,    
    [Comment]          NVARCHAR (MAX)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
   
   
    CONSTRAINT [PK_WLDealPotentialImpairmentID] PRIMARY KEY CLUSTERED ([WLDealPotentialImpairmentID] ASC),
    CONSTRAINT [FK_WLDealPotentialImpairment_DealID] FOREIGN KEY (DealID) REFERENCES [CRE].[Deal] (DealID)
);

