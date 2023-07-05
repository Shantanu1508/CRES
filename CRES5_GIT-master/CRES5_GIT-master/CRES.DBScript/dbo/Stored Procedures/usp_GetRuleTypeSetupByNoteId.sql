-- Procedure
-- [dbo].[usp_GetRuleTypeSetupByDealId]  'dad87b1b-67fd-4a95-987f-4e25da966892'        
CREATE PROCEDURE [dbo].[usp_GetRuleTypeSetupByNoteId]         
        
@NoteID UNIQUEIDENTIFIER   

        
AS        
BEGIN        
      
select        
a.AnalysisID, 
a.NoteID,
a.RuleTypeMasterID,      
a.RuleTypeDetailID,      
b.FileName,      
c.RuleTypeName      
from [CRE].[DealNoteRuleTypeSetup] a      
inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID      
inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID      
where a.NoteID=@NoteID












       
END  
GO