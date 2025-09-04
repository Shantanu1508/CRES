-- Procedure


CREATE Procedure [dbo].[usp_ImportIntoAccountingClosePeriodicArchive]
@DealIDs nvarchar(max),
@CloseDate Date,
@UserID nvarchar(256)

AS

BEGIN

	SET NOCOUNT ON;


IF OBJECT_ID('tempdb..#tblDealList') IS NOT NULL         
	DROP TABLE #tblDealList

CREATE TABLE #tblDealList(
	CREDealId nvarchar(256)
)
INSERT INTO #tblDealList(CREDealId)
Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|')
--======================================================

IF OBJECT_ID('tempdb..#tblPeriodDeal') IS NOT NULL         
	DROP TABLE #tblPeriodDeal

CREATE TABLE #tblPeriodDeal(
	PeriodID UNIQUEIDENTIFIER,
	AnalysisID UNIQUEIDENTIFIER,
	DealID UNIQUEIDENTIFIER,
	LastAccountingCloseDate Date,
	NewClosedate Date
)
INSERT INTO #tblPeriodDeal(PeriodID,AnalysisID,DealID,LastAccountingCloseDate,NewClosedate)

Select p.PeriodID
,p.AnalysisID
,d.DealID
,lstCloseDate.LastAccountingCloseDate
,@CloseDate as NewClosedate

