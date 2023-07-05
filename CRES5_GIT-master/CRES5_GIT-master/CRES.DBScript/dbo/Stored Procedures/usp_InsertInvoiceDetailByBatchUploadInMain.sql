--[usp_GetDrawFeeInvoiceDetailByTaskID]

CREATE PROCEDURE [dbo].[usp_InsertInvoiceDetailByBatchUploadInMain] 
(
	@BatchLogGenericID int,
	@CreatedBy nvarchar(256)
)
	
AS
BEGIN
  
  
IF OBJECT_ID('tempdb..[#InvoiceDetail]') IS NOT NULL                                         
 DROP TABLE [#InvoiceDetail]  
  
	CREATE TABLE [#InvoiceDetail] (  	
	[ObjectTypeID]    INT              NULL,
	[ObjectID]        NVARCHAR (256)   NULL,
	[Amount]          DECIMAL (28, 15) NULL,  
	[FirstName]       NVARCHAR (256)   NULL,
	[LastName]        NVARCHAR (256)   NULL,
	[Designation]     NVARCHAR (256)   NULL,
	[CompanyName]     NVARCHAR (256)   NULL,
	[Address]         NVARCHAR (256)   NULL,
	[City]            NVARCHAR (256)   NULL,	
	[Zip]             NVARCHAR (256)   NULL,
	[Email1]          NVARCHAR (256)   NULL,
	[Email2]          NVARCHAR (256)   NULL,
	[PhoneNo]         NVARCHAR (256)   NULL,
	[AlternatePhone]  NVARCHAR (256)   NULL,
	[Comment]         NVARCHAR (2000)  NULL,   
	[CreatedBy]       NVARCHAR (256)   NULL,
	[CreatedDate]     DATETIME         NULL,
	[UpdatedBy]       NVARCHAR (256)   NULL,
	[UpdatedDate]     DATETIME         NULL,
	[DrawFeeStatus]   INT              NULL,   
	[InvoiceTypeID]   INT              NULL,
	[StateID]         INT              NULL,
	[SystemInvoiceNo]   NVARCHAR (256)   NULL,
	[DealID]   UNIQUEIDENTIFIER   NULL,	
	InvoiceDate	Date NULL, --if past then current
	InvoiceDateOriginal	Date NULL,
	InvoiceDueDate	Date NULL,
	BatchUploadComment NVARCHAR (2000)  NULL,
	[Status] nvarchar(256) null
	)

	INSERT INTO [#InvoiceDetail]
	(
	ObjectTypeID,
	ObjectID,
	Amount,
	FirstName,
	LastName,
	Designation,
	CompanyName,
	Address,
	City,
	Zip,
	Email1,
	Email2,
	PhoneNo,
	AlternatePhone,
	Comment,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	DrawFeeStatus,
	InvoiceTypeID,
	StateID,
	SystemInvoiceNo,
	DealID,
	InvoiceDate,
	InvoiceDateOriginal,
	InvoiceDueDate,
	BatchUploadComment,
	[Status]
	)
	Select 
	697 as ObjectTypeID,
	d.dealid as ObjectID,
	id.Amount,
	id.FirstName,
	id.LastName,
	id.Designation,
	id.CompanyName,
	id.Address,
	id.City,
	id.Zip,
	id.Email1,
	id.Email2,
	id.PhoneNo,
	id.AlternatePhone,
	id.Comment,
	id.CreatedBy,
	id.CreatedDate,
	id.UpdatedBy,
	id.UpdatedDate,
	id.DrawFeeStatus,
	id.InvoiceTypeID,
	id.State,
	id.InvoiceNo,
	d.DealID,
	(CASE WHEN id.InvoiceDate < CAST(getdate() as date) THEN CAST(getdate() as date) ELSE id.InvoiceDate END) as InvoiceDate,
	id.InvoiceDate as InvoiceDateOriginal,
	id.InvoiceDueDate,
	id.Comment as BatchUploadComment,
	'insert' [Status]
	From [IO].[L_InvoiceDetail] id
	left join cre.deal d on d.credealid = id.credealid
	where BatchLogGenericID = @BatchLogGenericID
	and id.[status] = 'InProcess'



	INSERT INTO CRE.InvoiceDetail
	(
	ObjectTypeID,
	ObjectID,
	Amount,
	FirstName,
	LastName,
	Designation,
	CompanyName,
	Address,
	City,
	Zip,
	Email1,
	Email2,
	PhoneNo,
	AlternatePhone,
	Comment,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	DrawFeeStatus,
	InvoiceTypeID,
	StateID,
	SystemInvoiceNo,
	DealID,
	InvoiceDate,
	InvoiceDateOriginal,
	InvoiceDueDate,
	BatchUploadComment,
	UploadedFrom
	
	)
	Select 
	ObjectTypeID,
	ObjectID,
	Amount,
	FirstName,
	LastName,
	Designation,
	CompanyName,
	Address,
	City,
	Zip,
	Email1,
	Email2,
	PhoneNo,
	AlternatePhone,
	Comment,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	DrawFeeStatus,
	InvoiceTypeID,
	StateID,
	SystemInvoiceNo,
	DealID,
	InvoiceDate,
	InvoiceDateOriginal,
	InvoiceDueDate,
	BatchUploadComment,
	'M61Addin' as UploadedFrom
	From [#InvoiceDetail] where [Status] = 'insert'
	


	Update  [IO].[L_InvoiceDetail] set [Status] = 'Imported' 
	where BatchLogGenericID = @BatchLogGenericID and [Status] = 'InProcess' 


END

