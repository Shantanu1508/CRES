CREATE PROCEDURE [dbo].[usp_UpdateAutomationRequestsSentEmailToY]    --'FundingMoveToNextMonth'
   @BatchType nvarchar(256)
AS    
BEGIN          
        
 SET NOCOUNT ON;          


 IF(@BatchType = 'All_AutoSpread_Deals') 
	BEGIN
		
		update Core.AutomationRequests    set isEmailSent=3 
		where isEmailSent =4 and BatchType in ('All_AutoSpread_Deals','CommitmentDiscrepancy','Phantom_Deal') 

	END
	ELSE
	BEGIN
		update Core.AutomationRequests    set isEmailSent=3 
		where isEmailSent =4 and BatchType = @BatchType
	END




    
END 