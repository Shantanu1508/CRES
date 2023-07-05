
  
CREATE PROCEDURE [dbo].[usp_GetAllWorkflowDetail]   
(  
	@UserID UNIQUEIDENTIFIER,  
	@PgeIndex INT,  
	@PageSize INT,  
	@TotalCount INT OUTPUT   
)  
   
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @wf_isAllow INT  
  
--  Select @TotalCount =  COUNT(WFTaskDetailID), @wf_isAllow = wf_isAllow  
--   from(  
-- Select   
-- td.WFTaskDetailID,  
-- --[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](td.TaskID,@UserID) as wf_isAllow   
-- --[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserIDAndStatus](td.TaskID,@UserID, sm.StatusName) as wf_isAllow  
--  1 as wf_isAllow

-- from cre.WFTaskDetail td  
-- left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID  
-- left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID  
-- left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27  
-- left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77  
   
-- left join cre.DealFunding df on df.DealFundingID = td.TaskID  
-- left join cre.Deal d on d.DealID = df.DealID  
-- left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 50  
-- left join app.[user] u on u.UserID = td.UpdatedBy    
---- Where td.WFTaskDetailID in (Select MAX(WFTaskDetailID) from cre.WFTaskDetail group by TaskID) 
-- and  df.Applied <> 1
-- and sm.StatusName <> 'Completed'
-- and (df.fundingdate > (getdate() - 1) and df.fundingdate < (getdate() + 60) 
--)a   
--where a.wf_isAllow = 1  
--GROUP BY wf_isAllow  
  

--Use commented query for enable pagination

 SET @TotalCount = 1;
  
  
  
Select WFTaskDetailID,TaskID,TaskTypeID,SubmitType,WorkFlowComment,WFStatusPurposeMappingID,PurposeTypeId,OrderIndex,WFStatusMasterID,TaskTypeIDText,SubmitTypeText,PurposeID,PurposeIDText,Applied,dealfunComment,DrawFundingID,CREDealID,DealName,Deadline,Fundingdate,Amount,StatusName,Username,wf_isAllow  
from(  
 Select   
 td.WFTaskDetailID,  
 td.TaskID,  
 td.TaskTypeID,  
 td.SubmitType,  
 td.Comment as WorkFlowComment,  
 td.WFStatusPurposeMappingID,  
 mapp.PurposeTypeId,  
 mapp.OrderIndex,  
 mapp.WFStatusMasterID,    
 lTaskTypeID.name as TaskTypeIDText,  
 lSubmitType.name as SubmitTypeText,     
 df.PurposeID,  
 lPurposeID.Name as PurposeIDText,  
 df.Applied,  
 df.Comment as dealfunComment,  
 df.DrawFundingID,      
 d.CREDealID,  
 d.DealName,  
 df.DeadlineDate as Deadline,  
 df.Date as Fundingdate,  
 df.Amount,  
 sm.StatusName,  
 u.FirstName +' '+ u.LastName as Username,  
 1 as wf_isAllow,  
 --[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](td.TaskID,@UserID) as wf_isAllow,  
 --[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserIDAndStatus](td.TaskID,@UserID, sm.StatusName) as wf_isAllow,  
 
 d.UpdatedDate 
   
 from cre.WFTaskDetail td  
 left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID  
 left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID  
 left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27  
 left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77  
   
 left join cre.DealFunding df on df.DealFundingID = td.TaskID  
 join cre.Deal d on d.DealID = df.DealID  
 left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 50  
 left join app.[user] u on u.UserID = td.UpdatedBy    
 Where td.WFTaskDetailID in (Select MAX(WFTaskDetailID) from cre.WFTaskDetail group by TaskID)  
 and  df.Applied <> 1
 and sm.StatusName <> 'Completed'
 and (df.Date > (getdate() - 1) and df.Date < (getdate() + 60))
 and td.IsDeleted=0
 and ISNULL(d.LinkedDealID,'')=''

)a  
where a.wf_isAllow = 1  
ORDER BY a.FundingDate  
  
  
 --OFFSET (@PgeIndex - 1)*@PageSize ROWS  
 --FETCH NEXT @PageSize ROWS ONLY  
  
END  
  
