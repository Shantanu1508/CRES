CREATE PROCEDURE [dbo].[usp_AddUpdateAnalysisRuleTypeSetup]     
(  
@tblanalysisruletypesetup tblanalysisruletypesetup READONLY,  
@CreatedBy nvarchar(256)  
)   
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;  
  
 Delete from [CRE].[AnalysisRuleTypeSetup] where AnalysisID=(select top 1 asr.AnalysisID from @tblanalysisruletypesetup asr)  
  
     Insert into [CRE].[AnalysisRuleTypeSetup]  
    (        
     AnalysisID,  
     RuleTypeMasterID ,  
     RuleTypeDetailID,  
     CreatedBy,   
     CreatedDate,  
     UpdatedBy,   
     UpdatedDate  
    )          
    select asr.AnalysisID,
	asr.RuleTypeMasterID,
	asr.RuleTypeDetailID,
	@CreatedBy,
	getdate(),
	@CreatedBy,
	getdate()  
	from @tblanalysisruletypesetup asr  
       

          
END
GO

