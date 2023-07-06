CREATE TABLE [CRE].[FeeTransactionTypeMaster] (
    [FeeTransactionTypeMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [TransactionType]            NVARCHAR (256) NULL,
    [TranDesc]                   NVARCHAR (256) NULL,
    CONSTRAINT [PK_FeeTransactionTypeMasterID] PRIMARY KEY CLUSTERED ([FeeTransactionTypeMasterID] ASC)
);

