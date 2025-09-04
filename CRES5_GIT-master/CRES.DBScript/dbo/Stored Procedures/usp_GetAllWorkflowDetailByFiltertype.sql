-- Procedure
CREATE PROCEDURE [dbo].[usp_GetAllWorkflowDetailByFiltertype]   
(  
	@UserID UNIQUEIDENTIFIER, 
	@FilterType varchar(100), -- 0: all, 1: respective  
	@PgeIndex INT,  
	@PageSize INT,  
	@TotalCount INT OUTPUT,
	@CREDealID nvarchar(256)=null
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
declare @TWFTaskDetailID table(
WFTaskDetailID int
)
declare @TFCApproverTaskID table(
TaskID uniqueidentifier
)

if (@FilterType='respective')
BEGIN
insert into @TFCApproverTaskID
select TaskID from cre.WFTaskAdditionalDetail where FCApprover = @UserID
END

insert into @TWFTaskDetailID
Select MAX(WFTaskDetailID) WFTaskDetailID from cre.WFTaskDetail where isnull(IsDeleted,0)<>1 group by TaskID,SubmitType
having SubmitType=498


Select WFTaskDetailID,a.TaskID,a.TaskTypeID,SubmitType,WorkFlowComment,WFStatusPurposeMappingID,PurposeTypeId,OrderIndex,WFStatusMasterID
,TaskTypeIDText,SubmitTypeText,PurposeID,PurposeIDText,Applied,dealfunComment,DrawFundingID,CREDealID,DealName,Deadline,Fundingdate
,Amount,StatusName,Username,wf_isAllow ,FundingApprovalRequired,PAMUsername,AMOUsername,
FCApprover as UserID
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
 --1 as wf_isAllow,  
 --[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](502,td.TaskID,@UserID, @FilterType,null,null,null,null,null) as wf_isAllow,  
 1 as wf_isAllow,  
 --[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserIDAndStatus](td.TaskID,@UserID, sm.StatusName) as wf_isAllow,  
  lCheckList.name as FundingApprovalRequired,
 d.UpdatedDate,
 pam.FirstName +' '+ pam.LastName as PAMUsername,  
 amo.FirstName +' '+ amo.LastName as AMOUsername,
 ad.FCApprover
 from cre.WFTaskDetail td 
 join @TWFTaskDetailID t on  t.WFTaskDetailID=td.WFTaskDetailID
 left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID  
 left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID  
 left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27  
 left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77  

 join cre.DealFunding df on df.DealFundingID = td.TaskID  
 join cre.Deal d on d.DealID = df.DealID 
 left join cre.WFchecklistdetail wcd on wcd.TaskID=td.TaskID and wcd.WFCheckListMasterID=6 
 left join core.Lookup lPurposeID on lPurposeID.LookupID = df.PurposeID and lPurposeID.ParentID = 50  
   left join core.Lookup lCheckList on lCheckList.LookupID = wcd.CheckListStatus 
 left join app.[user] u on u.UserID = td.UpdatedBy 
 left join app.[user] pam on pam.UserID = d.AMUserID
 left join app.[user] amo on amo.UserID = d.AMTeamLeadUserID
 left join cre.WFTaskAdditionalDetail ad on ad.TaskID=td.TaskID
 
 Where df.Applied <> 1
 and sm.WFStatusMasterID not in (1,5)
 --and (df.Date > (getdate() - 1) and df.Date < (getdate() + 60))
 and isnull(td.IsDeleted,0)<>1
 and ISNULL(d.LinkedDealID,'')=''
 and isnull(d.IsDeleted,0)<>1
 and td.TaskTypeID=502
 and ((@FilterType='respective' and (d.AMUserID=@UserID or d.AMSecondUserID=@UserID or d.AMTeamLeadUserID=@UserID 
 or td.TaskID in (select TaskID from @TFCApproverTaskID)
 )) or (@FilterType='all' or @FilterType=''))
 and ((isnull(@CREDealID,'')!='' and d.CREDealID=@CREDealID) or isnull(@CREDealID,'')='')
)a  

--join cre.WFTaskAdditionalDetail wt on wt.TaskID=a.TaskID and wt.TaskTypeID=a.TaskTypeID
--where a.wf_isAllow = 1  
--where a.DealName='RNY Suburban Office Portfolio'
ORDER BY a.FundingDate  
 --OFFSET (@PgeIndex - 1)*@PageSize ROWS  
 --FETCH NEXT @PageSize ROWS ONLY  
  
END  
  
