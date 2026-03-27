Create PROCEDURE [dbo].[usp_GetDealFundingScheduleByDealID] ---'a48f6318-37ef-41ca-8143-1b84484974c0'      
(      
    @DealID UNIQUEIDENTIFIER      
       
)      
       
AS      
BEGIN      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
      
Select      
  fs.DealFundingID,       
  fs.[DealID]      
 ,fs.[Date]      
 ,fs.[Amount]      
 ,fs.[Comment]      
 ,fs.[PurposeID]      
 ,fs.UpdatedDate      
 ,l1.name PurposeText      
 ,fs.DealFundingRowno      
 ,ISNULL(fs.Applied,0) Applied      
 ,ISNULL(fs.AdjustmentType,836) AdjustmentType      
 ,DrawFundingId      
 ,DeadLineDate     
 ,LegalDeal_DealFundingID     
 ,fs.EquityAmount     
 ,RemainingFFCommitment     
 ,RemainingEquityCommitment     
 ,SubPurposeType     
 ,RequiredEquity     
 ,AdditionalEquity     
 ,fs.GeneratedBy   
 ,fs.GeneratedByUserID
 ,(CASE WHEN tblPhtm.dealid is not null THEN NULL ELSE tblWF.WF_CurrentStatus END) as WF_CurrentStatus  
    
      
from [CRE].[DealFunding] fs      
left join cre.deal d on d.DealID = fs.DealID      
Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID    
  
LEFT JOIN(  
 select DealID from cre.deal where [status]=325 and isnull(linkeddealid,'') ='' and DealID = @DealID  
)tblPhtm on tblPhtm.dealid = d.dealid  
Left Join(  
  Select TaskId,StatusName as WF_CurrentStatus,WF_CurrentStatusDisplayName,WF_isParticipate,OrderIndex  
  From(  
   SELECT td.TaskId  
   ,sm.StatusName  
   ,td.WFTaskDetailID   
   ,(Case WHEN tblNoti.taskid is not null and sm.StatusName='Completed' then 'Completed'   
    when (lPurposeType.Value1='WF_UNDERREVIEW' or df.[Amount] = 0) then sm.WFUnderReviewDisplayName   
    else sm.DealFundingDisplayName end) as WF_CurrentStatusDisplayName  
   ,ROW_NUMBER() OVER(Partition by td.TaskId order by td.TaskId,td.WFTaskDetailID desc) rno  
   ,COUNT( td.WFTaskDetailID ) OVER(Partition by td.TaskId) WF_isParticipate  
   ,spm.OrderIndex  
  
   FROM [CRE].[WFTaskDetail] td         
   INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID        
   INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID      
   left JOin(  
    select TaskID from cre.WFNotification where WFNotificationMasterID=2 and ActionType=577  
   )tblNoti on tblNoti.taskid = td.taskid   
   LEFT JOIN cre.dealfunding df on df.dealfundingid = td.taskid  
   LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = df.PurposeID and lPurposeType.ParentID = 50   
   WHERE td.TaskId in (Select dealfundingid from cre.dealfunding where dealid = @DealID)   
  )a  
  where rno = 1  
)tblWF on tblWF.TaskId = fs.dealfundingid  
  
  
    
where fs.DealID = @DealID and d.IsDeleted = 0         
order by fs.[Date]      
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
      
END 