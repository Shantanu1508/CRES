

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
		   ,GeneratedByBI )
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

