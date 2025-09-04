
--UPDATE [CORE].RateSpreadSchedule SET [CORE].RateSpreadSchedule.IndexNameID = z.IndexNameID_New,[CORE].RateSpreadSchedule.DeterminationDateHolidayList = z.DeterminationDateHolidayList_New
--From(

--Select 
--n.crenoteid,
--[RateSpreadScheduleID]
--,rs.[EventId]  
--,e.EffectiveStartDate as EffectiveDate
--,rs.IndexNameID
--,lindex.name as IndexNameText
--,rs.DeterminationDateHolidayList
--,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayListText
--,913 as IndexNameID_New
--,411 as DeterminationDateHolidayList_New
--from [CORE].RateSpreadSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
--LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
--LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
--LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
--LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList				 
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

--where e.StatusID = 1 and acc.IsDeleted = 0 and lindex.name = 'N/A'
--and n.creNoteID in (
--		'8994',
--		'10758',
--		'10760',
--		'10761',
--		'9265',
--		'11346',
--		'11390',
--		'11391',
--		'11825',
--		'11569',
--		'14212',
--		'11736',
--		'12224',
--		'13832',
--		'12560',
--		'12605',
--		'13684',
--		'13178',
--		'16595',
--		'17008',
--		'17787',
--		'24040'
--		)

-----order by n.crenoteid,e.EffectiveStartDate,rs.[Date]  

--)z
--Where [CORE].RateSpreadSchedule.RateSpreadScheduleID = z.RateSpreadScheduleID

--go



--go

--INSERT INTO [CORE].RateSpreadSchedule(EventId,Date,ValueTypeID,IndexNameID,DeterminationDateHolidayList)
--Select EventID, EffectiveStartDate As 'Date',LINdex.LookupID as ValueTypeID, LTreasury.LookupID as IndexNameID,Holi.HolidayMasterID as DeterminationDateHolidayList 
--FROM(
--	Select Distinct N.CreNoteID,Evr.EventID,EvR.EffectiveStartDate 
--	from Cre.Note N
--	INNER JOIN Core.Account accN ON accN.AccountID = N.Account_AccountID
--	INNER JOIN Core.Event EvR ON EvR.AccountID = accN.AccountID
--	INNER JOIN Core.Lookup LEvR ON LEvr.LookupID = EvR.EventTypeID  
--	WHERE accN.IsDeleted <> 1
--	AND LEvr.[Name]='RateSpreadSchedule' 
--	AND N.crenoteid IN ('16595')
--) TRes,
--(Select Top 1 LookupID From Core.LookUp Where [Name]='Index Name') LIndex,
--(Select Top 1 LookupID From Core.LookUp Where [Name]='10 Year Treasury') LTreasury,
--(Select HolidayMasterID from app.HoliDaysMaster Where CalendarName='US') Holi


--go

--INSERT INTO [CORE].RateSpreadSchedule(EventId,Date,ValueTypeID,IndexNameID,DeterminationDateHolidayList)
--Select EventID, EffectiveStartDate As 'Date',LINdex.LookupID as ValueTypeID, LTreasury.LookupID as IndexNameID,Holi.HolidayMasterID as DeterminationDateHolidayList 
--FROM(
--	Select Distinct N.CreNoteID,Evr.EventID,EvR.EffectiveStartDate 
--	from Cre.Note N
--	INNER JOIN Core.Account accN ON accN.AccountID = N.Account_AccountID
--	INNER JOIN Core.Event EvR ON EvR.AccountID = accN.AccountID
--	INNER JOIN Core.Lookup LEvR ON LEvr.LookupID = EvR.EventTypeID  
--	WHERE accN.IsDeleted <> 1
--	AND LEvr.[Name]='RateSpreadSchedule' 
--	AND N.crenoteid IN ('24040')
--) TRes,
--(Select Top 1 LookupID From Core.LookUp Where [Name]='Index Name') LIndex,
--(Select Top 1 LookupID From Core.LookUp Where [Name]='5 Year Treasury') LTreasury,
--(Select HolidayMasterID from app.HoliDaysMaster Where CalendarName='US') Holi