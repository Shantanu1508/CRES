CREATE VIEW dbo.vw_RateSpreadScedule_Spread_EffDate_IndividualRecord  
AS  
  
Select Distinct NoteID,DealName,CREDealID,CRENoteID,EffectiveDate,ActualData_BelongEffDate as [Date],ValueTypeText,IndexNameText  
From(  
 Select Distinct r1.NoteID  
 ,r1.CREDealID  
 ,r1.DealName  
 ,r1.CRENoteID  
 ,r1.EffectiveDate  
 ,r1.[Date]  
 ,z.Previous_Date  
 ,z.Previous_EffectiveDate  
 ,r1.ValueTypeText  
 ,r1.IndexNameText  
 ,(CASE WHEN z.Previous_Date is null THEN r1.[Date] ELSE NULL END) ActualData_BelongEffDate  
  
 FROM(  
  Select n.noteid,   
  RateSpreadScheduleID  
  ,e.EventID,  
  d.DealName  
  ,d.CREDealID  
  ,n.CRENoteID  
  ,e.EffectiveStartDate as EffectiveDate  
  ,rs.[Date]   
  ,LValueTypeID.Name as ValueTypeText   
  ,lindex.name as IndexNameText   
  from [CORE].RateSpreadSchedule rs    
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
  LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID    
  LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID    
  LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
  LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  INNER JOIN CRE.Deal d on d.dealid =n.dealid  
  where acc.IsDeleted <> 1 and e.statusid = 1   
  and [ValueTypeID] in (151)  --Index Name  
  
 )r1  
 Outer Apply(  
   Select Distinct r2.NoteID  
   ,MAX(r2.EffectiveDate) as Previous_EffectiveDate  
   ,r2.[Date] as Previous_Date  
   ,r2.ValueTypeText  
   ,r2.IndexNameText  
   FROM(  
    Select n.noteid   
    ,RateSpreadScheduleID  
    ,e.EventID,  
    d.DealName  
    ,d.CREDealID  
    ,n.CRENoteID  
    ,e.EffectiveStartDate as EffectiveDate  
    ,rs.[Date]   
    ,LValueTypeID.Name as ValueTypeText   
    ,lindex.name as IndexNameText   
    from [CORE].RateSpreadSchedule rs    
    INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
    LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID    
    LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID    
    LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
    LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList    
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
    INNER JOIN CRE.Deal d on d.dealid =n.dealid  
    where acc.IsDeleted <> 1 and e.statusid = 1   
    and [ValueTypeID] in (151)  --Index Name  
  
   )r2  
  
   where r2.NoteID = r1.NoteID   
   and r2.ValueTypeText = r1.ValueTypeText   
   and r2.IndexNameText = r1.IndexNameText   
   and r2.EffectiveDate < r1.EffectiveDate  
   and r2.Date = r1.Date  
  
   Group by NoteID,CRENoteID,ValueTypeText,IndexNameText,[Date]  
    
 )z  
  
)y  
  
---where crenoteid in ('11629', '11963')  
--Order by y.CRENoteID,y.EffectiveDate  