--Drop TABLE [CRE].[ReserveAccount]

CREATE TABLE [CRE].[ReserveAccount] (
    [ReserveAccountID] INT      IDENTITY (1, 1) NOT NULL,
	[ReserveAccountGUID] UNIQUEIDENTIFIER DEFAULT (newid()) Not NULL,
	[CREReserveAccountID]  NVARCHAR (256)   NULL,
	[DealID]				UNIQUEIDENTIFIER NULL,
	[ReserveAccountName] NVARCHAR (256)   NULL,
	[InitialBalanceDate] Date NULL,
	[InitialFundingAmount] DECIMAL (28, 15) NULL,
	[EstimatedReserveBalance] DECIMAL (28, 15) NULL,
	[CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
	[FloatInterestRate]  DECIMAL (28, 15) NULL
	CONSTRAINT [PK_ReserveAccount_ReserveAccountID] PRIMARY KEY CLUSTERED  ([ReserveAccountID] ASC)

);

