CREATE TYPE [dbo].[TableTypetransactionTypes] AS TABLE (
    [TransactionTypesID]             INT            NULL,
    [TransactionName]                NVARCHAR (256) NULL,
    [TransactionCategory]            NVARCHAR (256) NULL,
    [TransactionGroup]               NVARCHAR (256) NULL,
    [Calculated]                     INT            NULL,
    [IncludeCashflowDownload]        INT            NULL,
    [IncludeServicingReconciliation] INT            NULL,
    [IncludeGAAPCalculations]        INT            NULL,
    [AllowCalculationOverride]       INT            NULL,
    [CreatedBy]                      NVARCHAR (256) NULL,
    [CreatedDate]                    DATETIME       NULL,
    [UpdatedBy]                      NVARCHAR (256) NULL,
    [UpdatedDate]                    DATETIME       NULL,
    [Cash_NonCash]                   NVARCHAR(256) NULL,
	[AccountName]                    NVARCHAR (256) NULL
	);
	
