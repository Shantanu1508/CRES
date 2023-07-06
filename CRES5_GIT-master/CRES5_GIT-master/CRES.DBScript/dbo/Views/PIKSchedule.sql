CREATE View [dbo].[PIKSchedule]
As

select Crenoteid, P.* from [Core].[PIKSchedule] P
Inner join core.Event e on P.eventid = e.eventid
inner join cre.note n on n.account_Accountid = e.accountid
where crenoteid <> '10729x'