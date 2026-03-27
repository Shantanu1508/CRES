	CREATE PROCEDURE [dbo].[usp_UpdateInvoiceDetailLandingStatus] 
(
	@UserID NVARCHAR(256),
	@InvoiceDetailID int,
	@Status int
)
	
AS
BEGIN
	if (ISNULL(@Status,'')<>'' and @InvoiceDetailID>0)
	begin
		update CRE.InvoiceDetailLanding set [Status] = @Status
	where  InvoiceDetailID = @InvoiceDetailID
	END
END


