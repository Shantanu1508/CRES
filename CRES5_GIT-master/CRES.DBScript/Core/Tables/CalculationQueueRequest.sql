CREATE TABLE [Core].[CalculationQueueRequest] (
	[CalculationQueueRequestID] int IDENTITY(1,1) NOT NULL,
	[RequestID] nvarchar(256)  NULL,
	[TransactionOutput] int  null,
	[NotePeriodicOutput] int  null,
	[StrippingOutput] int  null,  	
	Prepaypremium_Output int null,
	Prepayallocations_Output int null,
	[TrRetriesCount]      INT NULL,
	[NPCRetriesCount]      INT NULL,
	[StrippRetriesCount]      INT NULL,
	PrepaypremiumRetriesCount int null,
	PrepayallocationRetriesCount int null,
	[CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
	[DailyInterestAccOutput] int  null,
	[DailyInterestRetriesCount]      INT NULL,
	
	CONSTRAINT [PK_CalculationQueueRequestID] PRIMARY KEY CLUSTERED ([CalculationQueueRequestID] ASC)
);
