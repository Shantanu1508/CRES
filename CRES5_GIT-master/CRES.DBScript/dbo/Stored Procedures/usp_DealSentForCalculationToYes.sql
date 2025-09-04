CREATE PROCEDURE [dbo].[usp_DealSentForCalculationToYes]    
AS  
BEGIN  
  
 SET NOCOUNT ON;

update Core.AutomationRequests set isDealSentForCalc=3 where isDealSentForCalc=4  
END  
  
  


