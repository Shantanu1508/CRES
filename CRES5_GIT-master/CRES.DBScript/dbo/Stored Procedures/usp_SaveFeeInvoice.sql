
Create PROCEDURE [dbo].[usp_SaveFeeInvoice]
	(
	@TableTypeFeeInvoice [TableTypeFeeInvoice] READONLY,
	@UserID NVarchar(255)
	)

AS

BEGIN

	SET NOCOUNT ON;
	UPDATE CRE.InvoiceDetail SET CRE.InvoiceDetail.AmountAdj =a.AmountAdj,
	CRE.InvoiceDetail.InvoiceComment =a.InvoiceComment ,CRE.InvoiceDetail.BatchUploadComment=a.BatchUploadComment

	FROM(SELECT AmountAdj,ObjectID,InvoiceDetailID,InvoiceComment,BatchUploadComment from @TableTypeFeeInvoice  
	)a
	WHERE CRE.InvoiceDetail.InvoiceDetailID = a.InvoiceDetailID


	UPDATE CRE.InvoiceDetail SET CRE.InvoiceDetail.DrawFeeStatus=694
	FROM
	(
	   select InvoiceDetailID from 
		(
		select cast(ROUND(isnull(i.AmountPaid,0), 2) as numeric(36,2))-
		cast(ROUND(isnull(i.Amount,0), 2) as numeric(36,2))
		+cast(ROUND(isnull(i.AmountAdj,0), 2) as numeric(36,2)) as Delta
		,i.InvoiceDetailID from cre.invoicedetail i join @TableTypeFeeInvoice t on  i.InvoiceDetailID = t.InvoiceDetailID where i.DrawFeeStatus=693
		) tbl where Delta>=0
	) tblOuter
	WHERE CRE.InvoiceDetail.InvoiceDetailID = tblOuter.InvoiceDetailID

END