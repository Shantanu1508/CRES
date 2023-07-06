


CREATE PROCEDURE [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] 

	@noteID uniqueidentifier
AS
BEGIN
SET NOCOUNT ON;
 
 IF OBJECT_ID('tempdb..#LocalTemp') IS NOT NULL   
DROP TABLE #LocalTemp  	
CREATE TABLE #LocalTemp  
(  
	[EffectiveStartDate] [datetime] NULL,
	[EventID] [uniqueidentifier],
	[AccountID] [uniqueidentifier],
	[EventTypeID] [int] NULL,
	[DifferenceDate] int NULL
)  
insert into #LocalTemp
(
[EffectiveStartDate],
[EventID],
[AccountID],
[EventTypeID]
--,[DifferenceDate]
)

select
eve.EffectiveStartDate,EventID,eve.AccountID,eve.EventTypeID --,*
from [CORE].[Event] eve
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
inner join
(select
eve.AccountID AccountID,EventTypeID 
from [CORE].[Event] eve
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where LEventTypeID.Name in ('Maturity','FundingSchedule','PIKScheduleDetail','LIBORSchedule','AmortSchedule','RateSpreadSchedule','PrepayAndAdditionalFeeSchedule','StrippingSchedule','FinancingSchedule','PIKSchedule','ServicingFeeSchedule','DefaultSchedule') -- (select Name from core.lookup where name like '%schedule%')
and acc.isdeleted=0
and (eve.StatusID is null or  eve.StatusID  in (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1))
--and eve.EffectiveStartDate <n.ClosingDate
group by eve.AccountID,EventTypeID
having count(EventTypeID)>0
) a on a.AccountID=n.account_accountID --and a.EventTypeID=eve.EventTypeID
where 
LEventTypeID.Name in ('Maturity','FundingSchedule','PIKScheduleDetail','LIBORSchedule','AmortSchedule','RateSpreadSchedule','PrepayAndAdditionalFeeSchedule','StrippingSchedule','FinancingSchedule','PIKSchedule','ServicingFeeSchedule','DefaultSchedule') -- (select Name from core.lookup where name like '%schedule%')
and (eve.StatusID is null or  eve.StatusID  in (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1))
and ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
group by eve.EffectiveStartDate,EventID,eve.AccountID,eve.EventTypeID
order by eve.AccountID,EventTypeID

update t1 set t1.DifferenceDate= 
(select isnull( DATEDIFF(day,t1.EffectiveStartDate,--'5/30/2017'
(select min(t.EffectiveStartDate) from #LocalTemp t where t.AccountID=t1.AccountID and t.EventTypeID= t1.EventTypeID )
),0)*-1 )
from #LocalTemp t1

--Update Schedule 
UPDATE eve set  
eve.EffectiveStartDate= dateadd(dd,temp.DifferenceDate,n.ClosingDate)
from [CORE].[Event] eve
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
inner join #LocalTemp temp on temp.AccountID=eve.AccountID and temp.EventID=eve.EventID
where
LEventTypeID.Name in ('Maturity','FundingSchedule','PIKScheduleDetail','LIBORSchedule','AmortSchedule','RateSpreadSchedule','PrepayAndAdditionalFeeSchedule','StrippingSchedule','FinancingSchedule','ServicingFeeSchedule','DefaultSchedule') -- (select Name from core.lookup where name like '%schedule%')
and (eve.StatusID is null or  eve.StatusID  in (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1))
and ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
and n.ClosingDate is not null

END
