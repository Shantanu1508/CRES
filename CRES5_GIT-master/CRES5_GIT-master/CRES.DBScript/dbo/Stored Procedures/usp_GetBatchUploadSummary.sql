 
 CREATE PROCEDURE [dbo].[usp_GetBatchUploadSummary]  
   @BatchLog int  
as
BEGIN
 

	 select l.noteid as noteid,acc.name as Name,l.comment,'' as InvoiceNo, TableName from   [IO].[L_M61AddinLanding] l
left join cre.note n on n.crenoteid   = l.noteid 
left join core.account acc on acc.accountid = n.Account_AccountID
where  BatchLogGenericID =@BatchLog
and Status ='Ignore'

 
end

