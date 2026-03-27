CREATE PROCEDURE [VAL].[usp_GetSECMastHolding]  --'21-2086'
	@MarkedDate Date,
	@CREDealid nvarchar(256) = null
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
   	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

  
  
	SELECT 
		 null as InvestorID
		,null as ManagerName
		,null as MortgageType
		,null as AsofDate
		,sec.Ticker
		,CAST(sec.LoanID as Int) as LoanID
		,null as ClientID
		,sec.[Description]
		,null as Currency
		,null as LoanType
		,null as LoanPurpose
		,sec.FinancingSource
		,null as Borrower
		,null as Sponsor
		,null as Guaranteed
		,null as FundID
		,sec.NoteName
		,null as LienPosition
		,sec.[Priority]
		,null as SeniorDebt
		,sec.OriginationDate
		,null as AccruedStartDate
		,null as FirstCouponDate
		,null as MaturityDate
		,null as FixedorFloating
		,null as AmortizationType
		,null as Interestonlyperiod
		,null as ModandRefiDate
		,null as LoanTerm
		,sec.FullyExtendedMaturityDate
		,null as FullyExtendedTerm_mos
		,null as CurrentCouponEffectiveDate
		,null as LastPaymentDate
		,null as NextResetDate
		,null as DaysPastDue
		,null as PaymentFrequency
		,null as DayCount
		,sec.PaymentDay
		,null as IndexName
		,null as IndexRate_Rounded
		,null as Spread
		,sec.InterestRate
		,sec.InitialFunding
		,sec.OriginalAmountofLoan
		,sec.AdjustedCommitment
		,sec.AmountofLoanOutstanding
		,null as ValueofLandandBuildings
		,null as Servicer
		,null as PropertyType
		,null as NumberofProperties
		,null as CrossCollateralization
		,null as CrossCollateralizationIdentifier
		,null as City
		,null as [State]
		,null as PostalCode
		,null as Region
		,null as MSA
		,null as NonConstruction_HardCostUses
		,null as TotalCapStack_includesequity
		,null as NonConstruction
		,null as Construction
		,null as LastAppraisalDate
		,null as LastAppraisalSource
		,null as AsIsValue
		,null as InitialLTV
		,null as AsStabilizedValue
		,null as StabilizedLTV
		,null as AsIsCashFlow
		,null as AsStabCashFlow
		,null as AsIsDSCR
		,null as AsStabDSCR
		,null as InitialDebtYield
		,null as StabilizedDebtYield
		,null as PayRate
		,null as MortgageLoanTrancheType
		,sec.IndexFloor
		,null as RSLIC
		,null as SNCC
		,null as PIIC
		,null as TMR
		,null as HCC
		,null as USSIC
		,null as TMDDL
		,null as HAIH
		,null as TotalParticipationPer
		,null as AccruedPIKBalanceAmount
		,null as RSLICValLBPct
		,null as SNCCValLBPct
		,null as PIICValLBPct
		,null as TMRValLBPct
		,null as HCCValLBPct
		,null as USSICValLBPct
		,null as TMNFValLBPct
		,null as HAIHValLBPct
		,null as TotalParticipationMod2
		,null as FHLBPledged
		,null as NOISecondPriorYear
		,null as NOIPriorYear
		,null as NOI
		,null as TTM
		,null as RollingAverageNOI
		,null as RollingAverageNOIGrid
		,null as LTV
		,null as RBCDSR
		,null as CMRATING
		,null as NOTCHED
		,null as RBCCharge
		,null as StabLTVNumerator
		,null as ASISLTVDENOMINATOR
		,null as UsingRollup
		,null as AsIsLTVNumerator
		,null as ASSTABLTVDENOMINATOR
		,null as asisdebtservice
		,null as asstabdebtservice
	FROM [VAL].[SECMastHolding] sec
	--Inner JOin cre.deal d on d.credealid = sec.Ticker
	where 1 = (CASE WHEN @CREDealid is null THEN 1 WHEN sec.Ticker = @CREDealid THEN 1 ELSE 0 END ) 
	and MarkedDateMasterID =@MarkedDateMasterID



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
