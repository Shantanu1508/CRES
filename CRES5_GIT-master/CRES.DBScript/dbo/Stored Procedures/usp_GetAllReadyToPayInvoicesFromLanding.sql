CREATE PROCEDURE [dbo].[usp_GetAllReadyToPayInvoicesFromLanding]

(
	@UserID NVARCHAR(256)
)
AS
BEGIN 
    select 	[InvoiceDetailID],[AmountPaid],	[PaymentDate],	[Status] from cre.InvoiceDetailLanding where [Status]='ReadyToPaid'
END