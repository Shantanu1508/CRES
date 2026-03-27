-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertDebtDrawsPaydowns]
(
	@tbltype_DebtDrawsPaydowns [TableTypeDebtDrawsPaydowns] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[DebtDrawsPaydowns];
	
	INSERT INTO [dbo].[DebtDrawsPaydowns]([Liability  Name],[Description],[CRENoteID],[Transaction Date],[Transaction Amount],[Confirmed],[Comments],[Asset ID (Deal or Note ID)]) 
	SELECT [LiabilityName],[Description],[CRENoteID],[TransactionDate],[TransactionAmount],[Confirmed],[Comments],[AssetIDDealorNoteID] FROM @tbltype_DebtDrawsPaydowns;

END