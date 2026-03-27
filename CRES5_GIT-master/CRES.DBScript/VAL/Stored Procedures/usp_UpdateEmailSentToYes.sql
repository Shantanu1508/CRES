CREATE PROCEDURE [val].[usp_UpdateEmailSentToYes]    
AS  
BEGIN  
  
 SET NOCOUNT ON;
	update val.ValuationRequests set isEmailsent=3 where isEmailsent=4  
END
GO

