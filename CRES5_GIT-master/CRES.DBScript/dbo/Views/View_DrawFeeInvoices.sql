
CREATE VIEW [dbo].[View_DrawFeeInvoices]      
AS      
select             
d.DealName,            
d.CREDealID,            
--InvoiceDetailID,            
--InvoiceTypeID,            
l1.name InvoiceTypeBI,            
--objecttypeid,            
l2.name ObjectTypeBI,            
nd.FirstName + ' ' + nd.LastName as Name,            
nd.CompanyName,            
(CASE WHEN tblInvoicedate.DrawFeeStatus = 'Paid' THEN nd.AmountPaid ELSE nd.Amount end) as Amount,            
--DrawFeeStatus,            
--l3.name DrawFeeStatusBI,        
tblInvoicedate.DrawFeeStatus as DrawFeeStatusBI,      
          
df.Date,            
nd.CreatedDate,           
  CREDealID +'_'+ CONVERT(varchar(10), Date) Credealid_Date,       
--InvoicedDate = (case when df.Date >= cast(df.UpdatedDate as date)  then df.Date else df.UpdatedDate end),            
--tblInvoicedate.CreatedDate as InvoicedDate,  
InvoicedDate=(CASE WHEN tblInvoicedate.DrawFeeStatus = 'Paid' THEN tblInvoicedate1.CreatedDate ELSE tblInvoicedate.CreatedDate end),         
        
PaymentDate ,            
isnull(nd.AmountAdj,0) as AmountAdj,            
isnull(nd.AmountPaid,0) as AmountPaid,            
--ObjectID,            
nd.Comment,            
[FileName],  
nd.InvoiceNo  ,
--LTRIM(RTRIM(uAmLead.lastname))+', '+LTRIM(RTRIM(uAmLead.Firstname)) as AMTeamLeadUserBI,
--LTRIM(RTRIM(uAmSec.lastname))+', '+LTRIM(RTRIM(uAmSec.Firstname)) as AMSecondUserBI,
LTRIM(RTRIM(uAm.lastname))+', '+LTRIM(RTRIM(uAm.Firstname)) as [AssetManager]

from cre.invoicedetail nd            
inner join cre.dealfunding df on df.DealFundingID=nd.ObjectID            
left join core.lookup l1 on nd.InvoiceTypeID=l1.LookupID            
left join core.lookup l2 on nd.objecttypeid=l2.LookupID            
left join core.lookup l3 on nd.DrawFeeStatus=l3.LookupID            
inner join cre.deal d on d.DealID = df.DealID   
left join app.[User] uAmLead on uAmLead.UserID = d.AMTeamLeadUserID
left join app.[User] uAmSec on uAmSec.UserID = d.AMSecondUserID
left join app.[User] uAm on uAm.UserID = d.AMUserID
         
LEFT JOIN(        
         
 Select  WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate,        
 (CASE        
 WHEN Comment = 'Draw Fee Invoice Queued' THEN 'Invoice Queued'        
 WHEN Comment = 'Draw Fee Invoiced' THEN 'Invoiced'        
 WHEN Comment = 'Draw Fee Paid' THEN 'Paid'        
 END) as DrawFeeStatus        
 From(        
  Select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate        
  ,ROW_NUMBER() Over (Partition by TaskID,TaskTypeID,Comment Order by TaskID,TaskTypeID,Comment,createddate desc) as rno        
  from(        
   select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate from [CRE].[WFTaskDetail] where TaskTypeID = 502        
   and comment like '%Draw Fee%'        
   and TaskID in (select ObjectID from cre.invoicedetail where ObjectTypeID = 698)        
        
   UNION ALL         
        
   select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate from [CRE].[WFTaskDetailArchive] where TaskTypeID = 502        
   and comment like '%Draw Fee%'        
   and TaskID in (select ObjectID from cre.invoicedetail where ObjectTypeID = 698)        
  )a        
  --where TaskID = '65E738C5-E459-4078-A454-17D8DD7ECCAD'        
 )z        
 --Where rno = 1        
        
        
        
)tblInvoicedate on tblInvoicedate.taskid = nd.objectID --and tblInvoicedate.DrawFeeStatus = l3.name    
  
left join   
(  
Select  WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate,        
 (CASE        
 WHEN Comment = 'Draw Fee Invoice Queued' THEN 'Invoice Queued'        
 WHEN Comment = 'Draw Fee Invoiced' THEN 'Invoiced'        
 WHEN Comment = 'Draw Fee Paid' THEN 'Paid'        
 END) as DrawFeeStatus       
 From(        
  Select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate        
  ,ROW_NUMBER() Over (Partition by TaskID,TaskTypeID,Comment Order by TaskID,TaskTypeID,Comment,createddate desc) as rno        
  from(        
   select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate from [CRE].[WFTaskDetail] where TaskTypeID = 502        
   and comment like '%Draw Fee Invoiced%'        
   and TaskID in (select ObjectID from cre.invoicedetail where ObjectTypeID = 698)        
        
   UNION ALL         
        
   select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate from [CRE].[WFTaskDetailArchive] where TaskTypeID = 502   
   and comment like '%Draw Fee Invoiced%'        
   and TaskID in (select ObjectID from cre.invoicedetail where ObjectTypeID = 698)        
  )a        
  --where TaskID = '0AFE775E-E3E9-4D07-8A66-3DB846A49468'       
 )z        
 --Where rno = 1        
)tblInvoicedate1 on tblInvoicedate1.taskid = nd.objectID --and tblInvoicedate.DrawFeeStatus = l3.name      
        
where objecttypeid=698      and nd.DrawFeeStatus not in ( 692,696) and tblInvoicedate.DrawFeeStatus <> 'Invoice Queued'      
and isnull(nd.Amount,0)<>isnull(nd.AmountAdj,0)  
and d.isdeleted <> 1
                  
      