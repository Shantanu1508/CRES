  
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryVSTO]  
  
@TableTypeTransactionEntry [TableTypeTransactionEntryVSTO] READONLY,  
@CRENoteID nvarchar(256)
  
AS  
BEGIN  
    SET NOCOUNT ON;  

		Declare @BatchDetailAsyncCalcVSTOId int = (select Top 1 BatchDetailAsyncCalcVSTOId from @TableTypeTransactionEntry)
	DELETE FROM [CRE].TransactionEntryVSTO WHERE CRENoteID = @CRENoteID and BatchDetailAsyncCalcVSTOId = @BatchDetailAsyncCalcVSTOId

   INSERT INTO [CRE].TransactionEntryVSTO  
	(  
		BatchDetailAsyncCalcVSTOId,
		CRENoteID,
		[Date],
		Amount,
		[Type],
		FeeName,
		SizerScenario,
		NoteName
	)  
	Select  
	BatchDetailAsyncCalcVSTOId,
	CRENoteID,
	[Date],
	Amount,
	[Type],
	FeeName,
	SizerScenario,
	NoteName
	FROM @TableTypeTransactionEntry  
  
 

END  