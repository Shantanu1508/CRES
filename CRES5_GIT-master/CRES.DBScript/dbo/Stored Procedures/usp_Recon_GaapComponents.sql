CREATE PROCEDURE [dbo].[usp_Recon_GaapComponents]
AS  
BEGIN  
  
	SET NOCOUNT ON;

Select CreNoteid ,
			PeriodEndDate ,
			EndingGAAPBookValue ,
			CalcGAAP= (Cleancost-InterestSuspenseAccountBalance+[AccumaltedDiscountPremiumBI]+ CurrentPeriodPIKInterestAccrual+[CurrentPeriodInterestAccrual]+ AccumulatedAmort+[AccumalatedCapitalizedCostBI]),
			EndingGAAPBookValue-((Cleancost-InterestSuspenseAccountBalance+[AccumaltedDiscountPremiumBI]+ CurrentPeriodPIKInterestAccrual+[CurrentPeriodInterestAccrual]+ AccumulatedAmort+[AccumalatedCapitalizedCostBI])) as Delta,
			CleanCost,
			InterestSuspenseAccountBalance,
			AccumaltedDiscountPremiumBI ,
			CurrentPeriodPIKInterestAccrual ,
			[CurrentPeriodInterestAccrual] ,
			AccumulatedAmort ,
			AccumalatedCapitalizedCostBI
			From(

			Select
			CreNoteid
			,n.[NoteID]
			, [PeriodEndDate]
			, EndingGAAPBookValue
			,ISNULL(CleanCost,0) as CleanCost
			,ISNULL(CurrentPeriodPIKInterestAccrual,0) as CurrentPeriodPIKInterestAccrual
			,SUM(ISNULL(nc.CapitalizedCostAccrual,0)) OVER(PARTITION BY nc.AnalysisID,nc.AccountID ORDER BY nc.AnalysisID,nc.AccountID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI
			,ISNULL([CurrentPeriodInterestAccrual],0) as [CurrentPeriodInterestAccrual]
			,SUM(ISNULL(nc.DiscountPremiumAccrual,0)) OVER(PARTITION BY nc.AnalysisID,nc.AccountID ORDER BY nc.AnalysisID,nc.AccountID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI
			,ISNULL(AccumulatedAmort,0) as AccumulatedAmort
			,ISNULL(InterestSuspenseAccountBalance,0) as InterestSuspenseAccountBalance		

			from [cre].[NotePeriodicCalc] Nc 
			Inner join cre.Note n on n.Account_AccountID = nc.AccountID
			Inner JOin core.account acc on acc.accountid = n.account_accountid
			Where acc.isdeleted <> 1
			and nc.Month is not null		
			and Periodenddate = eomonth (Periodenddate,0)
			and Periodenddate <> ISNULL(eomonth(n.ActualPayoffdate,0),eomonth(n.FullyextendedMaturitydate,0))	
			and Analysisid = 'c10f3372-0fc2-4861-a9f5-148f1f80804f' 
			--and EndingGAAPBookValue <> 0
			--and n.CRENoteID = '10000'
			and EnableM61Calculations=3
			)a
			Order by CRENoteID, PeriodEndDate


END