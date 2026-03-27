CREATE PROCEDURE [dbo].[usp_InsertInvoicesLanding]
(
	@tbltype_Invoices [TableTypeInvoiceDetailLanding] READONLY
)
AS
BEGIN
 
	INSERT INTO [CRE].[InvoiceDetailLanding] (InvoiceDetailID,DealID,CustomerName,InvoiceDate,InvoiceNo,ItemCode,Description,Amount,Memo,STATUS) 
	SELECT t.InvoiceDetailID,D.DealID,t.CustomerName,t.InvoiceDate,t.InvoiceNo,t.ItemCode,t.Description,t.Amount,t.Memo,'Created' FROM @tbltype_Invoices t
	INNER JOIN CRE.Deal D ON D.CREDealID = t.DealID
	WHERE t.InvoiceDetailID NOT IN (SELECT DISTINCT InvoiceDetailID FROM [CRE].[InvoiceDetailLanding]) ;

END