from CORE.[Period] p 	
Inner Join cre.deal d on d.dealid =  p.dealid
Inner Join(
	Select d.DealID,ISNULL(MAX(p.Closedate),'1/1/1900') as LastAccountingCloseDate
	from cre.deal d 
	Left Join CORE.[Period] p 	on d.dealid =  p.dealid and p.isdeleted <> 1 and p.CloseDate <> CAST(@CloseDate as date) 
	where d.isdeleted <> 1 
	and d.credealid in (Select CREDealId From #tblDealList)
	Group by  d.DealID
)lstCloseDate on lstCloseDate.DealID = p.DealID

where d.isdeleted <> 1 and p.isdeleted <> 1
and p.CloseDate = @CloseDate
and d.credealid in (Select CREDealId From #tblDealList)
--======================================================

	INSERT INTO [Core].[AccountingClosePeriodicArchive]
	([PeriodID]           
	,[NotePeriodicCalcID]
	,[NoteID]    
	,[PeriodEndDate]
	,[Month]
	,[ActualCashFlows] 
	,[GAAPCashFlows]   
	,[EndingGAAPBookValue]
	--,[TotalGAAPIncomeforthePeriod] 
	--,[InterestAccrualforthePeriod] 
	--,[PIKInterestAccrualforthePeriod]           
	,[TotalAmortAccrualForPeriod]  
	,[AccumulatedAmort]
	,[BeginningBalance]
	,[TotalFutureAdvancesForThePeriod]          
	,[TotalDiscretionaryCurtailmentsforthePeriod] 
	,[InterestPaidOnPaymentDate]   
	,[TotalCouponStrippedforthePeriod]          
	,[CouponStrippedonPaymentDate] 
	,[ScheduledPrincipal] 
	,[PrincipalPaid]   
	,[BalloonPayment]  
	,[EndingBalance]   
	,[ExitFeeIncludedInLevelYield] 
	,[ExitFeeExcludedFromLevelYield]            
	,[AdditionalFeesIncludedInLevelYield]       
	,[AdditionalFeesExcludedFromLevelYield]     
	,[OriginationFeeStripping]     
	,[ExitFeeStrippingIncldinLevelYield]        
	,[ExitFeeStrippingExcldfromLevelYield]      
	,[AddlFeesStrippingIncldinLevelYield]       
	,[AddlFeesStrippingExcldfromLevelYield]     
	,[EndOfPeriodWAL]  
	,[PIKInterestFromPIKSourceNote]
	,[PIKInterestTransferredToRelatedNote]      
	,[PIKInterestForThePeriod]     
	,[BeginningPIKBalanceNotInsideLoanBalance]  
	,[PIKInterestForPeriodNotInsideLoanBalance] 
	,[PIKBalanceBalloonPayment]    
	,[EndingPIKBalanceNotInsideLoanBalance]     
	,[CostBasis]       
	,[PreCapBasis]     
	,[BasisCap]        
	,[AmortAccrualLevelYield]      
	,[ScheduledPrincipalShortfall] 
	,[PrincipalShortfall] 
	,[PrincipalLoss]   
	,[InterestForPeriodShortfall]  
	,[InterestPaidOnPMTDateShortfall]           
	,[CumulativeInterestPaidOnPMTDateShortfall] 
	,[InterestShortfallLoss]       
	,[InterestShortfallRecovery]   
	,[BeginningFinancingBalance]   
	,[TotalFinancingDrawsCurtailmentsForPeriod] 
	,[FinancingBalloon]
	,[EndingFinancingBalance]      
	,[FinancingInterestPaid]       
	,[FinancingFeesPaid]  
	,[PeriodLeveredYield] 
	,[OrigFeeAccrual]  
	,[DiscountPremiumAccrual]      
	,[ExitFeeAccrual]  
	,[AllInCouponRate] 
	,[GrossDeferredFees]  
	,[DeferredFeesReceivable]      
	,[CleanCostPrice]  
	,[AmortizedCostPrice] 
	,[AdditionalFeeAccrual]        
	,[CapitalizedCostAccrual]      
	,[DailySpreadInterestbeforeStrippingRule]   
	,[DailyLiborInterestbeforeStrippingRule]    
	,[ReversalofPriorInterestAccrual]           
	,[InterestReceivedinCurrentPeriod]          
	,[CurrentPeriodInterestAccrual]
	,[TotalGAAPInterestFortheCurrentPeriod]     
	,[CleanCost]       
	,[InvestmentBasis] 
	,[CurrentPeriodInterestAccrualPeriodEnddate]
	,[LIBORPercentage] 
	,[SpreadPercentage]
	,[AnalysisID]
	,[FeeStrippedforthePeriod]     
	,[PIKInterestPercentage]       
	,[AmortizedCost]   
	,[InterestSuspenseAccountActivityforthePeriod]
	,[InterestSuspenseAccountBalance]           
	,[AllInBasisValuation]
	,[AllInPIKRate]    
	,[CurrentPeriodPIKInterestAccrualPeriodEnddate]
	,[PIKInterestPaidForThePeriod] 
	,[PIKInterestAppliedForThePeriod]           
	,[EndingPreCapPVBasis]
	,[LevelYieldIncomeForThePeriod]
	,[PVAmortTotalIncomeMethod]    
	,[EndingCleanCostLY]  
	,[EndingAccumAmort]
	,[PVAmortForThePeriod]
	,[EndingSLBasis]   
	,[SLAmortForThePeriod]
	,[SLAmortOfTotalFeesInclInLY]  
	,[SLAmortOfDiscountPremium]    
	,[SLAmortOfCapCost]
	,[EndingAccumSLAmort] 
	,[EndingPreCapGAAPBasis]       
	,[PIKPrincipalPaidForThePeriod]
	,[RemainingUnfundedCommitment]
	,CalcEngineType
	
	,levyld 
	--,cum_am_disc
	,cum_dailypikint
	,cum_baladdon_am
	,cum_baladdon_nonam
	,cum_dailyint
	,cum_ddbaladdon
	,cum_ddintdelta
	--,cum_am_capcosts
	,initbal
	,cum_fee_levyld
	,period_ddintdelta_shifted
	,intdeltabal
	,cum_exit_fee_excl_lv_yield
	
	,CurrentPeriodPIKInterestAccrual		
	,DropDateInterestDeltaBalance
	,AccPeriodEnd		
	,AccPeriodStart		
	,pmtdtnotadj		
	,pmtdt				
	,periodpikint		

	,[IsDeleted]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]	
	,DeferredFeeGAAPBasis   
	,CapitalizedCostLevelYield        
	,CapitalizedCostGAAPBasis		 
	,CapitalizedCostAccumulatedAmort	 
	,DiscountPremiumLevelYield		 
	,DiscountPremiumGAAPBasis		 
	,DiscountPremiumAccumulatedAmort	
	
	,AverageDailyBalance	 
	,InterestPastDue	
	,cum_unusedfee
	,PrincipalWriteoff
	,NetPIKAmountForThePeriod
	,ParentAccountID
	,CashInterest
	,CapitalizedInterest
	,CumulativeDailyPIKFromInterest
	,CumulativeDailyPIKCompounding
	,CumulativeDailyIntoPIK
	)

	Select 
	pd.PeriodID
	,nc.[NotePeriodicCalcID]
	,n.[NoteID]    
	,nc.[PeriodEndDate]
	,nc.[Month]
	,nc.[ActualCashFlows] 
	,nc.[GAAPCashFlows]   
	,nc.[EndingGAAPBookValue]
	--,nc.[TotalGAAPIncomeforthePeriod] 
	--,nc.[InterestAccrualforthePeriod] 
	--,nc.[PIKInterestAccrualforthePeriod]           
	,nc.[TotalAmortAccrualForPeriod]  
	,nc.[AccumulatedAmort]
	,nc.[BeginningBalance]
	,nc.[TotalFutureAdvancesForThePeriod]          
	,nc.[TotalDiscretionaryCurtailmentsforthePeriod] 
	,nc.[InterestPaidOnPaymentDate]   
	,nc.[TotalCouponStrippedforthePeriod]          
	,nc.[CouponStrippedonPaymentDate] 
	,nc.[ScheduledPrincipal] 
	,nc.[PrincipalPaid]   
	,nc.[BalloonPayment]  
	,nc.[EndingBalance]   
	,nc.[ExitFeeIncludedInLevelYield] 
	,nc.[ExitFeeExcludedFromLevelYield]            
	,nc.[AdditionalFeesIncludedInLevelYield]       
	,nc.[AdditionalFeesExcludedFromLevelYield]     
	,nc.[OriginationFeeStripping]     
	,nc.[ExitFeeStrippingIncldinLevelYield]        
	,nc.[ExitFeeStrippingExcldfromLevelYield]      
	,nc.[AddlFeesStrippingIncldinLevelYield]       
	,nc.[AddlFeesStrippingExcldfromLevelYield]     
	,nc.[EndOfPeriodWAL]  
	,nc.[PIKInterestFromPIKSourceNote]
	,nc.[PIKInterestTransferredToRelatedNote]      
	,nc.[PIKInterestForThePeriod]     
	,nc.[BeginningPIKBalanceNotInsideLoanBalance]  
	,nc.[PIKInterestForPeriodNotInsideLoanBalance] 
	,nc.[PIKBalanceBalloonPayment]    
	,nc.[EndingPIKBalanceNotInsideLoanBalance]     
	,nc.[CostBasis]       
	,nc.[PreCapBasis]     
	,nc.[BasisCap]        
	,nc.[AmortAccrualLevelYield]      
	,nc.[ScheduledPrincipalShortfall] 
	,nc.[PrincipalShortfall] 
	,nc.[PrincipalLoss]   
	,nc.[InterestForPeriodShortfall]  
	,nc.[InterestPaidOnPMTDateShortfall]           
	,nc.[CumulativeInterestPaidOnPMTDateShortfall] 
	,nc.[InterestShortfallLoss]       
	,nc.[InterestShortfallRecovery]   
	,nc.[BeginningFinancingBalance]   
	,nc.[TotalFinancingDrawsCurtailmentsForPeriod] 
	,nc.[FinancingBalloon]
	,nc.[EndingFinancingBalance]      
	,nc.[FinancingInterestPaid]       
	,nc.[FinancingFeesPaid]  
	,nc.[PeriodLeveredYield] 
	,nc.[OrigFeeAccrual]  
	,nc.[DiscountPremiumAccrual]      
	,nc.[ExitFeeAccrual]  
	,nc.[AllInCouponRate] 
	,nc.[GrossDeferredFees]  
	,nc.[DeferredFeesReceivable]      
	,nc.[CleanCostPrice]  
	,nc.[AmortizedCostPrice] 
	,nc.[AdditionalFeeAccrual]        
	,nc.[CapitalizedCostAccrual]      
	,nc.[DailySpreadInterestbeforeStrippingRule]   
	,nc.[DailyLiborInterestbeforeStrippingRule]    
	,nc.[ReversalofPriorInterestAccrual]           
	,nc.[InterestReceivedinCurrentPeriod]          
	,nc.[CurrentPeriodInterestAccrual]
	,nc.[TotalGAAPInterestFortheCurrentPeriod]     
	,nc.[CleanCost]       
	,nc.[InvestmentBasis] 
	,nc.[CurrentPeriodInterestAccrualPeriodEnddate]
	,nc.[LIBORPercentage] 
	,nc.[SpreadPercentage]
	,nc.[AnalysisID]
	,nc.[FeeStrippedforthePeriod]     
	,nc.[PIKInterestPercentage]       
	,nc.[AmortizedCost]   
	,nc.[InterestSuspenseAccountActivityforthePeriod]
	,nc.[InterestSuspenseAccountBalance]           
	,nc.[AllInBasisValuation]
	,nc.[AllInPIKRate]    
	,nc.[CurrentPeriodPIKInterestAccrualPeriodEnddate]
	,nc.[PIKInterestPaidForThePeriod] 
	,nc.[PIKInterestAppliedForThePeriod]           
	,nc.[EndingPreCapPVBasis]
	,nc.[LevelYieldIncomeForThePeriod]
	,nc.[PVAmortTotalIncomeMethod]    
	,nc.[EndingCleanCostLY]  
	,nc.[EndingAccumAmort]
	,nc.[PVAmortForThePeriod]
	,nc.[EndingSLBasis]   
	,nc.[SLAmortForThePeriod]
	,nc.[SLAmortOfTotalFeesInclInLY]  
	,nc.[SLAmortOfDiscountPremium]    
	,nc.[SLAmortOfCapCost]
	,nc.[EndingAccumSLAmort] 
	,nc.[EndingPreCapGAAPBasis]       
	,nc.[PIKPrincipalPaidForThePeriod]
	,nc.[RemainingUnfundedCommitment]
	,nc.CalcEngineType

	,nc.levyld 
	--,nc.cum_am_disc
	,nc.cum_dailypikint
	,nc.cum_baladdon_am
	,nc.cum_baladdon_nonam
	,nc.cum_dailyint
	,nc.cum_ddbaladdon
	,nc.cum_ddintdelta
	--,nc.cum_am_capcosts
	,nc.initbal
	,nc.cum_fee_levyld
	,nc.period_ddintdelta_shifted
	,nc.intdeltabal
	,nc.cum_exit_fee_excl_lv_yield

	,nc.CurrentPeriodPIKInterestAccrual
	,nc.DropDateInterestDeltaBalance
	,nc.AccPeriodEnd		
	,nc.AccPeriodStart		
	,nc.pmtdtnotadj		
	,nc.pmtdt				
	,nc.periodpikint	

	,0 as [IsDeleted]	
	,@UserID
	,GETDATE()
	,@UserID
	,GETDATE()
	,nc.DeferredFeeGAAPBasis 	           
	,nc.CapitalizedCostLevelYield        
	,nc.CapitalizedCostGAAPBasis		 
	,nc.CapitalizedCostAccumulatedAmort	 
	,nc.DiscountPremiumLevelYield		 
	,nc.DiscountPremiumGAAPBasis		 
	,nc.DiscountPremiumAccumulatedAmort	
	,nc.AverageDailyBalance	 
	,nc.InterestPastDue
	,nc.cum_unusedfee
	,nc.PrincipalWriteoff
	,nc.NetPIKAmountForThePeriod
	,nc.ParentAccountID
	,nc.CashInterest
	,nc.CapitalizedInterest
	,nc.CumulativeDailyPIKFromInterest
	,nc.CumulativeDailyPIKCompounding
	,nc.CumulativeDailyIntoPIK
	FROM cre.NotePeriodicCalc nc
	Inner join core.account acc on acc.accountid = nc.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid    
	--Inner join core.account acc on acc.accountid =n.account_accountid
	Inner Join #tblPeriodDeal pd on pd.DealID =  n.DealID and nc.AnalysisID = pd.AnalysisID
	WHERE  acc.Isdeleted <> 1	and acc.AccounttypeID = 1
	and ( CAST(PeriodEndDate as date) > CAST(pd.LastAccountingCloseDate as date) and CAST(PeriodEndDate as date) <= CAST(pd.NewClosedate as date))	
	


	--FROM cre.NotePeriodicCalc nc
	--inner join cre.Note n on n.NoteID = nc.NoteID
	--Inner join core.account acc on acc.accountid =n.account_accountid
	--WHERE  nc.AnalysisID =@AnalysisID
	--and acc.Isdeleted <> 1
	--and [Month] is not null
	--and ( CAST(PeriodEndDate as date) > CAST(@LastCloseDate as date) and CAST(PeriodEndDate as date) <= CAST(@EndDate as date))	
	--and n.AccountingClose  = 3
	



END
