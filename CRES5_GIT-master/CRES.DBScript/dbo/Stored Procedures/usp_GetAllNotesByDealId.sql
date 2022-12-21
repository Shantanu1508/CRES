
--  [dbo].[usp_GetAllNotesByDealId] null,'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,''
Create PROCEDURE [dbo].[usp_GetAllNotesByDealId] --'', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',0,0,''
(
    @DealId Varchar(500),
	@UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@totalCount INT OUTPUT 
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 IF(@DealId IS NULL or @DealId='')
 
	 BEGIN
	        SELECT @totalCount = COUNT(NoteID) FROM CRE.Note WITH (ROWLOCK, HOLDLOCK);
			
		SELECT n.NoteID
			  ,Account_AccountID
			  ,n.DealID
			  ,CRENoteID
			  ,Comments
			  ,PayFrequency
			  ,InitialInterestAccrualEndDate
			  ,AccrualFrequency
			  ,DeterminationDateLeadDays
			  ,DeterminationDateReferenceDayoftheMonth
			  ,DeterminationDateInterestAccrualPeriod
			  ,DeterminationDateHolidayList
			  ,FirstPaymentDate
			  ,InitialMonthEndPMTDateBiWeekly
			  ,PaymentDateBusinessDayLag
			  ,IOTerm
			  ,AmortTerm
			  ,PIKSeparateCompounding
			  ,MonthlyDSOverridewhenAmortizing
			  ,AccrualPeriodPaymentDayWhenNotEOMonth
			  ,FirstPeriodInterestPaymentOverride
			  ,FirstPeriodPrincipalPaymentOverride
			  ,FinalInterestAccrualEndDateOverride
			  ,AmortType
			  ,RateType
			   ,l.Name 'RateTypeText' 
			  ,ReAmortizeMonthly
			  ,ReAmortizeatPMTReset
			  ,StubPaidInArrears
			  ,RelativePaymentMonth
			  ,SettleWithAccrualFlag
			  ,InterestDueAtMaturity
			  ,RateIndexResetFreq
			  ,FirstRateIndexResetDate
			  ,LoanPurchase
			  ,AmortIntCalcDayCount
			  ,StubPaidinAdvanceYN
			  ,FullPeriodInterestDueatMaturity
			  ,ProspectiveAccountingMode
			  ,IsCapitalized
			  ,SelectedMaturityDateScenario
			  ,SelectedMaturityDate
			
			  ,tblInitialMaturity.InitialMaturityDate as InitialMaturityDate

			  ,ExpectedMaturityDate
			  ,FullyExtendedMaturityDate
			  ,OpenPrepaymentDate
			  ,CashflowEngineID
			  ,LoanType
			  ,Classification
			  ,SubClassification
			  ,GAAPDesignation
			  ,PortfolioID
			  ,GeographicLocation
			  ,PropertyType
			  ,RatingAgency
			  ,RiskRating
			  ,PurchasePrice
			  ,FutureFeesUsedforLevelYeild
			  ,TotalToBeAmortized
			  ,StubPeriodInterest
			  ,WDPAssetMultiple
			  ,WDPEquityMultiple
			  ,PurchaseBalance
			  ,DaysofAccrued
			  ,InterestRate
			  ,PurchasedInterestCalc
			  ,ModelFinancingDrawsForFutureFundings
			  ,NumberOfBusinessDaysLagForFinancingDraw
			  ,FinancingFacilityID
			  ,FinancingInitialMaturityDate
			  ,FinancingExtendedMaturityDate
			  ,FinancingPayFrequency
			  ,FinancingInterestPaymentDay
			  ,ClosingDate
			  ,InitialFundingAmount
			  ,Discount
			  ,OriginationFee
			  ,CapitalizedClosingCosts
			  ,PurchaseDate
			  ,PurchaseAccruedFromDate
			  ,PurchasedInterestOverride
			  ,DiscountRate
			  ,ValuationDate
			  ,FairValue
			  ,DiscountRatePlus
			  ,FairValuePlus
			  ,DiscountRateMinus
			  ,FairValueMinus
			  ,InitialIndexValueOverride
			  ,IncludeServicingPaymentOverrideinLevelYield
			  ,OngoingAnnualizedServicingFee
			  ,IndexRoundingRule
			  ,RoundingMethod
			  ,StubInterestPaidonFutureAdvances
              ,NoofdaysrelPaymentDaterollnextpaymentcycle
			  ,n.CreatedBy
			  ,n.CreatedDate
			  ,n.UpdatedBy
			  ,n.UpdatedDate
			  ,ISNULL(a.StatusID,1) StatusID
			 ,a.Name	
			 ,d.DealName
			 ,n.ServicerID
			 ,n.TotalCommitment
			 ,n.ClientName
			 ,n.Portfolio
			 ,n.Tag1
			 ,n.Tag2
			 ,n.Tag3
			 ,n.Tag4
			--,n.ExtendedMaturityScenario1
			--,n.ExtendedMaturityScenario2
			--,n.ExtendedMaturityScenario3
			,n.ActualPayoffDate
			 ,n.UnusedFeeThresholdBalance 
			 ,n.UnusedFeePaymentFrequency
			 ,n.NoteTransferDate
			 ,lSelectedMaturityDateScenario.Name as SelectedMaturityDateScenarioText
			 ,n.ExtendedMaturityCurrent
			  ,n.ImpactCommitmentCalc
			FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID
			inner join cre.Deal d on n.DealId = d.DealId
			left join Core.Lookup l ON n.RateType=l.LookupID
			left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID
			left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID
			left join Core.Lookup lSelectedMaturityDateScenario on n.SelectedMaturityDateScenario =lSelectedMaturityDateScenario.LookupID

			Left JOin(
				Select n.noteid,mat.MaturityDate as InitialMaturityDate
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11  
					and acc.IsDeleted = 0  
					--and n.dealid = @DealId
					and eve.StatusID = 1
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1 
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where mat.MaturityType = 708 and mat.Approved = 3
				--and n.dealid = @DealId

			)tblInitialMaturity on tblInitialMaturity.noteid = n.noteid
			Where a.IsDeleted = 0

			ORDER BY  n.UpdatedDate DESC
			  OFFSET (@PgeIndex -1)*@PageSize ROWS
			  FETCH NEXT @PageSize ROWS ONLY;
		  

		END
  ELSE
			  BEGIN
  
				  SELECT @totalCount = COUNT(NoteID) FROM CRE.Note WITH (ROWLOCK, HOLDLOCK) where DealID=@DealId;

					SELECT n.NoteID
				  ,Account_AccountID
				  ,n.DealID
				  ,CRENoteID
				  ,Comments
				  ,PayFrequency
				  ,InitialInterestAccrualEndDate
				  ,AccrualFrequency
				  ,DeterminationDateLeadDays
				  ,DeterminationDateReferenceDayoftheMonth
				  ,DeterminationDateInterestAccrualPeriod
				  ,DeterminationDateHolidayList
				  ,FirstPaymentDate
				  ,InitialMonthEndPMTDateBiWeekly
				  ,PaymentDateBusinessDayLag
				  ,IOTerm
				  ,AmortTerm
				  ,PIKSeparateCompounding
				  ,MonthlyDSOverridewhenAmortizing
				  ,AccrualPeriodPaymentDayWhenNotEOMonth
				  ,FirstPeriodInterestPaymentOverride
				  ,FirstPeriodPrincipalPaymentOverride
				  ,FinalInterestAccrualEndDateOverride
				  ,AmortType
				  ,RateType
				    ,l.Name 'RateTypeText' 
				  ,ReAmortizeMonthly
				  ,ReAmortizeatPMTReset
				  ,StubPaidInArrears
				  ,RelativePaymentMonth
				  ,SettleWithAccrualFlag
				  ,InterestDueAtMaturity
				  ,RateIndexResetFreq
				  ,FirstRateIndexResetDate
				  ,LoanPurchase
				  ,AmortIntCalcDayCount
				  ,StubPaidinAdvanceYN
				  ,FullPeriodInterestDueatMaturity
				  ,ProspectiveAccountingMode
				  ,IsCapitalized
				  ,SelectedMaturityDateScenario
				  ,SelectedMaturityDate

				 ,tblInitialMaturity.InitialMaturityDate as InitialMaturityDate

				 -- ,(
					--Select mat.MaturityDate
					--from [CORE].Maturity mat
					--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
					--INNER JOIN 
					--(
					--	Select 
					--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
					--		and acc.AccountID = a.AccountID
					--		GROUP BY n.Account_AccountID,EventTypeID
					--) sEvent
					--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
					--and mat.MaturityType = 708
					--)InitialMaturityDate

				  ,ExpectedMaturityDate
				  ,FullyExtendedMaturityDate
				  ,OpenPrepaymentDate
				  ,CashflowEngineID
				  ,LoanType
				  ,Classification
				  ,SubClassification
				  ,GAAPDesignation
				  ,PortfolioID
				  ,GeographicLocation
				  ,PropertyType
				  ,RatingAgency
				  ,RiskRating
				  ,PurchasePrice
				  ,FutureFeesUsedforLevelYeild
				  ,TotalToBeAmortized
				  ,StubPeriodInterest
				  ,WDPAssetMultiple
				  ,WDPEquityMultiple
				  ,PurchaseBalance
				  ,DaysofAccrued
				  ,InterestRate
				  ,PurchasedInterestCalc
				  ,ModelFinancingDrawsForFutureFundings
				  ,NumberOfBusinessDaysLagForFinancingDraw
				  ,FinancingFacilityID
				  ,FinancingInitialMaturityDate
				  ,FinancingExtendedMaturityDate
				  ,FinancingPayFrequency
				  ,FinancingInterestPaymentDay
				  ,ClosingDate
				  ,InitialFundingAmount
				  ,Discount
				  ,OriginationFee
				  ,CapitalizedClosingCosts
				  ,PurchaseDate
				  ,PurchaseAccruedFromDate
				  ,PurchasedInterestOverride
				  ,DiscountRate
				  ,ValuationDate
				  ,FairValue
				  ,DiscountRatePlus
				  ,FairValuePlus
				  ,DiscountRateMinus
				  ,FairValueMinus
				  ,InitialIndexValueOverride
				  ,IncludeServicingPaymentOverrideinLevelYield
				  ,OngoingAnnualizedServicingFee
				  ,IndexRoundingRule
				  ,RoundingMethod
				  ,StubInterestPaidonFutureAdvances
                  ,NoofdaysrelPaymentDaterollnextpaymentcycle
				  ,n.CreatedBy
				  ,n.CreatedDate
				  ,n.UpdatedBy
				  ,n.UpdatedDate
				 ,ISNULL(a.StatusID,1) StatusID
				 ,a.Name		
				  ,d.DealName 
				   ,n.ServicerID
				 ,n.TotalCommitment
				  ,n.ClientName
				 ,n.Portfolio
				 ,n.Tag1
				 ,n.Tag2
				 ,n.Tag3
				 ,n.Tag4
				 --,n.ExtendedMaturityScenario1
				--,n.ExtendedMaturityScenario2
				--,n.ExtendedMaturityScenario3
				,n.ActualPayoffDate
				,n.UnusedFeeThresholdBalance 
                ,n.UnusedFeePaymentFrequency
				,n.NoteTransferDate
				 ,lSelectedMaturityDateScenario.Name as SelectedMaturityDateScenarioText
				 ,n.ExtendedMaturityCurrent
				  FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID	
				inner join cre.Deal d on n.DealId = d.DealId
				left join Core.Lookup l ON n.RateType=l.LookupID						
				left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID
				left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID				
				left join Core.Lookup lSelectedMaturityDateScenario on n.SelectedMaturityDateScenario =lSelectedMaturityDateScenario.LookupID
				Left JOin(
					Select n.noteid,mat.MaturityDate as InitialMaturityDate
					from [CORE].Maturity mat  
					INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
					INNER JOIN   
					(          
						Select   
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
						where EventTypeID = 11  and eve.StatusID = 1
						and acc.IsDeleted = 0  
						and n.dealid = @DealId
						GROUP BY n.Account_AccountID,EventTypeID    
					) sEvent    
					ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
					where mat.MaturityType = 708 and mat.Approved = 3
					and n.dealid = @DealId

			)tblInitialMaturity on tblInitialMaturity.noteid = n.noteid
  
			  where n.DealID=@DealId and a.IsDeleted = 0
			    ORDER BY n.UpdatedDate DESC
				  OFFSET (@PgeIndex - 1)*@PageSize ROWS
				  FETCH NEXT @PageSize ROWS ONLY;
            
			  SELECT @TotalCount = COUNT(NoteID) FROM CRE.Note where DealID=@DealId;
			
	 END
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
