-- Procedure  
-- [dbo].[usp_GetRuleTypeSetupByDealId]  'D73C24C9-797C-4165-8EF3-C1AE5839C513'            
CREATE PROCEDURE [dbo].[usp_GetRuleTypeSetupByDealId]             
            
@DealID UNIQUEIDENTIFIER       
  
AS            
BEGIN            
          
select                 
a.AnalysisID,    
a.DealID,    
a.RuleTypeMasterID,          
a.RuleTypeDetailID,           
c.RuleTypeName,       
b.FileName,
d.Name as AnalysisName
from [CRE].[DealNoteRuleTypeSetup] a          
left join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID          
left join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID 
left join [CORE].[Analysis] d on d.AnalysisID=a.AnalysisID
where a.DealID=@DealID     
           
  
  
  
  
  
  
  
  
  
  
            
            
END 
GO