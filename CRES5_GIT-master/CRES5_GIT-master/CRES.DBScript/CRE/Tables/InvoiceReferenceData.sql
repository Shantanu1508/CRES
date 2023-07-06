CREATE TABLE [CRE].[InvoiceReferenceData]
(
	[InvoiceReferenceDataID] INT IDENTITY (1, 1) NOT NULL,
	[InvoiceDetailID] INT NULL,
	[Key] NVARCHAR(256) NULL,
	[Value] NVARCHAR(500) NULL

)
go
ALTER TABLE [CRE].[InvoiceReferenceData]
ADD CONSTRAINT PK_InvoiceReferenceData_InvoiceReferenceDataID PRIMARY KEY (InvoiceReferenceDataID);