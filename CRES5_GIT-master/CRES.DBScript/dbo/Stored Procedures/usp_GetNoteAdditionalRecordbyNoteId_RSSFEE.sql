--[dbo].[usp_GetNoteAdditionalRecordbyNoteId_RSSFEE] 'f20e270b-2f5e-4c1f-a055-ba7a9fa5ac88','b0e6697b-3534-4c09-be0a-04473401ab93'
CREATE PROCEDURE [dbo].[usp_GetNoteAdditionalRecordbyNoteId_RSSFEE]
(  
 @NoteID UNIQUEIDENTIFIER,  
 @UserID UNIQUEIDENTIFIER  
)  
AS  
  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  

  
Select  
ScheduleID ,  
EventId ,  
EffectiveDate ,  
Date ,  
EndDate ,  
ValueTypeID ,  
Value ,  
IntCalcMethodID ,  
IncludedLevelYield ,  
IncludedBasis ,  
MaxFeeAmt ,  
IndexTypeID ,  
CurrencyCode ,  
IsCapitalized ,  
SourceAccountID ,  
SourceAccountText ,  
TargetAccountID ,  
TargetAccountText ,  
AdditionalIntRate ,  
AdditionalSpread ,  
IndexFloor ,  
IntCompoundingRate ,  
IntCompoundingSpread ,  
StartDate ,  
IntCapAmt ,  
PurBal ,  
AccCapBal ,  
ValueTypeText ,  
IntCalcMethodText ,  
CurrencyCodeText ,  
IndexTypeText ,  
ModuleId ,  
FeeName,  
FeeAmountOverride,  
BaseAmountOverride,  
ApplyTrueUpFeature,  
ApplyTrueUpFeatureText,  
FeetobeStripped,  
PIKReasonCodeID,  
PIKReasonCodeText,  
PIKComments,
PIKIntCalcMethodID,
PIKIntCalcMethodIDText,
IndexNameID,
IndexNameText,
PeriodicRateCapAmount,
PeriodicRateCapPercent,
DeterminationDateHolidayList,
DeterminationDateHolidayListText,
PIKPercentage,
PIKCurrentPayRate,
PIKSetUp,
PIKSetUpText,
PIKSeparateCompounding,
PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,
ImpactCommitmentCalc

