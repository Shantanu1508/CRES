
Select *
,'Update [CORE].RateSpreadSchedule set Date = '''+Convert(nvarchar(256),Date,101 )+''' Where RateSpreadScheduleID = '''+ CAST(RateSpreadScheduleID as nvarchar(256))+''' ' as [Query_Back]
,'Update [CORE].Event set EffectiveStartDate = '''+Convert(nvarchar(256),EffectiveDate,101 )+''' Where EventID = '''+ CAST(EventID as nvarchar(256))+''' ' as [Query_Back]


,'Update [CORE].RateSpreadSchedule set Date = '''+Convert(nvarchar(256),TargetDate,101 )+''' Where RateSpreadScheduleID = '''+ CAST(RateSpreadScheduleID as nvarchar(256))+''' ' as [Query]
,'Update [CORE].Event set EffectiveStartDate = '''+Convert(nvarchar(256),TargetDate,101 )+''' Where EventID = '''+ CAST(EventID as nvarchar(256))+''' ' as [Query]

from(


Select RateSpreadScheduleID,EventID,
DealName	
,CREDealID	
,CRENoteID	
,InitialInterestAccrualEndDate
,EffectiveDate	
,Date	
,ValueTypeText	
,IndexNameText	
,DeterminationDateHolidayListText	
,Determinationdatereferencedayofthemonth
--,datefromparts(YEAR(EffectiveDate), MONTH(EffectiveDate), DAY(DATEADD(day,1,InitialInterestAccrualEndDate)) ) as TargetDate
,DATEADD(day,(Day(InitialInterestAccrualEndDate) + 1) - 1 ,DATEADD(month,MONTH(EffectiveDate) - 1 ,DATEADD(year,YEAR(EffectiveDate) - 1 ,DATEFROMPARTS(0001, 1, 1)))) as TargetDate
,(CASE WHEN DAY(InitialInterestAccrualEndDate) + 1 = Determinationdatereferencedayofthemonth THEN 'TRUE' ELSE 'FALSE' END) as Check1
,(CASE WHEN EffectiveDate = DATEADD(day,(Day(InitialInterestAccrualEndDate) + 1) - 1 ,DATEADD(month,MONTH(EffectiveDate) - 1 ,DATEADD(year,YEAR(EffectiveDate) - 1 ,DATEFROMPARTS(0001, 1, 1))))  THEN 'TRUE' ELSE 'FALSE' END) as Check2

--,rno

from (
	Select --n.noteid, rs.[EventId] , 
	RateSpreadScheduleID,e.EventID,
	d.DealName
	,d.CREDealID
	,n.CRENoteID
	,e.EffectiveStartDate as EffectiveDate
	,rs.[Date] 
	,LValueTypeID.Name as ValueTypeText 
	,lindex.name as IndexNameText
	,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayListText
	,rOW_NUMBER() OVER (Partition BY d.dealname,d.credealid,n.crenoteid,e.EffectiveStartDate Order by d.dealname,d.credealid,n.crenoteid,e.EffectiveStartDate,rs.date asc) rno
	,n.InitialInterestAccrualEndDate
	,n.Determinationdatereferencedayofthemonth
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
	INNER JOIN CRE.Deal d on d.dealid =n.dealid
	where acc.IsDeleted = 0 and e.statusid = 1
	
	and [ValueTypeID] in ( 778)  ---Index Name/Rate/Spread  ,150,151
	and rs.date < e.EffectiveStartDate 
	and YEAR(rs.date) = YEAR(e.EffectiveStartDate)
	and MONTH(rs.date) = MONTH(e.EffectiveStartDate ) 

	--and n.crenoteid in (
	--'19368',
	--'19369',
	--'15750',
	--'16938',
	--'17113',
	--'17175',
	--'17432',
	--'17499',
	--'11629',
	--'11906',
	--'11907',
	--'12014',
	--'12016',
	--'12017',
	--'12018',
	--'12020',
	--'12021',
	--'12027',
	--'13471',
	--'13473',
	--'13474',
	--'13476',
	--'13477'
	--)
)a

)z
order by z.crenoteid --a.dealname,a.crenoteid,a.EffectiveDate,a.[Date]



