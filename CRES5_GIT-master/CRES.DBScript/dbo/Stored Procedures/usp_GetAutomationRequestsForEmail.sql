CREATE PROCEDURE [dbo].[usp_GetAutomationRequestsForEmail]    
   @BatchType nvarchar(256)
AS    
BEGIN          
        
 SET NOCOUNT ON;          
    
   
select ar.BatchType,d.CREDealID,d.DealName,ae.Message,ae.DealFundingID,ae.Date ,ae.Amount,ae.PurposeType as Purpose ,d.AMUserID,d.AMSecondUserID,u1.Email,u2.Email as SeconderyEmail  
from Core.AutomationRequests ar  
inner join CRE.Deal d on d.DealID = ar.DealID 
left join(
	Select BatchID,Dealid,Message,DealFundingID ,Amount,PurposeType,Date
	from core.AutomationExtension ae
	where ae.DealFundingID is not null
)ae on ae.BatchID = ar.Batchid and ae.dealID = ar.dealID 
left join CRE.DealFunding df on df.DealFundingID=ae.DealFundingID 
left join core.lookup lpurpose on lpurpose.lookupid = df.purposeid 
left join App.[User] u1 on u1.UserID= d.AMUserID 
left join App.[User] u2 on u2.UserID = d.AMSecondUserID 
where isEmailSent=4  
and ar.StatusID=266
and ae.DealFundingID is not null  
and BatchType = @BatchType
    
END 