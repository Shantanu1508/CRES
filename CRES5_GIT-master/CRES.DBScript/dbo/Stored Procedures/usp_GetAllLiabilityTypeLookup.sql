-- Procedure
CREATE PROCEDURE [dbo].[usp_GetAllLiabilityTypeLookup]
AS    
BEGIN    
    
Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type], ac.AssetOrLiability, ac.Name as DebtEquityType  ,d.DebtGUID as LiabilityGUID,bank.BankerName as BankerName
from cre.Debt d     
Inner Join core.Account acc on acc.AccountID =  d.AccountID     
Left Join core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID 
left join [CRE].[LiabilityBanker] bank on bank.LiabilityBankerID = d.LiabilityBankerID
where  IsDeleted<> 1     

    
UNION ALL      
    
Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type], ac.AssetOrLiability, ac.Name as DebtEquityType     ,d.EquityGUID as LiabilityGUID  ,''as BankerName
from cre.Equity d     
Inner Join core.Account acc on acc.AccountID =  d.AccountID     
Left Join core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID  
where IsDeleted<> 1     
  
UNION ALL      
    
Select acc.AccountID as AccountID,acc.name as [Text] ,'Cash' as [Type], ac.AssetOrLiability, ac.Name as DebtEquityType    , d.CashGUID as LiabilityGUID   ,''as BankerName
from cre.Cash d     
Inner Join core.Account acc on acc.AccountID =  d.AccountID     
Left Join core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID  
where IsDeleted<> 1   

    
    
END
GO

