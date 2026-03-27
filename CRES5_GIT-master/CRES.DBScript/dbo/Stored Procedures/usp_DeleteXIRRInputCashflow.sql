
CREATE PROCEDURE [dbo].[usp_DeleteXIRRInputCashflow]
	@XIRRConfigID int =null
AS
BEGIN
	SET NOCOUNT ON;	 

	IF(@XIRRConfigID is null)
	BEGIN
		IF NOT EXISTS(select XIRRCalculationRequestsID from cre.XIRRCalculationRequests  where [Status] in (292,267)) 
		BEGIN
			--there is no requests in queue
			Truncate table [CRE].[XIRRInputCashflow]
		END
		
	END
	ELSE
	BEGIN
		Print('abc')  
		--Delete From [CRE].[XIRRInputCashflow]	   where XIRRConfigID = @XIRRConfigID	
	END

END