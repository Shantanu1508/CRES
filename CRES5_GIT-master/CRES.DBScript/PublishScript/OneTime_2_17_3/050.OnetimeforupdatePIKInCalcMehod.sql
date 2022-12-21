
GO
PRINT('Update PIK Calc method to Actual/360 for all pik loans')
GO
Update [CORE].PikSchedule set PIKIntCalcMethodID = 178 Where PikScheduleID in (
	Select PikScheduleID
	from [CORE].PikSchedule pik    
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where acc.IsDeleted = 0	
)
 
