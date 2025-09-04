CREATE PROCEDURE [dbo].[usp_UpdateInvoiceDetailStatusForSandbox]
(
	@UserID NVARCHAR(256),
	@TaskID nvarchar(256),
	@InvoiceNumber nvarchar(256)
)
	
AS
BEGIN
 
 IF not exists(select 1 from CRE.InvoiceDetailForSandbox where TaskID=@TaskID)
	BEGIN
		  Insert into CRE.InvoiceDetailForSandbox(TaskID,[InvoiceNo]) values(@TaskID,@InvoiceNumber)
	END
	
END
