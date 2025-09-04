CREATE TABLE DW.NoteCFPerFromDailyIntAccBI(
NoteID  	UNIQUEIDENTIFIER	,
Date 	Date	,
AnalysisID	UNIQUEIDENTIFIER	,
IndexRate	Decimal(28,15)	,
AllInCouponRate	Decimal(28,15)	,
AllInPikRate	Decimal(28,15)	,
PikSpreadOrRate	Decimal(28,15)	,
PIKIndexRate	Decimal(28,15)	,
SpreadOrRate	Decimal(28,15)	
)