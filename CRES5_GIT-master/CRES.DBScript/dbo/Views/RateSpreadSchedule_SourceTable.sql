CREATE view [dbo].[RateSpreadSchedule_SourceTable]
as 
Select  d.DealName,d.CREDealID as DealID,n.CRENoteID as NoteID,acc.name as NoteName
,e.EffectiveStartDate as EffectiveDate
,rs.[Date]  
,LValueTypeID.Name as ValueType  
,rs.[Value]  
,LIntCalcMethodID.Name as CalcMethod 
,rs.RateOrSpreadToBeStripped as RateOrSpreadToBeStripped  
,lindex.name as IndexName
,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayList
from [CORE].RateSpreadSchedule rs  
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList				 
INNER JOIN   
   (  
        
    Select   
     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
     and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
     --and n.NoteID = @NoteID  
	 and acc.IsDeleted = 0  
     GROUP BY n.Account_AccountID,EventTypeID  
  
   ) sEvent  
  
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
Inner JOIN CRE.Deal d on d.dealid = n.dealid
WHERE acc.IsDeleted = 0