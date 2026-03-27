CREATE PROCEDURE [dbo].[usp_GetAutoConfirmAmortizationRecords]  
 
AS  
BEGIN        
      
 SET NOCOUNT ON;        
  
 
  select d.CREDealID,d.DealName,ae.Message ,df.Date ,df.Amount,lpurpose.name as Purpose ,d.AMUserID,d.AMSecondUserID,u1.Email,u2.Emailfrom Core.AutomationRequests ar inner join CRE.Deal d on d.DealID = ar.DealIDInner join core.AutomationExtension  ae on ae.BatchID = ar.BatchID and ar.dealid = ae.dealid and ae.DealFundingID is not nullinner join CRE.DealFunding df on df.DealFundingID=ae.DealFundingIDleft join core.lookup lpurpose on lpurpose.lookupid = df.purposeidleft join App.[User] u1 on u1.UserID = d.AMUserIDleft join App.[User] u2 on u2.UserID = d.AMSecondUserIDwhere isEmailSent=4 and AutomationType =801
 
  
  
END  