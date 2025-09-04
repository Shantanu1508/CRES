

--INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID)

Select EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID
From(
Select Distinct n.noteid,n.crenoteid,e.EffectiveStartDate,
rs.eventid as EventId
,n.ClosingDate as Date
,778 as ValueTypeID   ---Index Name
,null as Value
,null as IntCalcMethodID
,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
,getdate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,getdate() as UpdatedDate
,null as RateOrSpreadToBeStripped
,n.IndexNameID
from [CORE].RateSpreadSchedule rs  
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  

INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where e.StatusID = 1
and n.noteid in (
	Select n.noteid
	from cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1 and n.indexnameid is not null ---and n.indexnameid <> 244
)

)a
order by a.crenoteid,a.EffectiveStartDate




go



--16023
--16022
--6734


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)

Select n.closingdate as EffectiveStartDate
, acc.AccountID
, getdate() as Date
,14 as EventTypeID
,1 as StatusID
,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
,getdate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,getdate() as UpdatedDate
from cre.note n
inner join core.account acc on acc.accountid = n.account_accountid
where acc.isdeleted <> 1 and n.indexnameid is not null 

and n.crenoteid not in (
	Select Distinct n.crenoteid
	from [CORE].RateSpreadSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
	LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = 1
	and n.noteid in (
		Select n.noteid
		from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid
		where acc.isdeleted <> 1 and n.indexnameid is not null --and n.indexnameid <> 244
	)  
)


INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID)

Select EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID
From(
Select Distinct n.noteid,n.crenoteid,n.ClosingDate as EffectiveStartDate
,(SELECT TOP 1
	EventId
	FROM CORE.[event] e
	WHERE e.[EffectiveStartDate] = CONVERT(date, n.closingdate, 101)
	AND e.[EventTypeID] = 14
	AND e.AccountID = n.Account_AccountID and e.StatusID=1) as EventId
,n.ClosingDate as Date
,778 as ValueTypeID   ---Index Name
,null as Value
,null as IntCalcMethodID
,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
,getdate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,getdate() as UpdatedDate
,null as RateOrSpreadToBeStripped
,n.IndexNameID
from [CRE].[Note] n 
where n.crenoteid in (
	Select n.crenoteid
	from cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1 and n.indexnameid is not null 

	and n.crenoteid not in (
		Select Distinct n.crenoteid
		from [CORE].RateSpreadSchedule rs  
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
		LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
		LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1
		and n.noteid in (
			Select n.noteid
			from cre.note n
			inner join core.account acc on acc.accountid = n.account_accountid
			where acc.isdeleted <> 1 and n.indexnameid is not null --and n.indexnameid <> 244
		)  
	)
)

)a
order by a.crenoteid,a.EffectiveStartDate



----==========================================

---For indexnameid is null

INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID)

Select EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID
From(
Select Distinct n.noteid,n.crenoteid,e.EffectiveStartDate,
rs.eventid as EventId
,n.ClosingDate as Date
,778 as ValueTypeID   ---Index Name
,null as Value
,null as IntCalcMethodID
,'B0E6697B-3534-4C09-BE0A-04473401AB93' CreatedBy
,getdate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,getdate() as UpdatedDate
,null as RateOrSpreadToBeStripped
,245 as IndexNameID
from [CORE].RateSpreadSchedule rs  
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  

INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where e.StatusID = 1
and n.noteid in (
	Select n.noteid
	from cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1 and n.indexnameid is null ---and n.indexnameid <> 244
	----and n.crenoteid <> '7411'
)

)a
order by a.crenoteid,a.EffectiveStartDate


