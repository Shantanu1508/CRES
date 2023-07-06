CREATE TYPE [dbo].[TableTypeFeeInvoice] AS TABLE
(
	InvoiceDetailID int,
	ObjectID Uniqueidentifier NULL,
	AmountAdj decimal(28,15) Null,
	InvoiceComment nvarchar(2000) NUll,
    BatchUploadComment nvarchar(2000) NUll
)