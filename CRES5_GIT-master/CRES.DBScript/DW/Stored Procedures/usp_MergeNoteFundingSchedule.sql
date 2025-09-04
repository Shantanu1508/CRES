

CREATE PROCEDURE [DW].[usp_MergeNoteFundingSchedule]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'NoteFundingScheduleBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteFundingScheduleBI'

DECLARE @RowCount int = 0

IF EXISTS(Select Noteid from [dw].[L_NoteBI])
BEGIN

--truncate table [DW].[NoteFundingScheduleBI]

Delete from [DW].[NoteFundingScheduleBI] where [CRENoteID] in (Select [CRENoteID] from [dw].[L_NoteBI])

INSERT INTO [DW].[NoteFundingScheduleBI]
           ([CRENoteID]
           ,[Date]
           ,[WireConfirm]
           ,[PurposeID]
           ,[PurposeBI]
           ,[Amount]
           ,[DrawFundingID]
           ,[Comments]
           ,CreatedBy
           ,CreatedDate
           ,UpdatedBy
           ,UpdatedDate
		   ,[Projected]
		   ,GeneratedBy
		   ,GeneratedByBI
		   ,AdjustmentType 
		   ,AdjustmentTypeBI
		   ,WF_CurrentStatusDisplayName)
Select  
n.crenoteid as [NoteID]
,fs.[Date] as [TransactionDate]
,fs.Applied as [WireConfirm]
,fs.PurposeID as [PurposeID]
,LPurposeID.Name as [PurposeBI]
,fs.Value as [Amount]
,fs.DrawFundingId as [DrawFundingID]
,fs.Comments as [Comments]
,fs.[CreatedBy] as [AuditAddUserId]
,fs.[CreatedDate] as [AuditAddDate]
,fs.[UpdatedBy] as [AuditUpdateUserId]
,fs.[UpdatedDate] as [AuditUpdateDate]
,(CASE WHEN (LPurposeID.Name = 'Paydown' and fs.GeneratedBy = 747 and fs.Applied <> 1) then 'True' ELse 'False' END) as [Projected]
,fs.GeneratedBy
,Lgb.name as GeneratedByBI

,fs.AdjustmentType
,lAdjustmentType.name as AdjustmentTypeBI

,(CASE WHEN ISNULL(WF_isParticipate,0) = 0  and fs.Applied = 1 THEN 'Completed' 
WHEN ISNULL(WF_isParticipate,0) = 0  and fs.Applied = 0 THEN 'Projected' ELSE
(case when tblWF.WF_CurrentStatus is null then null else tblWF.WF_CurrentStatusDisplayName end) 
END)as WF_CurrentStatusDisplayName 

from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = ns.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] ns ON ns.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = ns.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					--and ns.NoteID = @NoteId  
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
left JOIN [CORE].[Lookup] Lgb ON Lgb.LookupID = fs.GeneratedBy 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT Join Core.Lookup lAdjustmentType on fs.AdjustmentType=lAdjustmentType.LookupID 
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
   )tblWF on tblWF.TaskId = fs.dealfundingid


where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
and  n.noteid in (Select noteid from [dw].[L_NoteBI])

SET @RowCount = @@ROWCOUNT

END




UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteFundingScheduleBI'

Print(char(9) +'usp_MergeNoteFundingSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

