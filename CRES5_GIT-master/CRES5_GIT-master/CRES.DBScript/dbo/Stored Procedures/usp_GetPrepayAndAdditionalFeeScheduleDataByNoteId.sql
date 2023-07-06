


CREATE PROCEDURE [dbo].[usp_GetPrepayAndAdditionalFeeScheduleDataByNoteId] --'432E2FDC-1C2D-4C95-BE79-1EC45AD45A2E', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	
	@PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   

Select 
@totalCount =  COUNT(n.NoteID)   from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = pafs.ValueTypeID
where n.NoteID = @NoteId and acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)


----------------------    	
Select 
n.NoteID
,acc.AccountID
,eve.[Date]
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText
,pafs.PrepayAndAdditionalFeeScheduleID
,pafs.[EventID]
,pafs.[StartDate]
,isnull(pafs.Value,0) as Value
,pafs.ValueTypeID
--,LValueTypeID.Name as ValueTypeText
,LValueTypeID.FeeTypeNameText as ValueTypeText

,isnull(pafs.IncludedLevelYield,0) as IncludedLevelYield
,isnull(pafs.IncludedBasis,0) as IncludedBasis
--,pafs.IncludedLevelYield
--,pafs.IncludedBasis

,pafs.[CreatedBy]
,pafs.[CreatedDate]
,pafs.[UpdatedBy]
,pafs.[UpdatedDate]

,pafs.FeeName
,pafs.FeeAmountOverride
,pafs.BaseAmountOverride
,pafs.ApplyTrueUpFeature
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeatureText
,pafs.FeetobeStripped
,pafs.EndDate as [EndDate]

from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
--LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = pafs.ValueTypeID

LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature

where n.NoteID = @NoteId  and acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)

ORDER BY eve.EffectiveStartDate,pafs.[StartDate]  --pafs.UpdatedDate DESC
	--OFFSET @PgeIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY

 
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END

