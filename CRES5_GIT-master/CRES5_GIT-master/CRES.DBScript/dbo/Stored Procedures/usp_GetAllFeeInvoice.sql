
-- [dbo].[usp_GetAllFeeInvoice] 'B0E6697B-3534-4C09-BE0A-04473401AB93','FDD8EC03-9D63-4512-9990-89C508983EDC',0,1,50
 CREATE PROCEDURE [dbo].[usp_GetAllFeeInvoice] 
(  
	@UserID UNIQUEIDENTIFIER, 
	@DealID varchar(100),
	@PgeIndex INT,  
	@PageSize INT,  
	@TotalCount INT OUTPUT   
)  
AS
 BEGIN

 select 
 InvoiceDetailID,
 InvoiceTypeID,
 l1.name InvoiceType,
 objecttypeid,
 l2.name ObjectType,
 FirstName + ' ' + LastName as Name,
 CompanyName,
 nd.Amount,
 DrawFeeStatus,
 l3.name DrawFeeStatusText,
 d.Date,
 [FileName],
 nd.CreatedDate,
 PaymentDate ,
 isnull(nd.AmountAdj,0) as AmountAdj,
 isnull(nd.AmountPaid,0) as AmountPaid,
 ObjectID,
 nd.InvoiceComment,
nd.BatchUploadComment
 from  cre.invoicedetail nd
 inner join cre.dealfunding d on d.DealFundingID=nd.ObjectID
  left join core.lookup l1 on nd.InvoiceTypeID=l1.LookupID
  left join core.lookup l2 on nd.objecttypeid=l2.LookupID
  left join core.lookup l3 on nd.DrawFeeStatus=l3.LookupID
  where objecttypeid=698 and d.DealID=@DealID and DrawFeeStatus<>692
  
  union 
  select
 InvoiceDetailID,
 InvoiceTypeID,
 l1.name InvoiceType,
 objecttypeid,
 l2.name ObjectType,
 nd.FirstName + ' ' + nd.LastName as Name,
 nd.CompanyName,
 nd.Amount,
 DrawFeeStatus,
 l3.name DrawFeeStatusText,
 nd.InvoiceDate as [Date],
 [FileName],
 nd.CreatedDate,
 PaymentDate ,
 isnull(nd.AmountAdj,0) as AmountAdj,
 isnull(nd.AmountPaid,0) as AmountPaid,
 ObjectID,
 nd.InvoiceComment,
nd.BatchUploadComment
 from  cre.invoicedetail nd
 join cre.deal d on d.DealID = nd.ObjectID
 left join core.lookup l1 on nd.InvoiceTypeID=l1.LookupID
  left join core.lookup l2 on nd.objecttypeid=l2.LookupID
  left join core.lookup l3 on nd.DrawFeeStatus=l3.LookupID
  where objecttypeid=697 and d.DealID=@DealID and DrawFeeStatus<>692

  order by [Date] asc



 --OFFSET (@PgeIndex - 1)*@PageSize ROWS  
 --FETCH NEXT @PageSize ROWS ONLY  

 END