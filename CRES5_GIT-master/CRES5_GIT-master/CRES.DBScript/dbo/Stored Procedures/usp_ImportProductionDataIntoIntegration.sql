
CREATE PROCEDURE [dbo].[usp_ImportProductionDataIntoIntegration]
AS
BEGIN
    SET NOCOUNT ON;
	
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare @analysiID UNIQUEIDENTIFIER = (Select analysisID from  [dbo].[Ex_Prod_Analysis] where [name] = 'Default')

truncate table [DW].[Prod_Cashflow]
truncate table [DW].[Prod_TransactionEntry]
truncate table [DW].[Prod_NoteFunding]
Truncate table [DW].[Prod_DealFundingSchdule]



INSERT INTO [DW].[Prod_Cashflow]
           ([NotePeriodicCalcID]
           ,[NoteID]
           ,[CRENoteID]
           ,[PeriodEndDate]
           ,[Month]
           ,[ActualCashFlows]
           ,[GAAPCashFlows]
           ,[EndingGAAPBookValue]
           ,[TotalGAAPIncomeforthePeriod]
           ,[InterestAccrualforthePeriod]
           ,[PIKInterestAccrualforthePeriod]
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
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[AllInCouponRate]
           ,[CleanCost]
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
		   ,InvestmentBasis
			,CurrentPeriodInterestAccrualPeriodEnddate
			,LIBORPercentage
			,SpreadPercentage
			,AnalysisID
			,FeeStrippedforthePeriod
			,PIKInterestPercentage
			,AmortizedCost
			,InterestSuspenseAccountActivityforthePeriod
			,InterestSuspenseAccountBalance)
SELECT [NotePeriodicCalcID]
      ,cf.[NoteID]
      ,n.[CRENoteID]
      ,[PeriodEndDate]
      ,[Month]
      ,[ActualCashFlows]
      ,[GAAPCashFlows]
      ,[EndingGAAPBookValue]
      ,[TotalGAAPIncomeforthePeriod]
      ,[InterestAccrualforthePeriod]
      ,[PIKInterestAccrualforthePeriod]
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
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[AllInCouponRate]
      ,[CleanCost]
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
	  ,InvestmentBasis
			,CurrentPeriodInterestAccrualPeriodEnddate
			,LIBORPercentage
			,SpreadPercentage
			,AnalysisID
			,FeeStrippedforthePeriod
			,PIKInterestPercentage
			,AmortizedCost
			,InterestSuspenseAccountActivityforthePeriod
			,InterestSuspenseAccountBalance
  FROM [dbo].[Ex_Prod_NotePeriodicCalc] cf
  Inner Join [dbo].[Ex_Prod_Note] n on n.noteid = cf.noteid
    
	--Where cf.AnalysisID = @analysiID

PRINT('Prod_Cashflow: '+CAST(@@ROWCOUNT as nvarchar(256)))
 ---------------------------------------

  INSERT INTO [DW].[Prod_TransactionEntry]
           ([TransactionEntryID]
           ,[NoteID]
           ,[CRENoteID]
           ,[Date]
           ,[Amount]
           ,[Type]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
			,AnalysisID
			,FeeName
			,StrCreatedBy
			,GeneratedBy
			)

SELECT [TransactionEntryID]
      ,tr.[NoteID]
      ,n.[CRENoteID]
      ,tr.[Date]
      ,tr.[Amount]
      ,tr.[Type]
      ,tr.[CreatedBy]
      ,tr.[CreatedDate]
      ,tr.[UpdatedBy]
      ,tr.[UpdatedDate]
	  ,tr.AnalysisID
	,tr.FeeName
	,tr.StrCreatedBy
	,tr.GeneratedBy
  FROM [dbo].[Ex_Prod_TransactionEntry] tr
  Inner Join [dbo].[Ex_Prod_Note] n on n.noteid = tr.noteid
    
	--Where tr.AnalysisID = @analysiID

 PRINT('Prod_TransactionEntry: '+CAST(@@ROWCOUNT as nvarchar(256)))
---------------------------------------

INSERT INTO [DW].[Prod_NoteFunding]
           ([NoteID]
		   ,[CRENoteID]
           ,[TransactionDate]
           ,[WireConfirm]
           ,[PurposeBI]
           ,[Amount]
           ,[DrawFundingID]
           ,[Comments]
           ,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy] 
			,[UpdatedDate] )

Select  
n.NoteID
,n.crenoteid as crenoteid
,fs.[Date] as [TransactionDate]
,fs.Applied as [WireConfirm]
,LPurposeID.Name as [PurposeBI]
,fs.Value as [Amount]
,fs.DrawFundingId as [DrawFundingID]
,fs.Comments as [Comments]
,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy] 
,fs.[UpdatedDate] 
from [dbo].Ex_Prod_FundingSchedule fs
INNER JOIN [dbo].Ex_Prod_Event e on e.EventID = fs.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [dbo].Ex_Prod_Account ac where ac.AccountID = ns.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [dbo].Ex_Prod_Event eve
					INNER JOIN [dbo].Ex_Prod_Note ns ON ns.Account_AccountID = eve.AccountID
					INNER JOIN [dbo].Ex_Prod_Account acc ON acc.AccountID = ns.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					--and ns.NoteID = @NoteId  
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [Core].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
INNER JOIN [dbo].Ex_Prod_Account acc ON acc.AccountID = e.AccountID
INNER JOIN [dbo].Ex_Prod_Note n ON n.Account_AccountID = acc.AccountID
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0

 PRINT('Prod_NoteFunding: '+CAST(@@ROWCOUNT as nvarchar(256)))
---------------------------------------


INSERT INTO [DW].[Prod_DealFundingSchdule]
	([DealFundingID]
	,[DealID]
	,[CREDealID]
	,[Date]
	,[Amount] 
	,[PurposeBI]
	,[WireConfirm]
	,[Comment]
	,[DrawFundingId]	  
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])
Select
d.[DealFundingID],
d.[DealID],
deal.[CREDealID],
d.[Date],
d.[Amount],
lPurpose.Name,
d.[Applied],
d.[Comment],
d.[DrawFundingId],
d.[CreatedBy],
d.[CreatedDate],
d.[UpdatedBy],
d.[UpdatedDate]
FROM EX_Prod_DealFunding d
inner join EX_Prod_Deal deal on d.DealID = deal.DealID
LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50

 PRINT('Prod_DealFundingSchdule: '+CAST(@@ROWCOUNT as nvarchar(256)))


SET TRANSACTION ISOLATION LEVEL READ COMMITTED



END


