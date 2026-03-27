-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertEquityCapitalTransactions]
(
	@tbltype_EquityCapitalTransactions [TableTypeEquityCapitalTransactions] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[EquityCapitalTransactions];
	
	INSERT INTO [dbo].[EquityCapitalTransactions]([Equity  Name],[Description],[CRENoteID],[Transaction Date],[Transaction Amount],[Confirmed],[Comments],[Asset ID (Deal or Note ID)],[Source],[EndingBalance]) 
	SELECT [EquityName],[Description],[CRENoteID],[TransactionDate],[TransactionAmount],[Confirmed],[Comments],[AssetIDDealorNoteID],[Source],[EndingBalance] FROM @tbltype_EquityCapitalTransactions;

END