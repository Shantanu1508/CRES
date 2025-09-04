CREATE PROCEDURE [dbo].[usp_DeleteInvoiceDetailLanding]
	(
	@UserID NVARCHAR(256),
	@InvoiceDetailID int
)
	
AS
BEGIN
	
	begin
		delete from  CRE.InvoiceDetailLanding where  InvoiceDetailID = @InvoiceDetailID
	END
END