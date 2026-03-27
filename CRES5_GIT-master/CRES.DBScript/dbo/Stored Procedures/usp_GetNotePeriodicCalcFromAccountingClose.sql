
CREATE PROCEDURE [dbo].[usp_GetNotePeriodicCalcFromAccountingClose] 
(
	@NoteID  UNIQUEIDENTIFIER,
	@AnalysisID  UNIQUEIDENTIFIER
	--@AccountingCloseDate Date
) 
AS
BEGIN
    SET NOCOUNT ON;	 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	Select 
	accNc.[NoteID]                                       
	,accNc.[PeriodEndDate]                                
	,accNc.[Month]                                        
	,accNc.[ActualCashFlows]                              
	,accNc.[GAAPCashFlows]                                
	,accNc.[EndingGAAPBookValue]                          
	--,accNc.[TotalGAAPIncomeforthePeriod]                  
	--,accNc.[InterestAccrualforthePeriod]                  
	--,accNc.[PIKInterestAccrualforthePeriod]               
	,accNc.[TotalAmortAccrualForPeriod]                   
	,accNc.[AccumulatedAmort]                             
	,accNc.[BeginningBalance]                             
	,accNc.[TotalFutureAdvancesForThePeriod]              
	,accNc.[TotalDiscretionaryCurtailmentsforthePeriod]   
	,accNc.[InterestPaidOnPaymentDate]                    
	,accNc.[TotalCouponStrippedforthePeriod]              
	,accNc.[CouponStrippedonPaymentDate]                  
	,accNc.[ScheduledPrincipal]                           
	,accNc.[PrincipalPaid]                                
	,accNc.[BalloonPayment]                               
	,accNc.[EndingBalance]                                
	,accNc.[ExitFeeIncludedInLevelYield]                  
	,accNc.[ExitFeeExcludedFromLevelYield]                
	,accNc.[AdditionalFeesIncludedInLevelYield]           
	,accNc.[AdditionalFeesExcludedFromLevelYield]         
	,accNc.[OriginationFeeStripping]                      
	,accNc.[ExitFeeStrippingIncldinLevelYield]            
	,accNc.[ExitFeeStrippingExcldfromLevelYield]          
	,accNc.[AddlFeesStrippingIncldinLevelYield]           
	,accNc.[AddlFeesStrippingExcldfromLevelYield]         
	,accNc.[EndOfPeriodWAL]                               
	,accNc.[PIKInterestFromPIKSourceNote]                 
	,accNc.[PIKInterestTransferredToRelatedNote]          
	,accNc.[PIKInterestForThePeriod]                      
	,accNc.[BeginningPIKBalanceNotInsideLoanBalance]      
	,accNc.[PIKInterestForPeriodNotInsideLoanBalance]     
	,accNc.[PIKBalanceBalloonPayment]                     
	,accNc.[EndingPIKBalanceNotInsideLoanBalance]         
	,accNc.[CostBasis]                                    
	,accNc.[PreCapBasis]                                  
	,accNc.[BasisCap]                                     
	,accNc.[AmortAccrualLevelYield]                       
	,accNc.[ScheduledPrincipalShortfall]                  
	,accNc.[PrincipalShortfall]                           
	,accNc.[PrincipalLoss]                                
	,accNc.[InterestForPeriodShortfall]                   
	,accNc.[InterestPaidOnPMTDateShortfall]               
	,accNc.[CumulativeInterestPaidOnPMTDateShortfall]     
	,accNc.[InterestShortfallLoss]                        
	,accNc.[InterestShortfallRecovery]                    
	,accNc.[BeginningFinancingBalance]                    
	,accNc.[TotalFinancingDrawsCurtailmentsForPeriod]     
	,accNc.[FinancingBalloon]                             
	,accNc.[EndingFinancingBalance]                       
	,accNc.[FinancingInterestPaid]                        
	,accNc.[FinancingFeesPaid]                            
	,accNc.[PeriodLeveredYield]  
	,accNc.[OrigFeeAccrual]                               
	,accNc.[DiscountPremiumAccrual]                       
	,accNc.[ExitFeeAccrual]                               
	,accNc.[AllInCouponRate]                              
	,accNc.[GrossDeferredFees]                            
	,accNc.[DeferredFeesReceivable]                       
	,accNc.[CleanCostPrice]                               
	,accNc.[AmortizedCostPrice]                           
	,accNc.[AdditionalFeeAccrual]                         
	,accNc.[CapitalizedCostAccrual]                       
	,accNc.[DailySpreadInterestbeforeStrippingRule]       
	,accNc.[DailyLiborInterestbeforeStrippingRule]        
	,accNc.[ReversalofPriorInterestAccrual]               
	,accNc.[InterestReceivedinCurrentPeriod]              
	,accNc.[CurrentPeriodInterestAccrual]                 
	,accNc.[TotalGAAPInterestFortheCurrentPeriod]         
	,accNc.[CleanCost]                                    
	,accNc.[InvestmentBasis]                              
	,accNc.[CurrentPeriodInterestAccrualPeriodEnddate] 
	,accNc.[LIBORPercentage]                              
	,accNc.[SpreadPercentage]                             
	,accNc.[AnalysisID]                                   
	,accNc.[FeeStrippedforthePeriod]                      
	,accNc.[PIKInterestPercentage]                        
	,accNc.[AmortizedCost]                                
	,accNc.[InterestSuspenseAccountActivityforthePeriod]  
	,accNc.[InterestSuspenseAccountBalance]               
	,accNc.[AllInBasisValuation]                          
	,accNc.[AllInPIKRate]                                 
	,accNc.[CurrentPeriodPIKInterestAccrualPeriodEnddate] 
	,accNc.[PIKInterestPaidForThePeriod]                  
	,accNc.[PIKInterestAppliedForThePeriod]               
	,accNc.[EndingPreCapPVBasis]                          
	,accNc.[LevelYieldIncomeForThePeriod]                 
	,accNc.[PVAmortTotalIncomeMethod]                     
	,accNc.[EndingCleanCostLY]                            
	,accNc.[EndingAccumAmort]                             
	,accNc.[PVAmortForThePeriod]                          
	,accNc.[EndingSLBasis]                                
	,accNc.[SLAmortForThePeriod]                          
	,accNc.[SLAmortOfTotalFeesInclInLY]                   
	,accNc.[SLAmortOfDiscountPremium]                     
	,accNc.[SLAmortOfCapCost]                             
	,accNc.[EndingAccumSLAmort]                           
	,accNc.[EndingPreCapGAAPBasis]                        
	,accNc.[PIKPrincipalPaidForThePeriod]                 
	,accNc.[RemainingUnfundedCommitment]                 
	,accNc.CalcEngineType             	
	,accNc.levyld 	
	--,accNc.cum_am_disc	
	,accNc.cum_dailypikint	
	,accNc.cum_baladdon_am	
	,accNc.cum_baladdon_nonam	
	,accNc.cum_dailyint	
	,accNc.cum_ddbaladdon	
	,accNc.cum_ddintdelta	
	--,accNc.cum_am_capcosts	
	,accNc.initbal	
	,accNc.cum_fee_levyld	
	,accNc.period_ddintdelta_shifted	
	,accNc.intdeltabal	
	,accNc.cum_exit_fee_excl_lv_yield	
	
	,accNc.CurrentPeriodPIKInterestAccrual
	,accNc.DropDateInterestDeltaBalance
	,accNc.AccPeriodEnd		
	,accNc.AccPeriodStart		
	,accNc.pmtdtnotadj		
	,accNc.pmtdt				
	,accNc.periodpikint --as pmtdtpikint  ---Temporary

	,accNc.[IsDeleted]                       
	,accNc.[CreatedBy]                       
	,accNc.[CreatedDate]                     
	,accNc.[UpdatedBy]                       
	,accNc.[UpdatedDate]                     
	,p.CloseDate as accountingclosedate

	,accNc.DeferredFeeGAAPBasis 	           
	,accNc.CapitalizedCostLevelYield        
	,accNc.CapitalizedCostGAAPBasis		 
	,accNc.CapitalizedCostAccumulatedAmort	 
	,accNc.DiscountPremiumLevelYield		 
	,accNc.DiscountPremiumGAAPBasis		 
	,accNc.DiscountPremiumAccumulatedAmort	

	,accNc.AverageDailyBalance	 
	,accNc.InterestPastDue
	,n.Account_AccountID as AccountId
	,accNc.cum_unusedfee
	,accNc.PrincipalWriteoff
	,accNc.NetPIKAmountForThePeriod
	,accNc.ParentAccountID
	,accNc.CashInterest
	,accNc.CapitalizedInterest
	,accNc.CumulativeDailyPIKFromInterest
	,accNc.CumulativeDailyPIKCompounding
	,accNc.CumulativeDailyIntoPIK
	from [Core].[AccountingClosePeriodicArchive]  accNc
	inner join cre.note n on n.NoteID = accNc.NoteID
	Inner Join core.[period] p on p.PeriodID = accNc.PeriodID
	where accNc.IsDeleted <> 1 and p.IsDeleted	<> 1
	and accNc.noteid = @NoteID	
	and p.AnalysisID = @AnalysisID

	--and p.CloseDate <= @AccountingCloseDate
	 

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED



	

END      


