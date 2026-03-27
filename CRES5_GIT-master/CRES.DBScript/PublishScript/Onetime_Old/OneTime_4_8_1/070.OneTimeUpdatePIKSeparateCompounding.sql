
Update [CORE].PikSchedule set [CORE].PikSchedule.PIKSeparateCompounding = z.PIKSeparateCompounding
From(
	Select pik.PIKScheduleID,n.CRENoteID,n.NoteID,n.PIKSeparateCompounding
	from [CORE].PikSchedule pik    
	left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID    
	left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID    
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId    
	LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID    
	LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID    
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
	left JOin core.lookup lPIKSeparateCompounding on lPIKSeparateCompounding.lookupid =n.PIKSeparateCompounding  

	where ISNULL(e.StatusID,1) = 1 
	and acc.IsDeleted <> 1
)z
where [CORE].PikSchedule.PIKScheduleID = z.PIKScheduleID