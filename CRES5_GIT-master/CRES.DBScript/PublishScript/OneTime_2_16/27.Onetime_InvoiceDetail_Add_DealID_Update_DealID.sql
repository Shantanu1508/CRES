IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DealID' AND Object_ID = Object_ID(N'cre.InvoiceDetail'))
		  BEGIN
			alter table CRE.InvoiceDetail add [DealID] UNIQUEIDENTIFIER   NULL
		  END

go

update  cre.InvoiceDetail set  cre.InvoiceDetail.DealID= tbl.DealID
from
(
select dl.DealID ,i.ObjectID from cre.InvoiceDetail i join  cre.dealfunding d on i.objectid=d.dealfundingid join cre.deal dl on dl.dealid=d.dealid
) tbl 
where cre.InvoiceDetail.ObjectID=tbl.ObjectID 
and cre.InvoiceDetail.InvoiceTypeID=558 
and cre.InvoiceDetail.[DealID] is null
	