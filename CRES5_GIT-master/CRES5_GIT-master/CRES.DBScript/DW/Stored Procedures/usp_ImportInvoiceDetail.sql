
CREATE PROCEDURE [DW].[usp_ImportInvoiceDetail]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_InvoiceDetailBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


		Truncate table [DW].[L_InvoiceDetailBI]

		INSERT INTO [DW].[L_InvoiceDetailBI]
			( InvoiceDetailID
 ,InvoiceNo
 ,TaskID
 ,ObjectTypeID
 ,ObjectID
 ,Amount
 ,AmountPaid
 ,PaymentDate
 ,AmountAdj
 ,AdjComments
 ,FirstName
 ,LastName
 ,Designation
 ,CompanyName
 ,Address
 ,City
 ,Zip
 ,Email1
 ,Email2
 ,PhoneNo
 ,AlternatePhone
 ,Comment
 ,AutoSendInvoice
 ,CreatedBy
 ,CreatedDate
 ,UpdatedBy
 ,UpdatedDate
 ,DrawFeeStatus
 ,FileName
 ,InvoiceTypeID
 ,StateID
 ,SystemInvoiceNo
 ,credealid
 ,dealname
 ,date
 ,ObjectTypeBI
 ,AutoSendInvoiceBI
 ,DrawFeeStatusBI
 ,InvoiceTypeBI
 ,StatesName
 ,StatesAbbreviation
)

select 
id.InvoiceDetailID
,id.InvoiceNo
,id.TaskID
,id.ObjectTypeID
,id.ObjectID
,id.Amount
,id.AmountPaid
,id.PaymentDate
,id.AmountAdj
,id.AdjComments
,id.FirstName
,id.LastName
,id.Designation
,id.CompanyName
,id.Address
,id.City
,id.Zip
,id.Email1
,id.Email2
,id.PhoneNo
,id.AlternatePhone
,id.Comment
,id.AutoSendInvoice
,id.CreatedBy
,id.CreatedDate
,id.UpdatedBy
,id.UpdatedDate
,id.DrawFeeStatus
,id.FileName
,id.InvoiceTypeID
,id.StateID
,id.SystemInvoiceNo
,d.credealid
,d.dealname
,df.date
,lObjectTypeID.name as ObjectTypeBI
,lAutoSendInvoice.name as AutoSendInvoiceBI
,lDrawFeeStatus.name as DrawFeeStatusBI
,lInvoiceTypeID.name as InvoiceTypeBI
,st.StatesName       
,st.StatesAbbreviation

from cre.InvoiceDetail id
inner join cre.DealFunding df on df.DealFundingID = id.ObjectID
left join cre.Deal d on df.dealid = d.dealid
left Join Core.lookup lObjectTypeID on lObjectTypeID.lookupid = id.ObjectTypeID and lObjectTypeID.parentid=113
left Join Core.lookup lAutoSendInvoice on lAutoSendInvoice.lookupid = id.AutoSendInvoice and lAutoSendInvoice.parentid=95
left Join Core.lookup lDrawFeeStatus on lDrawFeeStatus.lookupid = id.DrawFeeStatus and lDrawFeeStatus.parentid=112
left Join Core.lookup lInvoiceTypeID on lInvoiceTypeID.lookupid = id.InvoiceTypeID and lInvoiceTypeID.parentid=94
left join [App].[StatesMaster] st on st.StatesID = id.StateID

WHERE id.ObjectID in
   ( 
	SELECT DISTINCT ObjectID 
	FROM 
	(SELECT tdn.ObjectID, tdn.CreatedDate, tdn.UpdatedDate FROM CRE.InvoiceDetail tdn
      EXCEPT 
      SELECT dwtd.ObjectID, dwtd.CreatedDate, dwtd.UpdatedDate FROM [DW].[InvoiceDetailBI] dwtd
   )b
 )




SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportInvoiceDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
