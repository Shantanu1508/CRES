

 


CREATE PROCEDURE [dbo].[usp_GetNoteCashflowsExportData1] 

@NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'

AS
BEGIN
    SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #TblNote 
(
  NoteID UNIQUEIDENTIFIER,
  CRENoteID NVARCHAR(256),
  NoteName VARCHAR(256)
)

INSERT INTO #TblNote(Noteid, CRENoteID, NoteName)
select 
    n.Noteid Noteid,
	n.CRENoteID CRENoteID,
	acc.Name NoteName
	from Cre.Note n 
	inner join core.Account acc on acc.AccountID=n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	AND acc.IsDeleted=0


Declare @Column nvarchar(256)=(select top 1 l.Name from core.Lookup  l inner join core.AnalysisParameter ap on l.lookupid=ap.MaturityScenarioOverrideID 
inner join core.Analysis a on a.AnalysisID=ap.AnalysisID where a.StatusID=(select LookupID from core.Lookup where ParentID =2 and  Name = 'Y'))

Select Noteid,NoteName,LEFT(CONVERT(VARCHAR, TransDate, 101), 10) AS [Date],Value,ValueType
from
(
	select 
	n.CRENoteID Noteid,
	n.NoteName NoteName,
	te.[Date] AS [TransDate],
	te.Amount Value,
	te.[Type] ValueType
	 from  CRE.TransactionEntry te 
	 INNER JOIN #TblNote n ON n.NoteID=te.NoteID

	--inner join Cre.Note n on n.NoteID=te.NoteID
	--inner join core.Account acc on acc.AccountID=n.Account_AccountID
	--where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	--AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	--AND acc.IsDeleted=0
	
	
	
	--and te.[type] not in (Select replace(name,' ','') + 'Receivable' from core.lookup where lookupid in (163,164,165,166))	


	--UNION ALL	 

	--select 
	--n.crenoteid as Noteid
	--,a.name as NoteName
	--,dateadd(d,day(firstpaymentdate),eomonth(transactiondate,-1))  AS [TransDate]
	--,amount as Value
	--,replace(l.name,' ','') + 'Receivable' as ValueType
	--from cre.note n inner join core.account a on n.account_accountid=a.accountid inner join 
	--cre.payruledistributions p on p.receivernoteid=n.noteid inner join core.lookup l on p.ruleid=l.lookupid
	--where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	--and isnull(amount,0)<>0 and a.IsDeleted=0
	--AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	--and dateadd(d,day(firstpaymentdate),eomonth(transactiondate,-1))  <= (select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = a.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	--)

)a
order by a.NoteID,Transdate  asc

DROP TABLE #TblNote
	 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	
END







