CREATE PROCEDURE [dbo].[usp_GetInvoiceConfigByInvoiceType]
	@InvoiceTypeID int,
	@UserID NVARCHAR(256)
AS
 BEGIN
	SELECT  [InvoiceConfigID], 
		[InvoiceTypeID],
		[InvoiceCode],
		[Template],
		[IsApplySplit],
		[InvoiceAccountNo]
FROM app.InvoiceConfig WHERE InvoiceTypeID=@InvoiceTypeID

 END