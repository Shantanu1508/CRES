CREATE VIEW dbo.vw_PIKScheduleDataTape
AS
Select  n.CRENoteID,acc.name as NoteName,d.CREDealID,d.dealname 
,e.EffectiveStartDate as EffectiveDate  
,pik.[EndDate] as EndDate 
,accsource.Name as [SourceAccount]  
,accDest.Name as [TargetAccount]  
,pik.[AdditionalIntRate]  
,pik.[AdditionalSpread]  
,pik.[IndexFloor]  
,pik.[IntCompoundingRate]  
,pik.[IntCompoundingSpread]  
,pik.[StartDate]  
,pik.[IntCapAmt]  
,pik.[PurBal]  
,pik.[AccCapBal] 
,LPIKReasonCode.name as PIKReasonCode
,pik.PIKComments  
,LPIKIntCalcMethodID.name as PIKIntCalcMethodID
,pik.PeriodicRateCapAmount 
,pik.PeriodicRateCapPercent
,LPIKSetUp.name as PIKSetUp
,pik.PIKPercentage as PIKPercentage
, pik.PIKCurrentPayRate as PIKCurrentPayRate
,lPIKSeparateCompounding.Name AS PIKSeparateCompounding
from [CORE].PikSchedule pik  
left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID  
left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID  
INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID  
LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID  
LEFT JOIN [CORE].[Lookup] LPIKSetUp ON LPIKSetUp.LookupID = pik.PIKSetUp  
LEFT JOIN [CORE].[Lookup] lPIKSeparateCompounding ON pik.PIKSeparateCompounding=lPIKSeparateCompounding.LookupID 
INNER JOIN   
(     
	Select   
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PikSchedule') 
	and acc.IsDeleted = 0  
	GROUP BY n.Account_AccountID,EventTypeID  
) sEvent  
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CRE].[Deal] d ON d.dealid = n.dealid
where ISNULL(e.StatusID,1) = 1  and acc.IsDeleted <> 1