--Update [CORE].RateSpreadSchedule set [CORE].RateSpreadSchedule.date = a.closingdate
--From(
--	Select rs.RateSpreadScheduleID,n.noteid,n.crenoteid,n.closingdate,e.effectivestartdate,rs.date as StartDate,LValueTypeID.name as ValueType
--	from [CORE].RateSpreadSchedule rs  
--	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
--	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
--	LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--	where e.StatusID = 1 and acc.isdeleted <> 1
--	and rs.date < n.closingdate
--	---order by n.crenoteid,n.closingdate,e.effectivestartdate,rs.date
--)a
--where [CORE].RateSpreadSchedule.RateSpreadScheduleID = a.RateSpreadScheduleID






--Select Distinct 'RateSpreadSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].RateSpreadSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
--LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
--LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
--	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 


--UNION ALL

--Select Distinct 'DefaultSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].DefaultSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'DefaultSchedule')  
--	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 



--UNION ALL

--Select Distinct 'FinancingFeeSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].FinancingFeeSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FinancingFeeSchedule')  
--	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 


--UNION ALL

--Select Distinct 'FinancingSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].FinancingSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FinancingSchedule')  
--	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 

--UNION ALL

--Select Distinct 'FundingSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].FundingSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
--	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 

----UNION ALL

----Select Distinct 'PIKSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
----from [CORE].PIKSchedule rs  
----INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
----INNER JOIN   
----(         
----	Select   
----	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
----	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
----	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
----	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
----	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKSchedule')  
----	and ISNULL(eve.StatusID,1) = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
----	--and n.NoteID = @NoteID  
----	and acc.IsDeleted = 0  
----	GROUP BY n.Account_AccountID,EventTypeID  
----) sEvent   
----ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
----INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
----INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
----where n.closingdate <> e.EffectiveStartDate 

--UNION ALL

--Select Distinct 'PrepayAndAdditionalFeeSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].PrepayAndAdditionalFeeSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')  
--	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 

--UNION ALL

--Select Distinct 'PIKScheduleDetail' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].PIKScheduleDetail rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKScheduleDetail')  
--	and ISNULL(eve.StatusID,1) = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 

--UNION ALL

--Select Distinct 'AmortSchedule' as [Type],e.eventid,n.crenoteid,n.closingdate,e.EffectiveStartDate  
--from [CORE].AmortSchedule rs  
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
--INNER JOIN   
--(         
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'AmortSchedule')  
--	and ISNULL(eve.StatusID,1) = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
--	--and n.NoteID = @NoteID  
--	and acc.IsDeleted = 0  
--	GROUP BY n.Account_AccountID,EventTypeID  
--) sEvent   
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--where n.closingdate <> e.EffectiveStartDate 


