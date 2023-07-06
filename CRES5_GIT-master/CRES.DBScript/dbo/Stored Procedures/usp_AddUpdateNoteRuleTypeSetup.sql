-- Procedure
CREATE PROCEDURE [dbo].[usp_AddUpdateNoteRuleTypeSetup]       
(    
@tblnoteruletypesetup tblnoteruletypesetup READONLY,    
@CreatedBy nvarchar(256)    
)     
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;    
    
 Delete from [CRE].[DealNoteRuleTypeSetup] where NoteID=(select top 1 NoteID from @tblnoteruletypesetup) and AnalysisId in (Select Distinct AnalysisID from @tblnoteruletypesetup)     
    
     Insert into [CRE].[DealNoteRuleTypeSetup]    
    (          
     AnalysisID,    
  NoteID,    
     RuleTypeMasterID ,    
     RuleTypeDetailID,    
     CreatedBy,     
     CreatedDate,    
     UpdatedBy,     
     UpdatedDate    
    )            
    select asr.AnalysisID,asr.NoteID,asr.RuleTypeMasterID,asr.RuleTypeDetailID,@CreatedBy,getdate(),@CreatedBy,getdate()  from @tblnoteruletypesetup asr  
	where  isnull(asr.RuleTypeDetailID,0) <> 0
         
      
    
        
            
END  
GO