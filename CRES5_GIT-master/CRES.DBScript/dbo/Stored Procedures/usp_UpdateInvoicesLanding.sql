CREATE PROCEDURE [dbo].[usp_UpdateInvoicesLanding]
(
	@tbltype_Invoices [TableTypeInvoiceDetailLanding] READONLY
)
AS
BEGIN
 
	Update IDL SET 
	IDL.AmountPaid=t.AmountPaid,
	IDL.PaymentDate=t.PaymentDate,
	IDL.[Status]='ReadyToPaid'
	FROM [CRE].[InvoiceDetailLanding] IDL 
	INNER JOIN  @tbltype_Invoices t ON IDL.InvoiceDetailID=t.InvoiceDetailID
	--AND IDL.[Status]='Created';

END