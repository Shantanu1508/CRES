-- [dbo].[usp_GetAllRuleType]  'B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE PROCEDURE [dbo].[usp_GetAllRuleType]  
    @UserID UNIQUEIDENTIFIER
AS  
BEGIN  
 SET NOCOUNT ON;  

 select distinct
 a.RuleTypeMasterID,
 a.RuleTypeName

 from [CRE].[RuleTypeMaster] a

  
  
END
GO

