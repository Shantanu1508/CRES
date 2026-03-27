CREATE PROCEDURE [dbo].[usp_GetLiabilityTypeLookup]   
  @SearchKey VARCHAR(500)
AS  
BEGIN  
  
Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type]
from cre.Debt d 
Inner Join core.Account acc on acc.AccountID =  d.AccountID 
where  IsDeleted<> 1  and acc.name LIKE '%' + @SearchKey + '%'  

UNION ALL  

Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type]
from cre.Equity d 
Inner Join core.Account acc on acc.AccountID =  d.AccountID 
where IsDeleted<> 1   and acc.name LIKE '%' + @SearchKey + '%' 


UNION ALL    
   
Select acc.AccountID as AccountID,acc.name as [Text] ,'Cash' as [Type]
from cre.Cash d 
Inner Join core.Account acc on acc.AccountID =  d.AccountID 
where IsDeleted<> 1   and acc.name LIKE '%' + @SearchKey + '%' 

  
END  

 