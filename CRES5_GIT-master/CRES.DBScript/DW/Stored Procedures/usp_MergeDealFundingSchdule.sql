CREATE PROCEDURE [DW].[usp_MergeDealFundingSchdule]    
@BatchLogId int    
AS    
BEGIN    
    
SET NOCOUNT ON    
    
    
UPDATE [DW].BatchDetail    
SET    
BITableName = 'DealFundingSchduleBI',    
BIStartTime = GETDATE()    
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealFundingSchduleBI'    
    
    
DECLARE @RowCount int = 0    
    
--IF EXISTS(Select DealID from [dw].[L_DealBI])    
--BEGIN    
    
Truncate table [DW].[DealFundingSchduleBI]    
    
--Delete from [DW].[DealFundingSchduleBI] where [DealID] in (Select DealID from [dw].[L_DealBI])    
    
INSERT INTO [DW].[DealFundingSchduleBI]    
 ([DealFundingID]    
 ,[DealID]    
 ,[CREDealID]    
 ,[Date]    
 ,[Amount]        
 ,[PurposeID]      
 ,[PurposeBI]    
 ,[Applied]    
 ,[Comment]    
 ,[DrawFundingId]       
 ,[CreatedBy]    
 ,[CreatedDate]    
 ,[UpdatedBy]    
 ,[UpdatedDate]    
 ,[Projected]    
 ,GeneratedBy    
 ,GeneratedByBI     
    
 ,Issaved    
 ,DealFundingRowno    
 ,DeadLineDate    
 ,LegalDeal_DealFundingID    
 ,EquityAmount    
 ,RemainingFFCommitment    
 ,RemainingEquityCommitment    
 ,SubPurposeType    
 ,DealFundingAutoID    
 ,RequiredEquity    
 ,AdditionalEquity    
 ,AdjustmentType    
 ,AdjustmentTypeBI    
 ,WF_CurrentStatusDisplayName  
 ,WatchlistStatus
)    
Select    
d.[DealFundingID],    
d.[DealID],    
deal.[CREDealID],    
d.[Date],    
d.[Amount],    
d.PurposeID,    
lPurpose.Name,    
d.[Applied],    
d.[Comment],    
d.[DrawFundingId],    
d.[CreatedBy],    
d.[CreatedDate],    
d.[UpdatedBy],    
d.[UpdatedDate],    
(CASE WHEN (lPurpose.Name = 'Paydown' and d.GeneratedBy = 747 and d.Applied <> 1) then 'True' ELse 'False' END) as [Projected],    
d.GeneratedBy,    
Lgb.name as GeneratedByBI    
    
,d.Issaved    
,d.DealFundingRowno    
,d.DeadLineDate    
,d.LegalDeal_DealFundingID    
,d.EquityAmount    
,d.RemainingFFCommitment    
,d.RemainingEquityCommitment    
,d.SubPurposeType    
,d.DealFundingAutoID    
,d.RequiredEquity    
,d.AdditionalEquity    
,d.AdjustmentType    
,lAdjustmentType.name as AdjustmentTypeBI    
  
,(CASE WHEN ISNULL(WF_isParticipate,0) = 0 and deal.Status <> 325 and d.Applied = 1 THEN 'Completed' 
WHEN ISNULL(WF_isParticipate,0) = 0 and deal.Status <> 325 and d.Applied = 0 THEN 'Projected' ELSE
(case when tblWF.WF_CurrentStatus is null then null else tblWF.WF_CurrentStatusDisplayName end) 
END)as WF_CurrentStatusDisplayName   
,isnull(deal.WatchlistStatus,'')  
FROM CRE.DealFunding d    
inner join cre.Deal deal on d.DealID = deal.DealID    
LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50    
LEFT Join Core.Lookup lAdjustmentType on d.AdjustmentType=lAdjustmentType.LookupID     
left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = d.GeneratedBy     
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
   --WHERE td.TaskId in (Select dealfundingid from cre.dealfunding where dealid = ''+convert(varchar(MAX),@DealID)+'')     
  )a    
  where rno = 1    
   )tblWF on tblWF.TaskId = d.dealfundingid    
where deal.isdeleted <> 1    
    
SET @RowCount = @@ROWCOUNT    
    
--END    
    
    
    
    
    
UPDATE [DW].BatchDetail    
SET    
BIEndTime = GETDATE(),    
BIRecordCount = @RowCount    
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealFundingSchduleBI'    
    
Print(char(9) +'usp_MergeDealFundingSchdule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));    
    
    
END
GO
