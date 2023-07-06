--DROP TYPE [dbo].[TableTypeReserveAccount]
CREATE TYPE [dbo].[TableTypeReserveAccount] AS TABLE (
	ReserveAccountGUID uniqueidentifier,
	DealID uniqueidentifier,
	CREReserveAccountID NVARCHAR (256),
	ReserveAccountName  NVARCHAR (256),
	InitialBalanceDate Date,
	InitialFundingAmount DECIMAL (28, 15),
	EstimatedReserveBalance DECIMAL (28, 15),
	FloatInterestRate DECIMAL (28, 15)
);
