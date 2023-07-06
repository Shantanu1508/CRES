 
 CREATE PROCEDURE [dbo].[usp_GetBatchUploadSummaryInvoices] -- 122
   @BatchLog int  
as
BEGIN
 

select l.CreDealID as ID,d.dealname as Name, StatusComment as Comment ,InvoiceNo, 'M61.Tables.Invoices' as TableName from   [IO].[L_InvoiceDetail] l
left join cre.deal d on d.CreDealID   = l.CreDealID
 where BatchLogGenericID =@BatchLog
and l.Status ='Ignore'

end

 

 