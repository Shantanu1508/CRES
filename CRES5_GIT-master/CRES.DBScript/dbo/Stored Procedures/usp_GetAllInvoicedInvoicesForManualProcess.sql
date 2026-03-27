	
CREATE PROCEDURE [dbo].[usp_GetAllInvoicedInvoicesForManualProcess] 
(
	@UserID NVARCHAR(256)
)
AS
BEGIN  

SELECT [InvoiceDetailID]
	  ,CREDealID
      ,i.InvoiceNo
	  , i.SystemInvoiceNo as Memo
	  ,i.Amount as [ActualAmount]
	  ,i.Amount as [AmountPaid]
	  ,null as Paymentdate
	  ,'Invoiced' as Status
	  FROM [CRE].[InvoiceDetail] i
	  join Cre.Dealfunding df on i.ObjectID = df.DealFundingID
	  join CRE.Deal d on d.DealID=df.DealID
	  left join app.StatesMaster sm on sm.StatesID = i.StateID
	  Where DrawFeeStatus =693
	  and df.Applied=1
	  and fileName is not null
	  order by CREDealID
END
