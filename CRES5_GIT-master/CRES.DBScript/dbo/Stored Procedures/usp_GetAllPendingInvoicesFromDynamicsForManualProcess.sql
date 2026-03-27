CREATE PROCEDURE [dbo].[usp_GetAllPendingInvoicesFromDynamicsForManualProcess] 
(
	@UserID NVARCHAR(256)
)
AS
BEGIN  

SELECT [InvoiceDetailID]
	  ,CREDealID
	  ,d.DealName as CustomerName
	  ,df.Date as InvoiceDate
      ,[InvoiceNo]
	  ,(select top 1 InvoiceCode from app.InvoiceConfig where InvoiceTypeID = i.InvoiceTypeID) as InvoiceCode
	   ,df.Comment as [Description]
	   ,i.[Amount]
	   ,SystemInvoiceNo as Memo
	   ,dbo.[fn_GetInvoiceSplit](d.CREDealID,i.InvoiceTypeID,i.[Amount],'') as split
	  from [CRE].[InvoiceDetail] i 
	  join Cre.Dealfunding df on i.ObjectID = df.DealFundingID
	  join CRE.Deal d on d.DealID=df.DealID
	  left join app.[user] u1 on u1.UserID =d.AMUserID
	  left join app.[user] u2 on u2.UserID = d.AMTeamLeadUserID
	  left join app.[user] u3 on u3.UserID = d.AMSecondUserID
	  left join app.StatesMaster sm on sm.StatesID = i.StateID
	  left join app.[user] u4 on u4.UserID = i.UpdatedBy
      where df.Applied=1 
	  and ObjectTypeID=698
	  and InvoiceTypeID = 558
	  --and cast([Date] as date)<=cast(getdate() as date) 
	  and DrawFeeStatus =693
and fileName is not null
and InvoiceGuid is not null
	  order by d.DealName
END
