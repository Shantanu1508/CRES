-- View
CREATE VIEW [dbo].[vw_Recon_Final_GAAP_Total_Interest_Check]  
  
AS  

Select      DealName
			,CREDealID as DealID
			,CreNoteid as NoteID
			,NoteName,
			--[Month],
			PeriodEndDate ,
			CalcGAAPInterestIncome= (CurrentPeriodInterestAccrual+CurrentPeriodPIKInterestAccrual+ ReversalofPriorInterestAccrual+InterestReceivedinCurrentPeriod),
			TotalGAAPInterestFortheCurrentPeriod-((CurrentPeriodInterestAccrual+CurrentPeriodPIKInterestAccrual+ ReversalofPriorInterestAccrual+InterestReceivedinCurrentPeriod)) as Delta,
			ABS(TotalGAAPInterestFortheCurrentPeriod-((CurrentPeriodInterestAccrual+CurrentPeriodPIKInterestAccrual+ ReversalofPriorInterestAccrual+InterestReceivedinCurrentPeriod))) as ABS_Delta,
			CurrentPeriodInterestAccrual ,			
			CurrentPeriodPIKInterestAccrual ,
			ReversalofPriorInterestAccrual,
			InterestReceivedinCurrentPeriod,
			TotalGAAPInterestFortheCurrentPeriod
			From(
					Select
					DealName
					,CREDealID
					,acc.Name as NoteName
					,CreNoteid
					,n.[NoteID]
					, [Month]
					, [PeriodEndDate]
					, npc.TotalGAAPInterestFortheCurrentPeriod
					, npc.CurrentPeriodInterestAccrual
					, npc.CurrentPeriodPIKInterestAccrual
					, npc.ReversalofPriorInterestAccrual
					, npc.InterestReceivedinCurrentPeriod
					from [cre].[NotePeriodicCalc] npc 
					Inner join cre.Note n on n.Account_AccountID = npc.AccountID
					Inner join cre.Deal d on d.dealID=n.DealID
					Inner Join core.account acc on acc.accountid = n.account_accountid
					Inner join (
					select npc.AccountId, max(periodenddate)  max_periodenddate , dateadd(dd, -10, GETDATE()) as MinDate
from cre.NotePeriodicCalc npc    
where npc.Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'                                
and [Month] is not null    
group by npc.AccountId
					) mx on mx.AccountID=npc.AccountID 
					join (
					--select AccountId, StatusID from core.CalculationRequests where AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F' and StatusID=266
					select  n.Account_AccountID AccountId from cre.Deal d join cre.Note n on n.DealID=d.DealID  join core.Account a on a.AccountID=n.Account_AccountID where   d.CalcEngineType=798 and a.IsDeleted<>1
					) cr on cr.AccountId=npc.AccountId
					Where acc.isdeleted <> 1
					and npc.Month is not null		
					and Periodenddate = eomonth (Periodenddate,0)
					and Periodenddate <> ISNULL(eomonth(n.ActualPayoffdate,0),eomonth(n.FullyextendedMaturitydate,0))	
					and Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' --Default_CopyV1
					--and npc.PeriodEndDate < mx.max_periodenddate
					--and EndingGAAPBookValue <> 0
					--and n.CRENoteID = '10000'
					and EnableM61Calculations=3
					and DealName not like ('%Copy')
			)a
			--Order by DealName, CRENoteID, PeriodEndDate