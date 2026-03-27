CREATE PROCEDURE [dbo].[usp_GetEquityCapitalTransactions]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	[Equity  Name], 
	[Description], 
	[CRENoteID], 
	[Transaction Date], 
	[Transaction Amount], 
	[Confirmed], 
	[Comments], 
	[Asset ID (Deal or Note ID)], 
	[Source], 
	[EndingBalance] 
	FROM [dbo].[EquityCapitalTransactions]
END
GO

