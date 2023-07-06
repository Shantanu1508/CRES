CREATE TYPE [dbo].[TableTypeProjectedPayOffDate] AS TABLE
(
	DealID uniqueidentifier,
	ProjectedPayoffAsofDate date,
	CumulativeProbability decimal(28,15)
)
