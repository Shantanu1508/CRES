-- [dbo].[usp_GetRuleTypeSetupByAnalysisId] 'e50c2a12-5d4b-4540-a9c0-db06d73f919d'        
CREATE PROCEDURE [dbo].[usp_GetRuleTypeSetupByAnalysisId]         
        
@AnalysisID UNIQUEIDENTIFIER      
        
AS        
BEGIN        
select
a.AnalysisId,
a.RuleTypeMasterID,   
a.RuleTypeDetailID,   
c.RuleTypeName  ,   
b.FileName   
from [CRE].[AnalysisRuleTypeSetup] a     
left join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID   
inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID   
where a.AnalysisID=@AnalysisID   
  
UNION ALL   
select   Distinct
null as AnalysisId,
m.RuleTypeMasterID, 
null as RuleTypeDetailID, 
m.RuleTypeName,
null as FileName   
from  [CRE].[RuleTypeMaster]  m  
inner join [CRE].[RuleTypeDetail] d on m.RuleTypeMasterID=d.RuleTypeMasterID   
where  m.RuleTypeMasterID not in (Select Distinct RuleTypeMasterID from [CRE].[AnalysisRuleTypeSetup] where AnalysisID=@AnalysisID)     
        
        
END
GO

