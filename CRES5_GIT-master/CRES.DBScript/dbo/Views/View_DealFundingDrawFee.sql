-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
-- View
--select * from View_DealFundingDrawFee order by DealName,DrawFeeStatusBI
--select * from DealFunding_DrawFee

--sp_helptext DealFunding_DrawFee




--select * from core.Lookup
--select d.CREDealID,
--d.DealName,            
--df.Date,
--i.Amount,   
--l2.Name as  Purpose,
--l1.Name as DrawFeeStatusBI,
--df.Comment as DealFundingComment,
--null as PaymentDate ,  
--null as InvoicedDate,        
--i.Comment as InvoiceComment
--from cre.InvoiceDetail i
--join cre.DealFunding df on i.TaskID=df.DealFundingID 
--join cre.Deal d on d.DealID=df.DealID
--join core.Lookup l1 on l1.LookupID=i.DrawFeeStatus
--join core.Lookup l2 on l2.LookupID=df.PurposeID
--where 
--i.ObjectTypeID=698 and i.DrawFeeStatus=692 and df.Applied=1
--and i.AutoSendInvoice=572


--where DrawFeeStatus=692 and 

CREATE VIEW View_DealFundingDrawFee     
AS   
select            
d.CREDealID,
d.DealName,            
df.Date,
(CASE WHEN tblInvoicedate.DrawFeeStatus = 'Paid' THEN nd.AmountPaid ELSE nd.Amount end) as Amount,   
l4.Name as  Purpose,
tblInvoicedate.DrawFeeStatus as 'Draw fee Status',
df.Comment as DealFundingComment,
(CASE WHEN tblInvoicedate.DrawFeeStatus <> 'Paid' THEN null ELSE PaymentDate end) as PaymentDate ,  
InvoicedDate=(CASE WHEN tblInvoicedate.DrawFeeStatus = 'Paid' THEN tblInvoicedate1.CreatedDate ELSE tblInvoicedate.CreatedDate end),         
nd.Comment as InvoiceComment          
from cre.invoicedetail nd            
inner join cre.dealfunding df on df.DealFundingID=nd.ObjectID            
left join core.lookup l1 on nd.InvoiceTypeID=l1.LookupID            
left join core.lookup l2 on nd.objecttypeid=l2.LookupID            
left join core.lookup l3 on nd.DrawFeeStatus=l3.LookupID 
left join core.lookup l4 on df.PurposeID=l4.LookupID 
inner join cre.deal d on d.DealID = df.DealID            
LEFT JOIN(        
         
 Select  WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate,        
 (CASE        
 WHEN Comment = 'Draw Fee Invoice Queued' THEN 'Invoice Queued'        
 WHEN Comment = 'Draw Fee Invoiced' THEN 'Invoiced'        
 WHEN Comment = 'Draw Fee Paid' THEN 'Paid'        
 END) as DrawFeeStatus   
 ,ROW_NUMBER() Over (Partition by TaskID,TaskTypeID,Comment Order by TaskID,TaskTypeID,Comment,createddate desc) as rno         
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
 Where rno = 1        
        
        
        
)tblInvoicedate on tblInvoicedate.taskid = nd.objectID --and tblInvoicedate.DrawFeeStatus = l3.name    
  
left join   
(  
Select  WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate,        
 (CASE        
 WHEN Comment = 'Draw Fee Invoice Queued' THEN 'Invoice Queued'        
 WHEN Comment = 'Draw Fee Invoiced' THEN 'Invoiced'        
 WHEN Comment = 'Draw Fee Paid' THEN 'Paid'        
 END) as DrawFeeStatus   
 ,ROW_NUMBER() Over (Partition by TaskID,TaskTypeID,Comment Order by TaskID,TaskTypeID,Comment,createddate desc) as rno    
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
 Where rno = 1        
)tblInvoicedate1 on tblInvoicedate1.taskid = nd.objectID --and tblInvoicedate.DrawFeeStatus = l3.name      
        
where objecttypeid=698      and nd.DrawFeeStatus not in ( 692) --and tblInvoicedate.DrawFeeStatus <> 'Invoice Queued'      
and isnull(nd.Amount,0)<>isnull(nd.AmountAdj,0)  
union all
select d.CREDealID,
d.DealName,            
df.Date,
i.Amount,   
l2.Name as  Purpose,
l1.Name as DrawFeeStatusBI,
df.Comment as DealFundingComment,
null as PaymentDate ,  
null as InvoicedDate,        
i.Comment as InvoiceComment
from cre.InvoiceDetail i
join cre.DealFunding df on i.TaskID=df.DealFundingID 
join cre.Deal d on d.DealID=df.DealID
join core.Lookup l1 on l1.LookupID=i.DrawFeeStatus
join core.Lookup l2 on l2.LookupID=df.PurposeID
where 
i.ObjectTypeID=698 and i.DrawFeeStatus=692 and df.Applied=1
and i.AutoSendInvoice=572
and isnull(i.Amount,0)<>isnull(i.AmountAdj,0)