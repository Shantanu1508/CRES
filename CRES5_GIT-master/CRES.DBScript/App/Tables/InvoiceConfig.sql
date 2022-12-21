CREATE TABLE [App].[InvoiceConfig] (
    [InvoiceConfigID]  INT            IDENTITY (1, 1) NOT NULL,
    [InvoiceTypeID]    INT            NULL,
    [InvoiceCode]      NVARCHAR (256) NULL,
    [Template]         NVARCHAR (256) NULL,
    [IsApplySplit]     BIT            DEFAULT ((0)) NOT NULL,
    [InvoiceAccountNo] NVARCHAR (256) NULL,
    CONSTRAINT [PK_InvoiceConfigID_InvoiceConfigID] PRIMARY KEY CLUSTERED ([InvoiceConfigID] ASC)
);


go


