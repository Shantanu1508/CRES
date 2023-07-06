
--[dbo].[usp_GetFeeCouponStripReceivableDataByNoteIdForCalc]  'becafd7d-8efc-4ff8-b2a0-408f4c9a8989', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE PROCEDURE [dbo].[usp_GetFeeCouponStripReceivableDataByNoteIdForCalc]
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	@AnalysisID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
     	
   
Select 
n.NoteID
,acc.AccountID
,fr.[Date]
,fr.Value
,eve.EffectiveStartDate AS EffectiveDate
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,l1.Name as TransactionName
,LEventTypeID.Name as EventTypeText
,fr.[EventID]
,fr.[CreatedBy]
,fr.[CreatedDate]
,fr.[UpdatedBy]
,fr.[UpdatedDate]
,nSource.crenoteid as SourceNoteId
,fr.StrippedAmount
,LRuleTypeID.FeeTypeNameText+' Strip' RuleType 
,fr.FeeName
,tblFee.IncludedLevelYield as InclInLevelYield

from [CORE].[FeeCouponStripReceivable] fr
INNER JOIN [CORE].[Event] eve ON eve.EventID = fr.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
left JOIN [CRE].[FeeSchedulesConfig] LRuleTypeID ON LRuleTypeID.FeeTypeNameID = fr.RuleTypeID
left JOIN Core.[Lookup] l1 ON LRuleTypeID.FeeNameTransID = l1.LookupID
left JOIN [CRE].[Note] nSource ON nSource.noteid =fr.SourceNoteId
Outer Apply(
	Select top 1 pafs.IncludedLevelYield from [CORE].PrepayAndAdditionalFeeSchedule pafs
	INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId
	LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
	INNER JOIN (					
		Select (Select AccountID from [CORE].[Account] ac where ac.AccountID = nn.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] nn ON nn.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = nn.Account_AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')
		and ISNULL(eve.StatusID,1) = 1
		and nn.NoteID = n.NoteID  and acc.IsDeleted = 0
		GROUP BY nn.Account_AccountID,EventTypeID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	where ISNULL(e.StatusID,1) = 1
	and pafs.FeeName = fr.FeeName and pafs.StartDate = fr.Date
)tblFee

where n.NoteID = @NoteId  and acc.IsDeleted = 0
AND fr.AnalysisID = @AnalysisID
ORDER BY fr.UpdatedDate DESC



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED



--select e.EffectiveStartDate,pafs.StartDate,pafs.EndDate,pafs.IncludedLevelYield,pafs.FeeName
--from [CORE].PrepayAndAdditionalFeeSchedule pafs
--INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId
--LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
--LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature
--inner join core.account acc on acc.accountid = e.accountid 
--inner join cre.note n on n.account_accountid = acc.accountid 
--where ISNULL(e.StatusID,1) = 1
--and n.crenoteid = '10191'


END

