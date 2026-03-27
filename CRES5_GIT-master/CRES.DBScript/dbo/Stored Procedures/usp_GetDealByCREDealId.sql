-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_GetDealByCREDealId] --'18-0866'
(
	@CREDealId varchar(50)
)
AS

 BEGIN
 	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	Declare @MinAccrualFrequency int = (SELECT min(AccrualFrequency) from CRE.Note n
										left join cre.deal d on d.DealID = n.DealID
										where d.CREDealID = @CREDealId);
	Declare @AllowFundingFlag bit = (SELECT [Value] from [App].[AppConfig] where [key]='AllowFundingDevData'); 									
 SELECT d.DealID
		,DealName
		,DealType
		,l1.name DealTypeText
		,LoanProgram     
		,l2.name LoanProgramText
		,LoanPurpose
		,l3.name LoanPurposeText
		,Status
		,l4.name StatusText
		,AppReceived  
		,EstClosingDate 
		, BorrowerRequest
		,l5.Name BorrowerRequestText
		,RecommendedLoan
		,TotalFutureFunding
		,Source
		,l6.Name SourceText
		,BrokerageFirm
		,BrokerageContact
		,Sponsor
		,Principal
		,NetWorth
		,Liquidity
		,ClientDealID
		,CREDealID
		,d.TotalCommitment
		,d.AdjustedTotalCommitment
		,d.AggregatedTotal
		,d.AssetManagerComment
		,d.LinkedDealID
		,d.CreatedBy
		,d.CreatedDate
		,d.UpdatedBy
		,d.UpdatedDate
		,d.DealComment
		,d.AllowSizerUpload
		,l7.Name as AllowSizerUploadText
		,(select  top 1 u.[Login]  from CRE.DealFunding  df left join App.[User]  u  on u.UserID =  df.UpdatedBy) as LastUpdatedByFF
		,(Select Max(df.UpdatedDate) from [CRE].[DealFunding] df where df.DealID = d.DealID) as LastUpdatedFF	
		,d.DealGroupID
		,d.EnableAutoSpread

		,d.AmortizationMethod 
		,lAmortizationMethod.Name as AmortizationMethodText
		,d.ReduceAmortizationForCurtailments 
		,lReduceAmortizationForCurtailments.Name as ReduceAmortizationForCurtailmentsText
		,d.BusinessDayAdjustmentForAmort 
		,lBusinessDayAdjustmentForAmort.Name as BusinessDayAdjustmentForAmortText
		,d.NoteDistributionMethod 
		,lNoteDistributionMethod.Name as NoteDistributionMethodText
		,d.PeriodicStraightLineAmortOverride
		,d.FixedPeriodicPayment
		,d.EquityAmount
		,d.RemainingAmount
		,d.EnableAutoSpreadRepayments
		,d.AutoUpdateFromUnderwriting
		,d.ExpectedFullRepaymentDate
		,d.RepaymentAutoSpreadMethodID
		,lRepaymentAutoSpreadMethod.Name as RepaymentAutoSpreadMethodText
		,d.RepaymentStartDate
		,d.EarliestPossibleRepaymentDate
		,d.Blockoutperiod
		,d.PossibleRepaymentdayofthemonth
		,d.Repaymentallocationfrequency
		,d.AutoPrepayEffectiveDate
		,d.LatestPossibleRepaymentDate
		--,d.KnownFullPayoffDate
		,@MinAccrualFrequency as MinAccrualFrequency
		,@AllowFundingFlag as AllowFundingFlag
		,d.DealLevelMaturity
		,d.EnableAutoDistributePrincipalWriteoff
		,d.PrepaymentGroupSize
		,d.PrepaymentAllocationMethod
		,b.Bookmark
  FROM CRE.Deal d
    Left Join Core.Lookup l1 on d.DealType=l1.LookupID
    Left Join Core.Lookup l2 on d.LoanProgram=l2.LookupID
	Left Join Core.Lookup l3 on d.LoanPurpose=l3.LookupID
	Left Join Core.Lookup l4 on d.Status=l4.LookupID
	Left Join Core.Lookup l5 on d.BorrowerRequest=l5.LookupID
	Left Join Core.Lookup l6 on d.Source=l6.LookupID
	Left Join Core.Lookup l7 on d.AllowSizerUpload=l7.LookupID
	Left Join Core.Lookup lAmortizationMethod on d.AmortizationMethod=lAmortizationMethod.LookupID
	Left Join Core.Lookup lReduceAmortizationForCurtailments on d.ReduceAmortizationForCurtailments=lReduceAmortizationForCurtailments.LookupID
	Left Join Core.Lookup lBusinessDayAdjustmentForAmort on d.BusinessDayAdjustmentForAmort=lBusinessDayAdjustmentForAmort.LookupID
	Left Join Core.Lookup lNoteDistributionMethod on d.NoteDistributionMethod=lNoteDistributionMethod.LookupID
	Left Join Core.Lookup lRepaymentAutoSpreadMethod on d.RepaymentAutoSpreadMethodID = lRepaymentAutoSpreadMethod.Lookupid
	Left Join(
	SELECT 
	dd.DealID,
	CASE
		WHEN b.AccountID IS NOT NULL THEN 'Pin' 
		ELSE 'Unpin'
	END AS Bookmark
	FROM [CRE].[BookMark] b        
		left join [CRE].[Deal] dd on dd.AccountID=b.AccountID        
		WHERE dd.CREDealID = @CREDealId   
	)b ON b.DealID = d.DealID 

	where d.CREDealID=@CREDealId and d.IsDeleted = 0

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
GO

