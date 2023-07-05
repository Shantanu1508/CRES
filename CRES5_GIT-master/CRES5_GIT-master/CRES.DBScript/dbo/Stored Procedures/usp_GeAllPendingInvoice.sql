CREATE PROCEDURE [dbo].[usp_GeAllPendingInvoice] 
(
	@UserID NVARCHAR(256)
)
AS
BEGIN
SELECT [InvoiceDetailID]
      ,[InvoiceNo]
      ,isnull([TaskID],'00000000-0000-0000-0000-000000000000') as [TaskID]
      ,[ObjectTypeID]
      ,[ObjectID]
      ,[Amount]
      ,[AmountPaid]
      ,[PaymentDate]
      ,[AmountAdj]
      ,[AdjComments]
      ,[DrawFeeStatus]
      ,[FirstName]
      ,[LastName]
      ,[Designation]
      ,[CompanyName]
      ,[Address]
      ,[City]
      ,[StateID]
	  ,sm.StatesName as [State]
      ,[Zip]
      ,[Email1]
      ,[Email2]
      ,[PhoneNo]
      ,[AlternatePhone]
      ,[Comment]
      ,[AutoSendInvoice]
      ,i.[CreatedBy]
      ,i.[CreatedDate]
      ,i.[UpdatedBy]
      ,i.[UpdatedDate]
      ,i.[FileName]
      ,i.[PreAssignedInvoiceNo]
      ,i.[InvoiceGuid]

  FROM [CRE].[InvoiceDetail] i
  left join app.StatesMaster sm on sm.StatesID = i.StateID
  Where DrawFeeStatus =693
  --and fileName is not null
  and PreAssignedInvoiceNo is not null
END
GO

