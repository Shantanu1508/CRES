CREATE TYPE [DBO].[TableTypeInvoiceDetailLanding] AS TABLE(
	[InvoiceDetailID] [int] NULL,
	[DealID] [nvarchar](256) NULL,
	[CustomerName] [nvarchar](256) NULL,
	[InvoiceDate] [datetime] NULL,
	[InvoiceNo] [nvarchar](256) NULL,
	[ItemCode] [nvarchar](256) NULL,
	[Description] [nvarchar](256) NULL,
	[Amount] [decimal](28, 15) NULL,
	[Memo] [nvarchar](256) NULL,
	[AmountPaid] [decimal](28, 15) NULL,
	[PaymentDate] [datetime] NULL,
	[Status] [nvarchar](256) NULL
)