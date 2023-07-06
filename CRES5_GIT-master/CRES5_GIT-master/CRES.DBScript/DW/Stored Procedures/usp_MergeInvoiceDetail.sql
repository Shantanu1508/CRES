
CREATE PROCEDURE [DW].[usp_MergeInvoiceDetail]
@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	
UPDATE [DW].BatchDetail
SET
BITableName = 'InvoiceDetailBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_InvoiceDetailBI'


DELETE FROM  [DW].[InvoiceDetailBI] WHERE ObjectID in (SELECT DISTINCT ObjectID FROM [DW].[L_InvoiceDetailBI])    
	

INSERT INTO  [DW].[InvoiceDetailBI]
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
,StatesAbbreviation)

SELECT  InvoiceDetailID
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
FROM [DW].[L_InvoiceDetailBI]


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_InvoiceDetailBI'

Print(char(9) +'usp_MergeInvoiceDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END