FROM  
(  
Select [RateSpreadScheduleID] as ScheduleID  
,rs.[EventId]  
,e.EffectiveStartDate as EffectiveDate
,rs.[Date]  
,NULL as[EndDate]  
,[ValueTypeID]  
,rs.[Value]  
,[IntCalcMethodID]  
,NULL as  [IncludedLevelYield]  
,NULL as [IncludedBasis]  
,NULL as [MaxFeeAmt]  
,NUll as [IndexTypeID]  
,NUll as [CurrencyCode]  
,NULL as  [IsCapitalized]  
,NUll as [SourceAccountID]  
,NUll as  [SourceAccountText]  
,NUll as [TargetAccountID]  
,NUll as  [TargetAccountText]  
,NUll as [AdditionalIntRate]  
,NUll as [AdditionalSpread]  
,NUll as [IndexFloor]  
,NUll as [IntCompoundingRate]  
,NUll as [IntCompoundingSpread]  
,NUll as [StartDate]  
,NUll as [IntCapAmt]  
,NUll as [PurBal]  
,NUll as [AccCapBal]  
,LValueTypeID.Name as ValueTypeText  
,LIntCalcMethodID.Name as IntCalcMethodText  
,NUll as [CurrencyCodeText]  
,NULL as IndexTypeText  
,e.EventTypeID as ModuleId  
,NULL as FeeName  
,NULL as FeeAmountOverride  
,NULL as BaseAmountOverride  
,NULL as ApplyTrueUpFeature  
,NULL as ApplyTrueUpFeatureText  
,rs.RateOrSpreadToBeStripped as FeetobeStripped  
  
,null as PIKReasonCodeID  
,null as PIKReasonCodeText  
,null as PIKComments  
,null as PIKIntCalcMethodID
,null as PIKIntCalcMethodIDText    
,rs.IndexNameID
,lindex.name as IndexNameText
,null as PeriodicRateCapAmount 
,null as PeriodicRateCapPercent

,rs.DeterminationDateHolidayList
,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayListText
,null as PIKSetUp
,null as PIKSetUpText
,null as PIKPercentage
,null as PIKCurrentPayRate
,null as PIKSeparateCompounding
,null as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
,null as ImpactCommitmentCalc

from [CORE].RateSpreadSchedule rs  
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList				 
--INNER JOIN   
--   (  
        
--    Select   
--     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
--     and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--     and n.NoteID = @NoteID  and acc.IsDeleted = 0  
--     GROUP BY n.Account_AccountID,EventTypeID  
  
--   ) sEvent  
  
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

where e.StatusID = 1-- (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
and n.NoteID = @NoteID  and acc.IsDeleted = 0
--and rs.[Date] >= e.EffectiveStartDate 
  


UNION  
  
  
Select [PrepayAndAdditionalFeeScheduleID] as ScheduleID  
,pafs.[EventId]  
,e.EffectiveStartDate as EffectiveDate  
,pafs.[StartDate] as [Date]  
,pafs.EndDate as [EndDate]  
,pafs.[ValueTypeID] as ValueTypeID   
,ISNULL(pafs.[Value],0) as Value   
,NULL as IntCalcMethodID  
,ISNULL(pafs.[IncludedLevelYield],0) as IncludedLevelYield
,pafs.[IncludedBasis]  
,NUll as [MaxFeeAmt]  
,NUll as [IndexTypeID]  
,NUll as [CurrencyCode]  
,NULL as  [IsCapitalized]  
,NUll as [SourceAccountID]  
,NUll as  [SourceAccountText]  
,NUll as [TargetAccountID]  
,NUll as  [TargetAccountText]  
,NUll as [AdditionalIntRate]  
,NUll as [AdditionalSpread]  
,NUll as [IndexFloor]  
,NUll as [IntCompoundingRate]  
,NUll as [IntCompoundingSpread]  
,NUll as [StartDate]  
,NUll as [IntCapAmt]  
,NUll as [PurBal]  
,NUll as [AccCapBal]  
  
--,LValueTypeID.Name as ValueTypeText  
,LValueTypeID.FeeTypeNameText as ValueTypeText  
  
,NULL as IntCalcMethodText  
,NUll as [CurrencyCodeText]  
,NULL as IndexTypeText  
,e.EventTypeID as ModuleId   
,pafs.FeeName  
,pafs.FeeAmountOverride  
,pafs.BaseAmountOverride  
,pafs.ApplyTrueUpFeature  
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeatureText  
,ISNULL(pafs.FeetobeStripped,0) as  FeetobeStripped   
,null as PIKReasonCodeID  
,null as PIKReasonCodeText  
,null as PIKComments  
,null as PIKIntCalcMethodID 
,null as PIKIntCalcMethodIDText  
,null as IndexNameID
,null as IndexNameText
,null as PeriodicRateCapAmount 
,null as PeriodicRateCapPercent
,null as DeterminationDateHolidayList
,null as DeterminationDateHolidayListText
,null as PIKSetUp
,null as PIKSetUpText
,null as PIKPercentage
,null as PIKCurrentPayRate
,null as PIKSeparateCompounding
,null as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
,null as ImpactCommitmentCalc

from [CORE].PrepayAndAdditionalFeeSchedule pafs  
INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId  
  
--LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = pafs.ValueTypeID  
LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID  
  
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature  
--INNER JOIN   
--   (  
        
--    Select   
--     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')  
--     and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--     and n.NoteID = @NoteID  and acc.IsDeleted = 0  
--     GROUP BY n.Account_AccountID,EventTypeID  
  
--   ) sEvent  
  
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where e.StatusID = 1
and n.NoteID = @NoteID  and acc.IsDeleted = 0  --(Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--and pafs.[StartDate] >= e.EffectiveStartDate


UNION  
  
  
Select   
[PikScheduleID] as ScheduleID  
,pik.[EventId]  
,e.EffectiveStartDate as EffectiveDate  
,NULL as [Date]  
,pik.[EndDate] as EndDate  
,NULL as  ValueTypeID  
,NULL as Value  
,NULL as IntCalcMethodID  
,NULL as [IncludedLevelYield]  
,NULL as [IncludedBasis]  
,NUll as [MaxFeeAmt]  
,NUll as [IndexTypeID]  
,NUll as [CurrencyCode]  
,NULL as [IsCapitalized]  
,pik.[SourceAccountID]  
,accsource.Name as [SourceAccountText]  
,pik.[TargetAccountID]  
,accDest.Name as [TargetAccountText]  
,pik.[AdditionalIntRate]  
,pik.[AdditionalSpread]  
,pik.[IndexFloor]  
,pik.[IntCompoundingRate]  
,pik.[IntCompoundingSpread]  
,pik.[StartDate]  
,pik.[IntCapAmt]  
,pik.[PurBal]  
,pik.[AccCapBal]  
,NULL as ValueTypeText  
,NULL as IntCalcMethodText  
,NUll as [CurrencyCodeText]  
,NULL as IndexTypeText  
,e.EventTypeID as ModuleId  
  
,NULL as FeeName  
,NULL as FeeAmountOverride  
,NULL as BaseAmountOverride  
,NULL as ApplyTrueUpFeature  
,NULL as ApplyTrueUpFeatureText  
,NULL as FeetobeStripped  
  
,pik.PIKReasonCodeID  
,LPIKReasonCode.name as PIKReasonCodeText  
,pik.PIKComments  
,pik.PIKIntCalcMethodID as PIKIntCalcMethodID  
,LPIKIntCalcMethodID.name as PIKIntCalcMethodIDText
,null as IndexNameID
,null as IndexNameText
,pik.PeriodicRateCapAmount 
,pik.PeriodicRateCapPercent
,null as DeterminationDateHolidayList
,null as DeterminationDateHolidayListText
,pik.PIKSetUp as PIKSetUp
,LPIKSetUp.name as PIKSetUpText
,pik.PIKPercentage as PIKPercentage
,pik.PIKCurrentPayRate as PIKCurrentPayRate
,ISNULL(pik.[PIKSeparateCompounding], 4) as PIKSeparateCompounding
,n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
,n.ImpactCommitmentCalc

from [CORE].PikSchedule pik  
left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID  
left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID  
INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID  
LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID  
LEFT JOIN [CORE].[Lookup] LPIKSetUp ON LPIKSetUp.LookupID = pik.PIKSetUp  
--INNER JOIN   
--   (  
        
--    Select   
--     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PikSchedule')  
--     and n.NoteID = @NoteID  and acc.IsDeleted = 0  
--     GROUP BY n.Account_AccountID,EventTypeID  
  
--   ) sEvent  
  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
WHERE ISNULL(e.StatusID, 1) = 1
and n.NoteID = @NoteID  and acc.IsDeleted = 0

)a  

 ORDER BY a.ModuleId,a.EffectiveDate,a.Date
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO