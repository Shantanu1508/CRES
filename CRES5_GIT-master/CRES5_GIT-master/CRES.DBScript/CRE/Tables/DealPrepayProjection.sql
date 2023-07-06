CREATE TABLE [CRE].[DealPrepayProjection] (
    [DealPrepayProjectionID]            Int IDENTITY (1, 1) NOT NULL,
	[DealID]          UNIQUEIDENTIFIER  NOT NULL,    
	PrepayDate	Date null,
	PrepayPremium_RemainingSpread	decimal(28,15) null,
	UPB	decimal(28,15) null,
	OpenPrepaymentDate	Date null,
	TotalPayoff	decimal(28,15) null,

    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,   
   
    CONSTRAINT [PK_DealPrepayProjectionID] PRIMARY KEY CLUSTERED ([DealPrepayProjectionID] ASC),
	CONSTRAINT [FK_DealPrepayProjection_DealID] FOREIGN KEY (DealID) REFERENCES [CRE].[Deal] (DealID)
);

