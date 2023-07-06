create PROCEDURE [dbo].[usp_GetMissingQBDCustomerFromBatch] --'69f7abd1-c9c4-414d-8846-bc7247c9522b'
AS
BEGIN

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
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
	  from [CRE].[InvoiceDetail] i 
	  join cre.deal d on d.DealID = i.ObjectID
    left join app.StatesMaster s on s.StatesID = i.StateID
    where  ObjectTypeID=697
    and rtrim(ltrim((case when len(d.DealName)>41 then d.CREDealID+'-'+substring(d.DealName,1,41 - len(d.CREDealID+'-')) else d.DealName end))) not in 
		(
		select rtrim(ltrim(FullName)) from app.quickbookcustomer
		)

end