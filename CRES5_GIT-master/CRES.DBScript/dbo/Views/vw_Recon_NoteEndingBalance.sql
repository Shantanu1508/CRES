-- View
-- View
--select Name, lower(AnalysisID) ID from core.Analysis order by 1
--select * from core.LookUp l where l.ParentID=134
/*	Balance Check	*/
create View vw_Recon_NoteEndingBalance as
select [Name], creDealID,DealName, CRENoteID, sum(Delta) as Delta from (
	select an.Name,d.creDealID, DealName, CRENoteID, npc.PeriodEndDate , npc.Month
	,BeginningBalance + isnull(npc.BeginningPIKBalanceNotInsideLoanBalance,0)  BeginningBalance
	,TotalFutureAdvancesForThePeriod
	,TotalDiscretionaryCurtailmentsforthePeriod
	--,TotalCouponStrippedforthePeriod
	--,CouponStrippedonPaymentDate
	,ScheduledPrincipal
	,PrincipalPaid
	,PIKInterestAppliedForThePeriod + isnull(npc.PIKInterestForPeriodNotInsideLoanBalance,0)  PIKInterestAppliedForThePeriod
	,PIKPrincipalPaidForThePeriod + isnull(npc.PIKBalanceBalloonPayment,0) PIKPrincipalPaidForThePeriod
	,BalloonPayment
	,EndingBalance  + isnull(npc.EndingPIKBalanceNotInsideLoanBalance,0) EndingBalance
	,EndingBalance  + isnull(npc.EndingPIKBalanceNotInsideLoanBalance,0) - (BeginningBalance+ isnull(npc.BeginningPIKBalanceNotInsideLoanBalance,0) + TotalFutureAdvancesForThePeriod + TotalDiscretionaryCurtailmentsforthePeriod /*+ ScheduledPrincipal  */+ isnull(PrincipalPaid,0)  + BalloonPayment + PIKInterestAppliedForThePeriod + isnull(npc.PIKInterestForPeriodNotInsideLoanBalance,0) + PIKPrincipalPaidForThePeriod + isnull(npc.PIKBalanceBalloonPayment,0)) as Delta
	from cre.NotePeriodicCalc npc
	join cre.Note n on n.Account_AccountID=npc.AccountID
	join cre.Deal d on d.DealID=n.DealID
	join core.Account a on a.AccountID=npc.AccountID
	join core.Analysis an on an.AnalysisID=npc.AnalysisID
	join (
		select NoteID from cre.Note n
		join cre.Deal d on d.DealID=n.DealID
		where isnull(d.CalcEngineType,797) <> 798
		and n.EnableM61Calculations = 3
		and d.IsDeleted <> 1
	) v1  on v1.NoteID=n.NoteID
	where npc.AnalysisID in ('c10f3372-0fc2-4861-a9f5-148f1f80804f',	'928387e0-8d5f-4387-98d3-37d8a84f038d',	'6b82f761-e132-4a01-a7f1-17498b1cfdfe',	'6b4415bb-b467-4d20-9dda-6c016c174236',	'81f49f3a-c196-4e10-829e-aaf593552889',	'd8f8af6d-b9c7-4015-a610-41d34941eeb5')
	and npc.Month is not null
	and a.IsDeleted <> 1 and a.StatusID=1
	--order by DealName, CRENoteID, npc.Month
)  cf
group by [Name],creDealID, DealName, CRENoteID
--order by [Name], DealName, CRENoteID
GO


