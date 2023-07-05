CREATE TABLE [CRE].[TransactionTypes] (
    [TransactionTypesID]             INT              IDENTITY (1, 1) NOT NULL,
    [TransactionTypesGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__Trans__03F163A3] DEFAULT (newid()) NOT NULL,
    [TransactionName]                NVARCHAR (256)   NULL,
    [TransactionCategory]            NVARCHAR (256)   NULL,
    [Calculated]                     INT              NULL,
    [IncludeCashflowDownload]        INT              NULL,
    [IncludeServicingReconciliation] INT              NULL,
    [IncludeGAAPCalculations]        INT              NULL,
    [AllowCalculationOverride]       INT              NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [TransactionGroup]               NVARCHAR (256)   NULL,
    [Cash_NonCash] NVARCHAR(256) NULL, 
    [AccountName] NVARCHAR(256) NULL, 
    CONSTRAINT [PK_TransactionTypesID] PRIMARY KEY CLUSTERED ([TransactionTypesID] ASC)
);

