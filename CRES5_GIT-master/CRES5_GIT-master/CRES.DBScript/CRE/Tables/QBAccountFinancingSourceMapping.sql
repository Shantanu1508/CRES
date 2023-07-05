CREATE TABLE [CRE].[QBAccountFinancingSourceMapping]
(
	[QBAccountFinancingSourceMappingID] INT            IDENTITY (1, 1) NOT NULL,
    [FinancingSourceID]                 INT            NULL,
    [QBAccountNo]                       NVARCHAR (256) NULL,    
    [InvoiceTypeID]                     INT            NULL,
    [QBItemName]                       NVARCHAR (256) NULL
)
go
ALTER TABLE [CRE].[QBAccountFinancingSourceMapping]
ADD CONSTRAINT PK_QBAccountFinancingSourceMapping_QBAccountFinancingSourceMappingID PRIMARY KEY ([QBAccountFinancingSourceMappingID]);