CREATE PROCEDURE [dbo].[usp_GetDebtDrawsPaydowns]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	[Liability  Name], 
	[Description], 
	[CRENoteID], 
	[Transaction Date], 
	[Transaction Amount], 
	[Confirmed], 
	[Comments], 
	[Asset ID (Deal or Note ID)] 
	FROM [dbo].[DebtDrawsPaydowns]
END
GO

