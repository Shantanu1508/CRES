
GO
Print('Update into RateSpreadSchedule')
GO
Update [CORE].RateSpreadSchedule set DeterminationDateHolidayList = z.DeterminationDateHolidayListID
From(
	Select RateSpreadScheduleID,EventId, Date, 817 ValueTypeID,DeterminationDateHolidayListID,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate
	from(
	Select Distinct n.crenoteid
	,rs.RateSpreadScheduleID
	,rs.[EventId]  
	,e.EffectiveStartDate  
	,rs.[Date]  
	,[ValueTypeID]  
	,rs.[Value]  
	,[IntCalcMethodID]   
	,LValueTypeID.Name as ValueTypeText  
	,LIntCalcMethodID.Name as IntCalcMethodText 
	,e.EventTypeID as ModuleId  
	,rs.RateOrSpreadToBeStripped
	,rs.IndexNameID
	,lindex.name as IndexNameText

	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as CreatedBy
	,getdate() as CreatedDate
	,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
	,getdate() as UpdatedDate

	,(CASE WHEN rs.IndexNameID = 245 THEN 412 WHEN rs.IndexNameID = 777 THEN 411 ELSE null END ) as DeterminationDateHolidayListID
	from [CORE].RateSpreadSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
	LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
	LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = 1  and acc.IsDeleted = 0

	and ValueTypeID = 778

	--and n.crenoteid = '15162'
	--and lindex.name like '%SOFR%'
	)a
 
 )z
 where [CORE].RateSpreadSchedule.RateSpreadScheduleID = z.RateSpreadScheduleID