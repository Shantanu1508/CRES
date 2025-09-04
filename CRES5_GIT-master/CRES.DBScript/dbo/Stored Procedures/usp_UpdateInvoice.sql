CREATE PROCEDURE [dbo].[usp_UpdateInvoice]
	(
	@UserID NVARCHAR(256),
	@InvoiceDetailID int,
	@InvoiceTypeFreeText NVARCHAR(256)
)
AS
BEGIN
    Update cre.InvoiceDetail set InvoiceTypeName=@InvoiceTypeFreeText where InvoiceDetailID=@InvoiceDetailID
END
