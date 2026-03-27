-- Procedure
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyAmortSchedule]     
AS    
BEGIN   




Select * from(

Select 
ISNULL(ff.DealName,tr.DealName) as [Deal Name]
,ISNULL(ff.CREDealID ,tr.CREDealID) as [Deal ID]
,ISNULL(ff.CRENoteID,tr.CRENoteID)  as [Note ID]
,ISNULL(ff.NoteName,tr.NoteName) as [Note Name]
,FF.date as FundingDate
,tr.Date as Trandate
,ISNULL(ROUND(FF.AmortScheduleAmount,2) ,0) as [Amort Schedule Amount]
,ISNULL(ROUND(tr.SchedulePrincipalPaid,2),0) as [Schedule Principal Paid]
,(ISNULL(ROUND(FF.AmortScheduleAmount,2) ,0) - ISNULL(ROUND(tr.SchedulePrincipalPaid,2),0)) as Delta

From
(
	Select n.noteid,n.crenoteid,acc.name as NoteName,d.DealName,d.credealid
	,fs.Date
	,SUM(fs.Value)* -1 as AmortScheduleAmount 
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN (						
		Select 
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID,eve.StatusID from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = 10
		and acc.IsDeleted = 0
		and eve.StatusID = 1		
		GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Inner join cre.deal d on d.dealid = n.DealID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fs.purposeid = 351
	and fs.date > '12/31/2018'
	and fs.date <= CAST(getdate() as date)
	---and n.crenoteid = '7411'
	Group by n.noteid,fs.date,n.crenoteid,acc.name ,d.DealName,d.credealid

)FF
Full Join(
	Select n.noteid,n.crenoteid,acc.name as NoteName,d.DealName,d.credealid
	,tr.date,SUM(amount) as SchedulePrincipalPaid 
	from cre.TransactionEntry tr
	Inner join cre.note n on n.Account_AccountID = tr.AccountId
	Inner join core.Account acc on acc.accountid = n.Account_AccountID
	Inner join cre.deal d on d.dealid = n.DealID
	Where acc.isdeleted <> 1
	and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and [type] = 'ScheduledPrincipalPaid'
	and tr.date > '12/31/2018'
	and tr.date <= CAST(getdate() as date)
	--and n.crenoteid = '7411'
	Group by n.noteid,tr.date,n.crenoteid,acc.name ,d.DealName,d.credealid

)tr on tr.NoteID= FF.NoteID and CAST(FF.date as date)= cast(tr.date as date)


)z
where  ABS(Delta) > 0.1
and [Deal Name] not in (
'60-68 W. 107th Street',
'Bob''s Discount Furniture Phantom',
'Cityplace Tower',
'Empire Multifamily Portfolio - Delphi Pool 2',
'Outlet Mall Portfolio Refi',
'Pearl PE',
'Pittsburgh Wyndham - Modification',
'San Luis Obispo Refi',
'SOP Loan Program IC Memo',
'Windsor Hotel Portfolio Fixed Rate'
)
AND [Deal Name] NOT LIKE '%copy%'
Order by [Deal Name],[Note Id],ISNULL(FundingDate,Trandate)

END