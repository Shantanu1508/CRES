--[dbo].[usp_GetNoteByDealID_PrepayLoad]    '1fd23dfd-9739-48e5-8c4d-20a6015a77ae','16-0155'

CREATE PROCEDURE [dbo].[usp_GetNoteByDealID_PrepayLoad] 
(
    @DealID UNIQUEIDENTIFIER,
	@CREDEalID nvarchar(256)
)
	
AS
BEGIN


 Select n.CRENoteID,  
 acc.Name as NoteName,
 n.NoteID,
 lLienPosition.name as LienPosition,  
 n.TotalCommitment as TotalCommitment,  
 --n.ClosingDate as ClosingDate,  
 CONVERT(varchar, n.ClosingDate, 101) as ClosingDate,  
 CONVERT(varchar,n.InitialMaturityDate, 101) as InitialMaturityDate,  
 CONVERT(varchar,n.FullyExtendedMaturityDate, 101) as FullyExtendedMaturityDate,  
 CONVERT(varchar,n.ActualPayoffDate, 101) as ActualPayOffDate 
 --DateDiff(month,n.ClosingDate,ISNULL(n.ActualPayoffDate,n.FullyExtendedMaturityDate) ) as LoanTerm,  
 --3 as LoanOpenPeriod,  
 --117 as YMTerm,  
 --0.025 as YMBenchmarkYield,  
 --'06/16/2019'as PrepayDate,  
 --0.01 as PrepayMinPct,  
 --0.0399 as LoanRate
 
-- '' as LoanTerm,  
--'' as LoanOpenPeriod,  
-- '' as YMTerm,  
-- '' as YMBenchmarkYield,  
-- '' as PrepayDate,  
-- '' as PrepayMinPct,  
--'' as LoanRate  

 from cre.note n  
 inner join core.account acc on acc.accountid = n.account_accountid  
 left join core.lookup lLienPosition on lLienPosition.lookupid = n.LienPosition  
 where n.dealid = @dealid  
  
 order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name   
  
  
	--===========================================================


	Select sEvent.NoteID ,sEvent.CRENoteID
--, [RateSpreadScheduleID] as ScheduleID
--,rs.[EventId]
,CONVERT(varchar, e.EffectiveStartDate, 101) as EffectiveStartDate
--, e.EffectiveStartDate
,CONVERT(varchar, rs.[Date], 101) as Date
--,rs.[Date]
,[ValueTypeID]
,rs.[Value]
,[IntCalcMethodID]
,LValueTypeID.Name as ValueTypeText
,LIntCalcMethodID.Name as IntCalcMethodText
--,e.EventTypeID as ModuleId
--,rs.RateOrSpreadToBeStripped as FeetobeStripped
from [CORE].RateSpreadSchedule rs
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
INNER JOIN 
			(						
				Select n.NoteID ,n.CRENoteID,
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
					and n.NoteID in (select Noteid from cre.note where Dealid=@dealid) -- @NoteID 
					 and acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID,n.NoteID,n.CRENoteID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
Left JOin(
	Select DISTINCT id.Date,id.IndexType,id.Value as LiborRate from core.Indexes id
	inner join core.Indexesmaster im on im.IndexesMasterID = id.IndexesMasterID
	where IndexesName = 'Default Index'
	and IndexType = 245 
)IndexLibor on IndexLibor.Date = rs.[Date]
where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)


END
