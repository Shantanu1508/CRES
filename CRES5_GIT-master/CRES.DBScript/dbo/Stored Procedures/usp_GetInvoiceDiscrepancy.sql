CREATE PROCEDURE [dbo].[usp_GetInvoiceDiscrepancy]	
AS
BEGIN
	
	Select DealName as [Deal Name]
	,Convert(varchar,FundingDate,101) as [Funding Date]
	,Comment
	,CAST(ROUND(InvoiceAmount,2) as decimal(28,7)) as [Invoice Amount]
	,InvoiceType as [Invoice Type]
	From(
		--case 1 when funding date is future date and invoicetype is Draw Fee		
		select d.DealName,df.[Date] as FundingDate,df.Comment, i.Amount as InvoiceAmount,l.[Name] as InvoiceType from cre.DealFunding df 
		join cre.InvoiceDetail i on i.ObjectID=df.DealFundingID 
		join cre.Deal d on d.DealID=df.DealID
		left join core.Lookup l on l.LookupID=i.InvoiceTypeID
		where i.DrawFeeStatus =696
		and i.ObjectTypeID=698
		and i.InvoiceTypeID=558
		and dateadd(d,2,[Date])<getdate()
		and cast(i.CreatedDate as date)<cast(df.[Date] as date)
		and d.DealName NOT LIKE '%copy%'

		union
		
		--case 2 when funding date is past date and invoicetype is Draw Fee
		select d.DealName,df.[Date] as FundingDate,df.Comment, i.Amount as InvoiceAmount,l.[Name] as InvoiceType from cre.DealFunding df 
		join cre.InvoiceDetail i on i.ObjectID=df.DealFundingID 
		join cre.Deal d on d.DealID=df.DealID
		join 
		(
		 select TaskID,Comment,CreatedDate, Row_number() over(Partition by TaskID order by CreatedDate desc) as rno from cre.WFTaskDetail
		 where Comment like '%Invoice Queued%'
		) w on w.TaskID=df.DealFundingID and w.rno=1

		left join core.Lookup l on l.LookupID=i.InvoiceTypeID
		where i.DrawFeeStatus =696
		and w.Comment like '%Invoice Queued%'
		and i.ObjectTypeID=698
		and i.InvoiceTypeID=558
		and cast(i.CreatedDate as date)>cast(df.[Date] as date)
		and cast(dateadd(d,2,i.CreatedDate)as date)<cast(getdate() as date)
		and d.DealName NOT LIKE '%copy%'

		union
		
		--case 3 when invoice type is other than Draw Fee
		select d.DealName,df.[Date] as FundingDate,df.Comment, i.Amount as InvoiceAmount,l.[Name] as InvoiceType from cre.DealFunding df 
		join cre.InvoiceDetail i on i.ObjectID=df.DealFundingID 
		join cre.Deal d on d.DealID=df.DealID
		join 
		(
		 select TaskID,Comment,CreatedDate, Row_number() over(Partition by TaskID order by CreatedDate desc) as rno from cre.WFTaskDetail
		 where Comment like '%Invoice Queued%'
		) w on w.TaskID=df.DealFundingID and w.rno=1
		left join core.Lookup l on l.LookupID=i.InvoiceTypeID
		where i.DrawFeeStatus =696
		and w.Comment like '%Invoice Queued%'
		and i.ObjectTypeID=698
		and i.InvoiceTypeID<>558
		and cast(dateadd(d,2,i.CreatedDate)as date)<cast(getdate() as date)
		and d.DealName NOT LIKE '%copy%'

	)z
	Order by z.DealName
END