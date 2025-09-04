    
    
     
CREATE PROCEDURE [dbo].[usp_InsertUpdateDealArchieveList_Automation]   
 @TmpDealArch TableTypeDealArchieve READONLY      
AS    
BEGIN    
          
 --Delete this record from main table    
 Delete from CRE.DealFunding where DealFundingID in (select DealFundingID from  @TmpDealArch)    
    
  
 IF EXISTS(Select TaskID from cre.WFTaskDetail wf where wf.TaskID in (select DealFundingID from  @TmpDealArch))    
 BEGIN      
  Update cre.WFTaskDetail SET IsDeleted=1 where TaskId in ( select DealFundingID from  @TmpDealArch)  
  Update cre.WFTaskDetailArchive SET IsDeleted=1 where TaskId in ( select DealFundingID from  @TmpDealArch)  
  Update cre.WFCheckListDetail SET IsDeleted=1 where TaskId in ( select DealFundingID from  @TmpDealArch)     
 END    
  
    
END  