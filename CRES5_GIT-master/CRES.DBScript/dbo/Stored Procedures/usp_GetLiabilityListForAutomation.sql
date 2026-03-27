CREATE PROCEDURE [dbo].[usp_GetLiabilityListForAutomation] --'LiabilityCalculation'    
 @type nvarchar(256)     
AS    
BEGIN          
        
 SET NOCOUNT ON;          
    
Declare @tblLiability as table(AccountID nvarchar(256))      
  
Delete from @tblLiability    
    
IF((Select [value] from [App].[AppConfig] where [Key] = 'AllowLiabilityAutomation') = 1)  
BEGIN  

 IF(@type = 'LiabilityCalculation')    
 BEGIN    
  INSERT INTO @tblLiability(AccountID)    
  Select distinct eq.AccountID
  from cre.Equity eq
  inner join core.account acc on acc.AccountID = eq.AccountID
  where acc.IsDeleted <> 1
 END 

END  
    
    
    
IF EXISTS(Select top 1 AccountID from @tblLiability)     
BEGIN      
 select AccountID from @tblLiability    

END    
    
    
END
GO

