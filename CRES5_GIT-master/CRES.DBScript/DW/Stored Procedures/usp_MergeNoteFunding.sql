

CREATE PROCEDURE [DW].[usp_MergeNoteFunding]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'NoteFundingBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteFundingBI'





truncate table [DW].[NoteFundingBI]

INSERT INTO [DW].[NoteFundingBI]
           ([NoteID]
           ,[TransactionDate]
           ,[WireConfirm]
           ,[PurposeID]
           ,[PurposeBI]
           ,[Amount]
           ,[DrawFundingID]
           ,[Comments]
           ,[AuditAddUserId]
           ,[AuditAddDate]
           ,[AuditUpdateUserId]
           ,[AuditUpdateDate])

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
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0




DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteFundingBI'

Print(char(9) +'usp_MergeNoteFunding - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

