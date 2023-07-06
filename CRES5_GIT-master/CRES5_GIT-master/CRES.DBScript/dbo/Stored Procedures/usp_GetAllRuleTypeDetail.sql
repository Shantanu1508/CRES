-- [dbo].[usp_GetAllRuleTypeDetail]  'B0E6697B-3534-4C09-BE0A-04473401AB93'  
CREATE PROCEDURE [dbo].[usp_GetAllRuleTypeDetail]    
    @UserID UNIQUEIDENTIFIER  
  
AS    
BEGIN    
 SET NOCOUNT ON;    
  
 select  
 a.RuleTypeDetailID,  
 a.FileName,  
 a.RuleTypeMasterID,
 b.RuleTypeName
  
 from [CRE].[RuleTypeDetail] a 
 inner join [CRE].[RuleTypeMaster] b on b.RuleTypeMasterID=a.RuleTypeMasterID
  
  
  
    
    
END
GO

