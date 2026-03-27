CREATE TYPE [dbo].[TableTypeXIRROverride] AS TABLE (
	[XIRRConfigID]		INT,
	[DealAccountID]		UNIQUEIDENTIFIER,	
	[XIRR]				Decimal(28,15),
	[IsOverride]		bit NULL
);