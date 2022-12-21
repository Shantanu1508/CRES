CREATE TYPE [dbo].[TableTypeYieldCalcInput] AS TABLE
(
	CRENoteID  NVARCHAR (256) ,
	NPVdate Date,
	[Value] decimal(28,15),
	Effectivedate date,
	AnalysisID Uniqueidentifier,
	YieldType   NVARCHAR (256) 
)
