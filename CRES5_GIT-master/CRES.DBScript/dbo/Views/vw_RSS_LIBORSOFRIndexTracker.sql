CREATE VIEW dbo.[vw_RSS_LIBORSOFRIndexTracker]
AS
Select DealName
,CREDealID as DealID
,z.CRENoteID as NoteID
,z.NoteName
,ActualPayoffDate
,DeterminationDateHolidayList
,[1M LIBOR]
,[1M USD SOFR]
,CurrentSpread
from (					
					
	Select d.DealName,d.CREDealID,n.NoteID,acc.name as NoteName,n.CRENoteID,n.ActualPayoffDate,lindex.name as IndexName,rs.[Date]	, LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayList
	,tblCurrSpread.Value as CurrentSpread
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
		--and n.creNoteID = '2230'  			
		and acc.IsDeleted = 0  			
		GROUP BY n.Account_AccountID,EventTypeID    			
	) sEvent  				
  					
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  				
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID				
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID				
	Inner join cre.deal d on d.dealid = n.dealid
	Left Join(    
		Select noteid,Date,ValueType,Value from(    
		Select  noteid,Date,ValueType,Value ,ROW_NUMBER() Over(Partition by noteid order by noteid,date desc) rno    
		from [RateSpreadSchedule] where ScheduleText = 'Latest Schedule' and ValueType = 'Spread' and [Date] <= Cast(getdate() as Date)    
		)a    
		where rno = 1    
	)tblCurrSpread on tblCurrSpread.NoteID = n.creNoteID 
	where e.StatusID = 1 and acc.IsDeleted <> 1
	and lindex.name is not null				
					
)a					
PIVOT(					
	MAX(Date)  For IndexName in ([1M LIBOR],[1M USD SOFR])				
)z	

			
