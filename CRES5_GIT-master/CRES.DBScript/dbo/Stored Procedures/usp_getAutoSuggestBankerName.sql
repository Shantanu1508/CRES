CREATE PROCEDURE [dbo].[usp_getAutoSuggestBankerName]   
  @SearchKey VARCHAR(500)
AS  
BEGIN  
  
Select LiabilityBankerID, BankerName 
from [CRE].[LiabilityBanker] 
where BankerName LIKE '%' + @SearchKey + '%'  

END  

 