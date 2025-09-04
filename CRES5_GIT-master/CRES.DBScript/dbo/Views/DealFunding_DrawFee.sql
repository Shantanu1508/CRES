      
-- show only the current status of the invoice for  a draw in AM report and not the history of all status as per discussion with swapna/tanjit        
CREATE View [dbo].[DealFunding_DrawFee]              
AS        
         
select distinct                    
d.CREDealID,        
d.DealName,                    
df.Date,        
isnulL((CASE WHEN tbl.DrawFeeStatus = 'Paid' THEN nd.AmountPaid ELSE nd.Amount end), 0) as Amount,  
isnulL(nd.AmountPaid,0) as AmountPaid,  
isnulL(nd.AmountAdj,0) as AmountAdj,  
(isnull(nd.AmountPaid,0) - isnull(nd.Amount,0) + isnull(nd.AmountAdj,0)) as UnpaidAmount,  
l4.Name as  Purpose,        
l3.Name as 'Draw Fee Status',        
df.Comment as DealFundingComment,        
(CASE WHEN tbl.DrawFeeStatus <> 'Paid' THEN null ELSE nd.PaymentDate end) as PaymentDate ,          
InvoicedDate=(CASE WHEN tbl.DrawFeeStatus = 'Paid' THEN nd.PaymentDate ELSE tbl.CreatedDate end),             
nd.Comment as InvoiceComment  ,      
Lgb.name as GeneratedBy,      
(CASE WHEN (l4.Name = 'Paydown' and df.GeneratedBy = 747 and df.Applied <> 1) then 'True' ELse 'False' END) as [Projected]      
  
from cre.invoicedetail nd                    
inner join cre.dealfunding df on df.DealFundingID=nd.ObjectID                    
left join core.lookup l1 on nd.InvoiceTypeID=l1.LookupID                    
left join core.lookup l2 on nd.objecttypeid=l2.LookupID                    
left join core.lookup l3 on nd.DrawFeeStatus=l3.LookupID         
left join core.lookup l4 on df.PurposeID=l4.LookupID        
left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = df.GeneratedBy       
inner join cre.deal d on d.DealID = df.DealID        
join         
(      
 Select  WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate,                
 (CASE  WHEN Comment = 'Draw Fee Invoice Queued' THEN 'Invoice Queued' WHEN Comment = 'Draw Fee Invoiced' THEN 'Invoiced' WHEN Comment = 'Draw Fee Paid' THEN 'Paid' END) as DrawFeeStatus         
 from(                
   select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate from [CRE].[WFTaskDetail] where TaskTypeID = 502                
   and comment like '%Draw Fee%'                
   and TaskID in (select ObjectID from cre.invoicedetail where ObjectTypeID = 698)                
                
   UNION ALL                 
                
   select WFTaskDetailID,TaskID,TaskTypeID,Comment,CreatedDate,UpdatedDate from [CRE].[WFTaskDetailArchive] where TaskTypeID = 502                
   and comment like '%Draw Fee%'                
   and TaskID in (select ObjectID from cre.invoicedetail where ObjectTypeID = 698)                
  )a        
)tbl on tbl.TaskID=nd.objectID and  tbl.DrawFeeStatus=l3.Name        
      
where ObjectTypeID=698 and nd.DrawFeeStatus not in ( 692) --and tblInvoicedate.DrawFeeStatus <> 'Invoice Queued'              
and isnull(nd.Amount,0)<>isnull(nd.AmountAdj,0)        
        
union all        
      
select d.CREDealID,        
d.DealName,                    
df.Date,        
ISNULL(i.Amount,0) as Amount,  
ISNULL(i.AmountPaid,0) as AmountPaid,  
ISNULL(i.AmountAdj,0) as AmountAdj,  
(isnull(i.AmountPaid,0) - isnull(i.Amount,0) + isnull(i.AmountAdj,0)) as UnpaidAmount,  
l2.Name as  Purpose,        
l1.Name as 'Draw Fee Status',        
df.Comment as DealFundingComment,        
null as PaymentDate ,          
null as InvoicedDate,                
i.Comment as InvoiceComment  ,      
Lgb.name as GeneratedBy,      
(CASE WHEN (l2.Name = 'Paydown' and df.GeneratedBy = 747 and df.Applied <> 1) then 'True' ELse 'False' END) as [Projected]  
  
from cre.InvoiceDetail i        
join cre.DealFunding df on i.TaskID=df.DealFundingID         
join cre.Deal d on d.DealID=df.DealID        
join core.Lookup l1 on l1.LookupID=i.DrawFeeStatus        
join core.Lookup l2 on l2.LookupID=df.PurposeID        
left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = df.GeneratedBy       
Left Join cre.wfchecklistdetail cd on  cd.TaskID=df.DealFundingID  and WFCheckListMasterID = 9     
      
where i.ObjectTypeID=698 and i.DrawFeeStatus=692 and df.Applied=1        
and i.AutoSendInvoice=572        
and isnull(i.Amount,0)<>isnull(i.AmountAdj,0)        
and cd.CheckListStatus <> 616 