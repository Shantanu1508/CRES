CREATE TYPE [val].[tbltype_NoteCashflowOverride] AS TABLE
(
	NoteCashFlowID    INT,
	MarkedDate    Date ,	
	ValueOverride	decimal(28,15),	
	UserID	nvarchar(256)
)

