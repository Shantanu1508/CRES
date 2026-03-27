CREATE TABLE [CRE].[InvoiceDetailLanding]
(
	[InvoiceDetailLandingID] INT IDENTITY (1, 1) NOT NULL,
	[InvoiceDetailID] INT,
	[DealID]   UNIQUEIDENTIFIER   NULL,
	[CustomerName]  NVARCHAR (256)   NULL,
	[InvoiceDate]   DATETIME         NULL,
	[InvoiceNo]     NVARCHAR (256)   NULL,
	[ItemCode]      NVARCHAR (256)   NULL,
	[Description]   NVARCHAR (256)   NULL,
	[Amount]        DECIMAL (28, 15) NULL,
	[Memo]          NVARCHAR (256)   NULL,
	[AmountPaid]    DECIMAL (28, 15) NULL,
	[PaymentDate]	DATETIME         NULL,
	[Status]    NVARCHAR (256)   NULL,

)
