
CREATE PROCEDURE [DBO].[usp_GetRequestIDFromCalculationRequests_DataNotSaveInDB] 
AS
BEGIN
	SET NOCOUNT ON;


Select top 2 RequestID from core.CalculationRequests 
where ErrorMessage = 'Note calculated successfully but failed to save data in DB.Retry'  
and RequestID is not null

END

