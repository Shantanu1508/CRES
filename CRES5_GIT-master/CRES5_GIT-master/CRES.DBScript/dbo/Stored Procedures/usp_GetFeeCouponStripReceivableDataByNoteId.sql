
CREATE PROCEDURE [dbo].[usp_GetFeeCouponStripReceivableDataByNoteId]  --'fa4eda51-8fe2-41a2-bad5-1070b5eb8708', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B','baab7772-491b-470b-82f9-bf9fd18ce217',1,1,null
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

from [CORE].[FeeCouponStripReceivable] fr
INNER JOIN [CORE].[Event] eve ON eve.EventID = fr.EventId
INNER JOIN(						
	Select 
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID 
	from [CORE].[Event] eve1
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve1.AccountID
	INNER JOIN [CORE].[Account] acc1 ON acc1.AccountID = n.Account_AccountID
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FeeCouponStripReceivable')
	and n.NoteID = @NoteId  and acc1.IsDeleted = 0
	GROUP BY n.Account_AccountID,EventTypeID
) sEvent
ON sEvent.AccountID = eve.AccountID and eve.EffectiveStartDate = sEvent.EffectiveStartDate  and eve.EventTypeID = sEvent.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
left JOIN [CRE].[FeeSchedulesConfig] LRuleTypeID ON LRuleTypeID.FeeTypeNameID = fr.RuleTypeID
left JOIN Core.[Lookup] l1 ON LRuleTypeID.FeeNameTransID = l1.LookupID
left JOIN [CRE].[Note] nSource ON nSource.noteid =fr.SourceNoteId
where n.NoteID = @NoteId  and acc.IsDeleted = 0
AND fr.AnalysisID = @AnalysisID
ORDER BY fr.UpdatedDate DESC



SET @TotalCount = (SELECT @@Rowcount);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

