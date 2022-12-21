
CREATE TABLE [IO].[L_InvoiceDetail]
(
[L_InvoiceDetailID] INT              IDENTITY (1, 1) NOT NULL,
[BatchLogGenericID] INT ,
CreDealID	nvarchar(256)	,
InvoiceDate	Date	,
InvoiceNo	nvarchar(256)	,
InvoiceDueDate	Date	,
Amount	decimal(28,15)	,
InvoiceTypeID	int	,
DrawFeeStatus	int	,
FirstName	nvarchar(256)	,
LastName	nvarchar(256)	,
Designation	nvarchar(256)	,
CompanyName	nvarchar(256)	,
Address	nvarchar(256)	,
City	nvarchar(256)	,
State	int	,
Zip	nvarchar(256)	,
Email1	nvarchar(256)	,
Email2	nvarchar(256)	,
PhoneNo	nvarchar(256)	,
AlternatePhone	nvarchar(256)	,
Comment	nvarchar(256)	,


CreatedBy nvarchar(256),
CreatedDate Datetime,
UpdatedBy nvarchar(256),
UpdatedDate Datetime,

[Status] nvarchar(256),	
[StatusComment] nvarchar(256)

CONSTRAINT [PK_L_InvoiceDetailID] PRIMARY KEY CLUSTERED (L_InvoiceDetailID ASC)
)