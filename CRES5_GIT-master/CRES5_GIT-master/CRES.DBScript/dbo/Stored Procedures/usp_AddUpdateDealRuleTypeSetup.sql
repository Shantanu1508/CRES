-- Procedure
CREATE PROCEDURE [dbo].[usp_AddUpdateDealRuleTypeSetup]       
(    
@tbldealruletypesetup tbldealruletypesetup READONLY,    
@CreatedBy nvarchar(256)    
)     
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;    
  
 Delete from [CRE].[DealNoteRuleTypeSetup] where DealID=(select top 1 DealID from @tbldealruletypesetup) and AnalysisId in (Select Distinct AnalysisID from @tbldealruletypesetup)       
    
     Insert into [CRE].[DealNoteRuleTypeSetup]    
    (          
     AnalysisID,    
     DealID,    
     RuleTypeMasterID ,    
     RuleTypeDetailID,    
     CreatedBy,     
     CreatedDate,    
     UpdatedBy,     
     UpdatedDate    
    )            
    select asr.AnalysisID,asr.DealID,asr.RuleTypeMasterID,asr.RuleTypeDetailID,@CreatedBy,getdate(),@CreatedBy,getdate()  from @tbldealruletypesetup asr  
	where  isnull(asr.RuleTypeDetailID,0) <> 0
         
      
    
        
            
END  
GO