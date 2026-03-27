CREATE VIEW [dbo].[vw_Recon_GAAP_Components_Check]  
  
AS  


Select DealName, CreDealID, CreNoteid , NoteName,
			[Month],
			PeriodEndDate ,
			EndingGAAPBookValue ,
			CalcGAAP= (Cleancost+[AccumaltedDiscountPremiumBI]+ [CurrentPeriodPIKInterestAccrual]+[CurrentPeriodInterestAccrual]+ AccumulatedAmort+[AccumalatedCapitalizedCostBI]),
			EndingGAAPBookValue-((Cleancost+[AccumaltedDiscountPremiumBI]+ [CurrentPeriodPIKInterestAccrual]+[CurrentPeriodInterestAccrual]+ AccumulatedAmort+[AccumalatedCapitalizedCostBI])) as Delta,
			CleanCost,
			CurrentPeriodInterestAccrual ,			
			CurrentPeriodPIKInterestAccrual ,
			InterestSuspenseAccountBalance,
			AccumulatedAmort ,
			AccumaltedDiscountPremiumBI ,
			AccumalatedCapitalizedCostBI
			From(
			Select
			DealName
			,CREDealID
			,CreNoteid
			,acc.Name as NoteName
			,n.[NoteID]
			, [Month]
			, [PeriodEndDate]
			, EndingGAAPBookValue
			,ISNULL(CleanCost,0) as CleanCost
			,ISNULL([CurrentPeriodPIKInterestAccrual],0) as CurrentPeriodPIKInterestAccrual
			,SUM(ISNULL(nc.CapitalizedCostAccrual,0)) OVER(PARTITION BY nc.AnalysisID,n.NoteID ORDER BY nc.AnalysisID,n.NoteID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI
			,ISNULL([CurrentPeriodInterestAccrual],0) as CurrentPeriodInterestAccrual
			,SUM(ISNULL(nc.DiscountPremiumAccrual,0)) OVER(PARTITION BY nc.AnalysisID,n.NoteID ORDER BY nc.AnalysisID,n.NoteID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI
			,ISNULL(AccumulatedAmort,0) as AccumulatedAmort
			,ISNULL(InterestSuspenseAccountBalance,0) as InterestSuspenseAccountBalance		

			from [cre].[NotePeriodicCalc] Nc 
			Inner join cre.Note n on n.Account_AccountID = nc.AccountID
			Inner Join cre.Deal d on d.DealID = n.DealID
			Inner Join core.account acc on acc.accountid = n.account_accountid
			Inner join (
				select npc.AccountId, max(periodenddate)  max_periodenddate , dateadd(dd, -10, GETDATE()) as MinDate
				from cre.NotePeriodicCalc npc    
				where npc.Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'                                 
				and [Month] is not null    
				group by npc.AccountId
			)mx on mx.AccountID=nc.AccountID 
			join (
			--select AccountId, StatusID from core.CalculationRequests where AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F' and StatusID=266
			select  n.Account_AccountID AccountId from cre.Deal d join cre.Note n on n.DealID=d.DealID  join core.Account a on a.AccountID=n.Account_AccountID where   d.CalcEngineType=798 and a.IsDeleted<>1
			) cr on cr.AccountId=nc.AccountId
			Where 
			acc.isdeleted <> 1
			and nc.Month is not null		
			and Periodenddate = eomonth (Periodenddate,0)
			and Periodenddate <> ISNULL(eomonth(n.ActualPayoffdate,0),eomonth(n.FullyextendedMaturitydate,0))	
			and Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
			and Nc.PeriodEndDate < mx.max_periodenddate
			--and EndingGAAPBookValue <> 0
			--and n.CRENoteID = '10000'
			and EnableM61Calculations=3
			)a
			--Where ABS(EndingGAAPBookValue-((Cleancost+[AccumaltedDiscountPremiumBI]+ [CurrentPeriodPIKInterestAccrual]+[CurrentPeriodInterestAccrual]+ AccumulatedAmort+[AccumalatedCapitalizedCostBI])) ) > 0.1
			--Order by DealName, CRENoteID, PeriodEndDate