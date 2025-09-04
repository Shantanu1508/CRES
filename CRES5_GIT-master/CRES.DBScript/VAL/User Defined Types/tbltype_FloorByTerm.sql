CREATE TYPE [val].[tbltype_FloorByTerm] AS TABLE
(
	MarkedDate date,
	IndexTypeName	nvarchar(256),
	[Percentage]	decimal(28,15),
	[Month]	int,
	[Value]	decimal(28,15),
	UserID	nvarchar(256)
)

