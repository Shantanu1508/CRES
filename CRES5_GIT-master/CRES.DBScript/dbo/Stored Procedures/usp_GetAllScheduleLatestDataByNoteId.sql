
--[dbo].[usp_GetAllScheduleLatestDataByNoteId] '6504AE99-9AB5-49E5-B4C8-2B9A90994267', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null


CREATE PROCEDURE [dbo].[usp_GetAllScheduleLatestDataByNoteId] --'6504AE99-9AB5-49E5-B4C8-2B9A90994267', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	@AnalysisID UNIQUEIDENTIFIER,
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
 --declare @IndexNameID int =(select n.IndexNameID from cre.note n where n.NoteID = @NoteId )
 --  IF @IndexNameID is NULL or @IndexNameID=0
 --  Begin
	--set @IndexNameID=(SELECT LookupID FROM CORE.LOOKUP WHERE Name='1M LIBOR')
 --  End
  
     	
Select 
NoteID,
AccountID,
ScheduleID,
Date,
Value,
IndexValue,
Event_Date,
EffectiveDate,
EffectiveEndDate,
EventTypeID,
EventTypeText,
EventID,
PurposeID,
PurposeText,
ISNULL(Applied,0) Applied,
ISNULL(Issaved,0) Issaved,
DrawFundingId,
Comments,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate
,SourceNoteId
,StrippedAmount
,RuleType 
,FeeName
FROM
(

Select  
 fs.[Date]
,n.NoteID
,acc.AccountID
,fs.FundingScheduleID  as ScheduleID
,fs.Value
,0 IndexValue
,e.[Date] as Event_Date
,e.EffectiveStartDate AS EffectiveDate
,e.EffectiveEndDate
,e.EventTypeID
,LEventTypeID.Name as EventTypeText
,fs.[EventID]
,fs.PurposeID
,LPurposeID.Name PurposeText 
,fs.Applied
,fs.Issaved
,fs.DrawFundingId
,fs.Comments
,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy]
,fs.[UpdatedDate]
,null SourceNoteId
,null StrippedAmount
,null RuleType 
,null FeeName
from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					and n.NoteID = @NoteId  and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0


UNION


Select  
ls.[Date]
,n.NoteID
,acc.AccountID
,ls.AmortScheduleID as ScheduleID
,ls.Value
,0 IndexValue
,e.[Date] as Event_Date
,e.EffectiveStartDate AS EffectiveDate
,e.EffectiveEndDate
,e.EventTypeID
,LEventTypeID.Name as EventTypeText
,ls.[EventID]
,''PurposeID
,'' PurposeText
,null Applied
,null Issaved
,null DrawFundingId
,null Comments
,ls.[CreatedBy]
,ls.[CreatedDate]
,ls.[UpdatedBy]
,ls.[UpdatedDate]
,null SourceNoteId
,null StrippedAmount
,null RuleType 
,null FeeName
from [CORE].AmortSchedule ls
INNER JOIN [CORE].[Event] e on e.EventID = ls.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID,eve.StatusID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'AmortSchedule')
					and n.NoteID = @NoteId  and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0

UNION


Select  
ls.[Date]
,n.NoteID
,acc.AccountID
,ls.PIKScheduleDetailID as ScheduleID
,ls.Value
,0 IndexValue
,e.[Date] as Event_Date
,e.EffectiveStartDate AS EffectiveDate
,e.EffectiveEndDate
,e.EventTypeID
,LEventTypeID.Name as EventTypeText
,ls.[EventID]
,''PurposeID
,'' PurposeText
,null Applied
,null Issaved
,null DrawFundingId
,null Comments
,ls.[CreatedBy]
,ls.[CreatedDate]
,ls.[UpdatedBy]
,ls.[UpdatedDate]
,null SourceNoteId
,null StrippedAmount
,null RuleType 
,null FeeName
from [CORE].PIKScheduleDetail ls
INNER JOIN [CORE].[Event] e on e.EventID = ls.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKScheduleDetail')
					and n.NoteID = @NoteId  and acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where   acc.IsDeleted = 0


UNION


Select  
 ls.[Date]
,n.NoteID
,acc.AccountID
,ls.FeeCouponStripReceivableID as ScheduleID
,ls.Value
,0 IndexValue
,e.[Date] as Event_Date
,e.EffectiveStartDate AS EffectiveDate
,e.EffectiveEndDate
,e.EventTypeID
,LEventTypeID.Name as EventTypeText
,ls.[EventID]
,''PurposeID
,'' PurposeText
,null Applied
,null Issaved
,null DrawFundingId
,null Comments
,ls.[CreatedBy]
,ls.[CreatedDate]
,ls.[UpdatedBy]
,ls.[UpdatedDate]
,nSource.crenoteid as SourceNoteId
,ls.StrippedAmount
,LRuleTypeID.FeeTypeNameText+' '+ 'Strip' RuleType 
,ls.FeeName
from [CORE].FeeCouponStripReceivable ls
INNER JOIN [CORE].[Event] e on e.EventID = ls.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FeeCouponStripReceivable')
					and n.NoteID = @NoteId  and acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
left JOIN [CRE].[FeeSchedulesConfig] LRuleTypeID ON LRuleTypeID.FeeTypeNameID = ls.RuleTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
left JOIN [CRE].[Note] nSource ON nSource.noteid =ls.SourceNoteId
Where   acc.IsDeleted = 0
and ls.AnalysisID = @AnalysisID
)a
order by a.EventTypeID,a.Date

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

