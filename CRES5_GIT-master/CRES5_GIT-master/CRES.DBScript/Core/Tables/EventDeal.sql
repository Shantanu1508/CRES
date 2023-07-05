CREATE TABLE [Core].[EventDeal] (
    [EventDealID]            Int IDENTITY (1, 1) NOT NULL,
    [DealID]          UNIQUEIDENTIFIER NOT NULL,    
    [EventTypeID]        INT              NULL,
    [EffectiveDate] DATE             NULL,
    [StatusID]           INT              NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
   
   
    CONSTRAINT [PK_EventDealID] PRIMARY KEY CLUSTERED ([EventDealID] ASC),
    CONSTRAINT [FK_EventDeal_DealID] FOREIGN KEY (DealID) REFERENCES [CRE].[Deal] (DealID)
);

