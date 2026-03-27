create PROCEDURE [dbo].[usp_GetMissingQBDCustomerInSandbox] --'69f7abd1-c9c4-414d-8846-bc7247c9522b'
AS
BEGIN

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   select tbl1.DealName,tbl1.CREDealID,[InvoiceDetailID]
      ,[InvoiceNo]
      ,[TaskID]
      ,[ObjectTypeID]
      ,[ObjectID]
      ,[Amount]
      ,[AmountPaid]
      ,[PaymentDate]
      ,[AmountAdj]
      ,[AdjComments]
      ,[FirstName]
      ,[LastName]
      ,[Designation]
      ,[CompanyName]
      ,[Address]
      ,[City]
      ,[Zip]
      ,[Email1]
      ,[Email2]
      ,[PhoneNo]
      ,[AlternatePhone]
      ,[Comment]
      ,[AutoSendInvoice]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,tbl1.[UpdatedDate]
      ,[DrawFeeStatus]
      ,[FileName]
      ,[InvoiceTypeID]
      ,[StateID]
      ,tbl1.[State]
      ,[SystemInvoiceNo] from 
	(
	   select d.DealName,d.CREDealID,[InvoiceDetailID]
      ,i.[InvoiceNo]
      ,i.[TaskID]
      ,i.[ObjectTypeID]
      ,i.[ObjectID]
      ,i.[Amount]
      ,i.[AmountPaid]
      ,i.[PaymentDate]
      ,i.[AmountAdj]
      ,i.[AdjComments]
      ,i.[FirstName]
      ,i.[LastName]
      ,i.[Designation]
      ,i.[CompanyName]
      ,i.[Address]
      ,i.[City]
      ,i.[Zip]
      ,i.[Email1]
      ,i.[Email2]
      ,i.[PhoneNo]
      ,i.[AlternatePhone]
      ,i.[Comment]
      ,i.[AutoSendInvoice]
      ,i.[CreatedBy]
      ,i.[CreatedDate]
      ,i.[UpdatedBy]
      ,i.[UpdatedDate]
      ,i.[DrawFeeStatus]
      ,i.[FileName]
      ,i.[InvoiceTypeID]
      ,i.[StateID]
      ,s.[StatesName] as [State]
      ,i.[SystemInvoiceNo]
	  FROM [CRE].[InvoiceDetail] i
	    join cre.dealfunding df on df.DealFundingID=i.objectID
		join cre.deal d on df.DealID=d.DealID 
        left join app.StatesMaster s on s.StatesID = i.StateID
        where i.InvoiceTypeID=558 and ObjectTypeID=698
		and rtrim(ltrim((case when len(d.DealName)>41 then d.CREDealID+'-'+substring(d.DealName,1,41 - len(d.CREDealID+'-')) else d.DealName end)))  in 
		(
		select rtrim(ltrim(FullName)) from app.quickbookcustomer
		)
		) tbl1
		join
		(
		select d.DealName,max(i.UpdatedDate) UpdatedDate
		from cre.invoicedetail i join cre.dealfunding df on df.DealFundingID=i.objectID
		join cre.deal d on df.DealID=d.DealID where i.InvoiceTypeID=558 and ObjectTypeID=698
		and rtrim(ltrim((case when len(d.DealName)>41 then d.CREDealID+'-'+substring(d.DealName,1,41 - len(d.CREDealID+'-')) else d.DealName end)))  in 
		(
		select rtrim(ltrim(FullName)) from app.quickbookcustomer
		)
		group by d.DealName
		) tbl2 
		on tbl1.DealName=tbl2.DealName and tbl1.UpdatedDate=tbl2.UpdatedDate

end