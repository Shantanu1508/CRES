CREATE TABLE [CRE].[InvoiceDetailForSandbox]
(
	[InvoiceDetailID] INT              IDENTITY (1, 1) NOT NULL,
	[TaskID]          UNIQUEIDENTIFIER NULL,
	[InvoiceNo]       NVARCHAR (256)   NULL
)
