
-- Procedure
 
CREATE PROCEDURE [dbo].[usp_InsertUpdateNotePeriodicCalcByNoteID] 
	@noteAdditinallist tempNotePeriodicCalc READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN
 

Declare @NoteID UNIQUEIDENTIFIER = (select Top 1 noteid from @noteAdditinallist)
Declare @AnalysisID UNIQUEIDENTIFIER = (select Top 1 AnalysisID from @noteAdditinallist)

IF(@AnalysisID is not null)
BEGIN

	IF Exists(Select * from CRE.NotePeriodicCalc where NoteID = @NoteID and AnalysisID  =@AnalysisID)
	BEGIN
		DELETE FROM CRE.NotePeriodicCalc WHERE NoteID = @NoteID  and AnalysisID  =@AnalysisID
	END


		INSERT INTO [CRE].[NotePeriodicCalc]
		([NoteID]
		,[PeriodEndDate]
		,[Month]
		,[ActualCashFlows]
		,[GAAPCashFlows]
		,[EndingGAAPBookValue]	 
		,[PIKInterestAccrualforthePeriod]
		,[TotalAmortAccrualForPeriod]
		,[AccumulatedAmort]
		,[BeginningBalance]
		,[TotalFutureAdvancesForThePeriod]
		,[TotalDiscretionaryCurtailmentsforthePeriod]	
		,[TotalCouponStrippedforthePeriod]
		,[CouponStrippedonPaymentDate]
		,[ScheduledPrincipal]
		,[PrincipalPaid]
		,[BalloonPayment]
		,[EndingBalance]		 
		,[EndOfPeriodWAL]
		,[PIKInterestFromPIKSourceNote]
		,[PIKInterestTransferredToRelatedNote]
		,[PIKInterestForThePeriod]
		,[BeginningPIKBalanceNotInsideLoanBalance]
		,[PIKInterestForPeriodNotInsideLoanBalance]
		,[PIKBalanceBalloonPayment]
		,[EndingPIKBalanceNotInsideLoanBalance]	
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
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate]
		,[CleanCost]
		,[GrossDeferredFees]
		,[DeferredFeesReceivable]
		,[CleanCostPrice]
		,[AmortizedCostPrice]
		,[AdditionalFeeAccrual]
		,[CapitalizedCostAccrual]	 
		,ReversalofPriorInterestAccrual
		,InterestReceivedinCurrentPeriod
		,CurrentPeriodInterestAccrual
		,TotalGAAPInterestFortheCurrentPeriod	 
		,InvestmentBasis
		,CurrentPeriodInterestAccrualPeriodEnddate
		,AnalysisID
		,FeeStrippedforthePeriod
		,PIKInterestPercentage
		,AmortizedCost
		,InterestSuspenseAccountActivityforthePeriod
		,InterestSuspenseAccountBalance
		,AllInBasisValuation
		,AllInPIKRate
		,CurrentPeriodPIKInterestAccrualPeriodEnddate
		,PIKInterestPaidForThePeriod
		,PIKInterestAppliedForThePeriod
		,EndingPreCapPVBasis
		,LevelYieldIncomeForThePeriod
		,PVAmortTotalIncomeMethod
		,EndingCleanCostLY
		,EndingAccumAmort
		,PVAmortForThePeriod
		,EndingSLBasis
		,SLAmortForThePeriod
		,SLAmortOfTotalFeesInclInLY
		,SLAmortOfDiscountPremium
		,SLAmortOfCapCost
		,EndingAccumSLAmort
		,EndingPreCapGAAPBasis
		,PIKPrincipalPaidForThePeriod
		
		)

		Select 
				 [NoteID]
				,[PeriodEndDate]
				,[Month]
				,[ActualCashFlows]
				,[GAAPCashFlows]
				,[EndingGAAPBookValue]			
				,[PIKInterestAccrualforthePeriod]
				,[TotalAmortAccrualForPeriod]
				,[AccumulatedAmort]
				,[BeginningBalance]
				,[TotalFutureAdvancesForThePeriod]
				,[TotalDiscretionaryCurtailmentsforthePeriod]			
				,[TotalCouponStrippedforthePeriod]
				,[CouponStrippedonPaymentDate]
				,[ScheduledPrincipal]
				,[PrincipalPaid]
				,[BalloonPayment]
				,[EndingBalance]				 
				,[EndOfPeriodWAL]
				,[PIKInterestFromPIKSourceNote]
				,[PIKInterestTransferredToRelatedNote]
				,[PIKInterestForThePeriod]
				,[BeginningPIKBalanceNotInsideLoanBalance]
				,[PIKInterestForPeriodNotInsideLoanBalance]
				,[PIKBalanceBalloonPayment]
				,[EndingPIKBalanceNotInsideLoanBalance]			
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
				,@CreatedBy
				,GETDATE()
				,@UpdatedBy
				,GETDATE()
				,[CleanCost]
				,[GrossDeferredFees]
				,[DeferredFeesReceivable]
				,[CleanCostPrice]
				,[AmortizedCostPrice]
				,[AdditionalFeeAccrual]
				,[CapitalizedCostAccrual]			
				,ReversalofPriorInterestAccrual
				,InterestReceivedinCurrentPeriod
				,CurrentPeriodInterestAccrual
				,TotalGAAPInterestFortheCurrentPeriod
				,InvestmentBasis
				,CurrentPeriodInterestAccrualPeriodEnddate			
				,AnalysisID
				,FeeStrippedforthePeriod
				,PIKInterestPercentage
				,AmortizedCost
				,InterestSuspenseAccountActivityforthePeriod
				,InterestSuspenseAccountBalance
				,AllInBasisValuation
				,AllInPIKRate
				,CurrentPeriodPIKInterestAccrualPeriodEnddate
				,PIKInterestPaidForThePeriod
				,PIKInterestAppliedForThePeriod					 
				,EndingPreCapPVBasis
				,LevelYieldIncomeForThePeriod
				,PVAmortTotalIncomeMethod
				,EndingCleanCostLY
				,EndingAccumAmort
				,PVAmortForThePeriod
				,EndingSLBasis
				,SLAmortForThePeriod
				,SLAmortOfTotalFeesInclInLY
				,SLAmortOfDiscountPremium
				,SLAmortOfCapCost
				,EndingAccumSLAmort
				,EndingPreCapGAAPBasis
				,PIKPrincipalPaidForThePeriod
				
				From  @noteAdditinallist

END

END


