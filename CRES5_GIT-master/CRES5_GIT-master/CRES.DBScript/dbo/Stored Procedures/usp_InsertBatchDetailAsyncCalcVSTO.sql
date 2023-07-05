
---[dbo].[usp_CreateNewBatchLogIDForVSTOAsyncCalc] 'vishal'

CREATE PROCEDURE [dbo].[usp_InsertBatchDetailAsyncCalcVSTO]
 @BatchLogID int,
 @CRENoteID nvarchar(256),
 @SizerScenario nvarchar(256)
AS  
BEGIN  
  
   	
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

    Declare @BatchDetailAsyncCalcVSTOID int;

	INSERT INTO [CRE].BatchDetailAsyncCalcVSTO(
	  [BatchLogAsyncCalcVSTOID],
	  [CRENoteID],
	  [Status],
	  StartTime,
	  SizerScenario
	  )
	VALUES (
	@BatchLogID,
	@CRENoteID,
	'Running',
	getdate(),
	@SizerScenario
	)

    SET @BatchDetailAsyncCalcVSTOID = @@IDENTITY

    Select @BatchDetailAsyncCalcVSTOID as BatchDetailAsyncCalcVSTOID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
