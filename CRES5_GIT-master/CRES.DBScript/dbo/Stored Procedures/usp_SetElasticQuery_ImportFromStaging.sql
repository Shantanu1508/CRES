
CREATE PROCEDURE [dbo].[usp_SetElasticQuery_ImportFromStaging]  
AS  
BEGIN  

Print('Elastic query set up for: Import cres staging data in cres integration')
IF(1=1)
Begin
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Account')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Account]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Note')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Note]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_TransactionEntry')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_TransactionEntry]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_NotePeriodicCalc')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_NotePeriodicCalc]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Event')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Event]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_FundingSchedule')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_FundingSchedule]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_DealFunding')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_DealFunding]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Deal')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Deal] 
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Analysis')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Analysis]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Client')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Client]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Fund')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Fund]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_Maturity')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_Maturity]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_PIKSchedule')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_PIKSchedule]
IF EXISTS(select name from sys.external_tables where name = 'Ex_Staging_LatestNoteFunding')
	DROP EXTERNAL TABLE [dbo].[Ex_Staging_LatestNoteFunding]

IF EXISTS(select [name] from sys.external_data_sources where name = 'RemoteReferenceCRESStaging')
	Drop EXTERNAL DATA SOURCE RemoteReferenceCRESStaging 
IF EXISTS(select [name] from sys.database_scoped_credentials where name = 'CredentialCRESStaging')
	Drop DATABASE SCOPED CREDENTIAL CredentialCRESStaging



--CREATE DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL CredentialCRESStaging  WITH IDENTITY = 'Cres4_staging',  SECRET = 'h9vWuP)[WEhu})S'

--CREATE EXTERNAL DATA SOURCE
Create EXTERNAL DATA SOURCE RemoteReferenceCRESStaging
WITH 
( 
    TYPE=RDBMS, 
    LOCATION='tcp:b0xesubcki1.database.windows.net,1433', 
    DATABASE_NAME='Cres4_staging', 
    CREDENTIAL= CredentialCRESStaging 
); 



-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Analysis] (
	
	AnalysisID uniqueidentifier  NOT NULL,
	[Name] varchar(256)  NULL,
	StatusID int  NULL,
	Description varchar(256)   NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ScenarioColor] [nvarchar](256) NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'Core',
	   Object_Name = 'Analysis'
);

CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Account] (
	[AccountID] [uniqueidentifier] NOT NULL,
	[AccountTypeID] [int] NULL,
	[StatusID] [int] NULL,
	[Name] [varchar](256) NULL,	
	[BaseCurrencyID] [int] NULL,
	[PayFrequency] [int] NULL,
	[ClientNoteID] [nvarchar](256) NULL,	
	[IsDeleted] [bit] NULL
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'Account'
);


-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Note] (
	--[NoteID] [uniqueidentifier] NOT NULL,
	--[Account_AccountID] [uniqueidentifier] NOT NULL,
	--[DealID] [uniqueidentifier] NOT NULL,
	--[CRENoteID] [nvarchar](256) NULL,
	--[ClientNoteID] [nvarchar](256) NULL,
	NoteID	uniqueidentifier  NOT NULL,
	Account_AccountID	uniqueidentifier 	   NOT NULL,
	DealID	uniqueidentifier 	   NOT NULL,
	CRENoteID	nvarchar(256)	    NULL,
	ClientNoteID	nvarchar(256)	    NULL,
	Comments	nvarchar(256)	    NULL,
	InitialInterestAccrualEndDate	date	    NULL,
	AccrualFrequency	int	    NULL,
	DeterminationDateLeadDays	int	    NULL,
	DeterminationDateReferenceDayoftheMonth	int	    NULL,
	DeterminationDateInterestAccrualPeriod	int	    NULL,
	DeterminationDateHolidayList	Int	    NULL,
	FirstPaymentDate	date	    NULL,
	InitialMonthEndPMTDateBiWeekly	date	    NULL,
	PaymentDateBusinessDayLag	int	    NULL,
	IOTerm	int	    NULL,
	AmortTerm	int	    NULL,
	PIKSeparateCompounding	int	    NULL,
	MonthlyDSOverridewhenAmortizing	decimal(28,15)	    NULL,
	AccrualPeriodPaymentDayWhenNotEOMonth	int	    NULL,
	FirstPeriodInterestPaymentOverride	decimal(28,15)	    NULL,
	FirstPeriodPrincipalPaymentOverride	decimal(28,15)	    NULL,
	FinalInterestAccrualEndDateOverride	date	    NULL,
	AmortType	int	    NULL,
	RateType	Int	    NULL,
	ReAmortizeMonthly	Int	    NULL,
	ReAmortizeatPMTReset	Int	    NULL,
	StubPaidInArrears	Int	    NULL,
	RelativePaymentMonth	Int	    NULL,
	SettleWithAccrualFlag	Int	    NULL,
	InterestDueAtMaturity	int	    NULL,
	RateIndexResetFreq	decimal(28,15)	    NULL,
	FirstRateIndexResetDate	date	    NULL,
	LoanPurchase	Int	    NULL,
	AmortIntCalcDayCount	int	    NULL,
	StubPaidinAdvanceYN	Int	    NULL,
	FullPeriodInterestDueatMaturity	Int	    NULL,
	ProspectiveAccountingMode	Int	    NULL,
	IsCapitalized	Int	    NULL,
	SelectedMaturityDateScenario	int	    NULL,
	SelectedMaturityDate	date	    NULL,
	InitialMaturityDate	date	    NULL,
	ExpectedMaturityDate	date	    NULL,

	OpenPrepaymentDate	date	    NULL,
	CashflowEngineID	int	    NULL,
	LoanType	Int	    NULL,
	Classification	Int	    NULL,
	SubClassification	Int	    NULL,
	GAAPDesignation	Int	    NULL,
	PortfolioID	int	    NULL,
	GeographicLocation	Int	    NULL,
	PropertyType	Int	    NULL,
	RatingAgency	int	    NULL,
	RiskRating	int	    NULL,
	PurchasePrice	decimal(28,15)	    NULL,
	FutureFeesUsedforLevelYeild	decimal(28,15)	    NULL,
	TotalToBeAmortized	decimal(28,15)	    NULL,
	StubPeriodInterest	decimal(28,15)	    NULL,
	WDPAssetMultiple	decimal(28,15)	    NULL,
	WDPEquityMultiple	decimal(28,15)	    NULL,
	PurchaseBalance	decimal(28,15)	    NULL,
	DaysofAccrued	int	    NULL,
	InterestRate	decimal(28,15)	    NULL,
	PurchasedInterestCalc	decimal(28,15)	    NULL,
	ModelFinancingDrawsForFutureFundings	int	    NULL,
	NumberOfBusinessDaysLagForFinancingDraw	int	    NULL,
	FinancingFacilityID	uniqueidentifier	    NULL,
	FinancingInitialMaturityDate	date	    NULL,
	FinancingExtendedMaturityDate	date	    NULL,
	FinancingPayFrequency	Int	    NULL,
	FinancingInterestPaymentDay	int	    NULL,
	ClosingDate	date	    NULL,
	InitialFundingAmount	decimal(28,15)	    NULL,
	Discount	decimal(28,15)	    NULL,
	OriginationFee	decimal(28,15)	    NULL,
	CapitalizedClosingCosts	decimal(28,15)	    NULL,
	PurchaseDate	date	    NULL,
	PurchaseAccruedFromDate	decimal(28,15)	    NULL,
	PurchasedInterestOverride	decimal(28,15)	    NULL,
	DiscountRate decimal(28,15)	    NULL,
	ValuationDate date	    NULL,
	FairValue decimal(28,15)	    NULL,
	DiscountRatePlus decimal(28,15)	    NULL,
	FairValuePlus decimal(28,15)	    NULL,
	DiscountRateMinus decimal(28,15)	    NULL,
	FairValueMinus decimal(28,15)	    NULL,
	InitialIndexValueOverride decimal(28,15)	    NULL,
	IncludeServicingPaymentOverrideinLevelYield int null,
	OngoingAnnualizedServicingFee	decimal(28,15)	    NULL,
	IndexRoundingRule int  NULL,
	RoundingMethod int NULL,
	StubInterestPaidonFutureAdvances int NULL,
	TaxAmortCheck [nvarchar](256) NULL,
	PIKWoCompCheck [nvarchar](256) NULL,
	GAAPAmortCheck [nvarchar](256) NULL,
	StubIntOverride decimal(28,15)	    NULL,
	PurchasedIntOverride decimal(28,15)	    NULL,
	ExitFeeFreePrepayAmt decimal(28,15)	    NULL,
	ExitFeeBaseAmountOverride decimal(28,15)	    NULL,
	ExitFeeAmortCheck int	    NULL,
	FixedAmortScheduleCheck int null,				
	GeneratedBy      	Int,
	--PayRule
	UseRuletoDetermineNoteFunding int null,
	NoteFundingRule int null,
	FundingPriority int null,
	NoteBalanceCap decimal(28,15)	 NULL,
	RepaymentPriority int null,
	NoofdaysrelPaymentDaterollnextpaymentcycle int null,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL, 
	UseIndexOverrides bit null,
	IndexNameID int null,
	ServicerID nvarchar(256)	    NULL,
	TotalCommitment decimal(28,15)	 NULL,
	ClientName nvarchar(256) null ,
	Portfolio nvarchar(256) null ,
	Tag1 nvarchar(256) null ,
	Tag2 nvarchar(256) null ,
	Tag3 nvarchar(256) null ,
	Tag4 nvarchar(256) null ,
	ExtendedMaturityScenario1	date	    NULL,
	ExtendedMaturityScenario2	date	    NULL,
	ExtendedMaturityScenario3	date	    NULL,
	ActualPayoffDate	date	    NULL,
	FullyExtendedMaturityDate 	date	    NULL,
	TotalCommitmentExtensionFeeisBasedOn decimal(28,15)	 NULL,
	LienPriority  int ,
	UnusedFeeThresholdBalance  decimal(28,15)	 NULL,
	UnusedFeePaymentFrequency int null,
	lienposition int null ,
	[priority] int null,
	Servicer int null,
	FullInterestAtPPayoff int ,
	NoteRule nvarchar(2000) null,

	ClientID int null,
	FinancingSourceID int null,
	DebtTypeID int null,
	BillingNotesID int null,
	CapStack  int null,
	FundID  int null,
	PoolId int null,

	--Added column for wells
	TaxVendorLoanNumber	nvarchar(256)	null,
	TAXBILLSTATUS	nvarchar(256)	null,
	CURRTAXCONSTANT	int	null,
	InsuranceBillStatusCode	nvarchar(256)	null,
	RESERVETYPE	nvarchar(256)	null,
	ResDescOwnName	nvarchar(256)	null,
	MONTHLYPAYMENTAMT	int	null,
	IORPLANCODE	nvarchar(256)	null,
	NoDaysbeforeAssessment	decimal(28,15)	null,
	LateChargeRateorFee	decimal(28,15)	null,
	DefaultOfDaysto	decimal(28,15)	null,
	OddDaysIntAmount decimal(28,15) null,
	InterestRateFloor decimal(28,15) null,
	InterestRateCeiling decimal(28,15) null,
	Dayslookback nvarchar(256)  NULL,
	CurrentBls decimal(28,15) null,
	WF_Companyname	nvarchar(256)	null,
	WF_FirstName	nvarchar(256)	null,
	WF_Lastname	nvarchar(256)	null,
	WF_StreetName	nvarchar(256)	null,
	WF_ZipCodePostal	nvarchar(256)	null,
	WF_PayeeName	nvarchar(256)	null,
	WF_TelephoneNumber1	nvarchar(256)	null,
	WF_FederalID1	nvarchar(max)	null,
	WF_City	nvarchar(256)	null,
	WF_State	nvarchar(256)	null,
	StubInterestRateOverride decimal(28,15) null,
	LiborDataAsofDate datetime	    NULL,
	ServicerNameID int null,
	BusinessdaylafrelativetoPMTDate int null,
	DayoftheMonth int null,
	InterestCalculationRuleForPaydowns int null,
	PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate int null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Note'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Event] (
	EventID uniqueidentifier   NULL ,
	AccountID uniqueidentifier   NULL,
	Date date   NULL,
	EventTypeID int   NULL,
	EffectiveStartDate date   NULL,
	EffectiveEndDate date   NULL,
	SingleEventValue decimal(28,15)   NULL,
	[StatusID] int null,
	CreatedBy      	nvarchar(256)  NULL,
	CreatedDate      	datetime NULL,
	UpdatedBy      	nvarchar(256) NULL,
	UpdatedDate      	datetime
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'EVENT'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_FundingSchedule] (
	FundingScheduleID	uniqueidentifier   NULL,
	EventId	uniqueidentifier  null,
	Date	date null,
	Value	decimal(28,15)null,
	PurposeID int null,
	Applied bit null,
	CreatedBy  nvarchar(256) null,
	CreatedDate   datetime null,
	UpdatedBy   nvarchar(256) null,
	UpdatedDate    datetime null,
	DrawFundingId nvarchar(256) null,
	Comments nvarchar(max) null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'FundingSchedule'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_DealFunding] (
	DealFundingID uniqueidentifier   NULL ,
	DealID uniqueidentifier   NULL,
	[Date] date null,
	Amount decimal(28,15) null,
	Comment nvarchar(max),
	PurposeID int null,
	Applied bit null,
	Issaved bit null ,
	CreatedBy      	nvarchar(256)	    NULL,
	CreatedDate      	datetime	    NULL,
	UpdatedBy      	nvarchar(256)	    NULL,
	UpdatedDate      	datetime	    NULL,
	DrawFundingId nvarchar(256) null

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'DealFunding'
);
-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Deal] (
DealID uniqueidentifier   NULL ,
DealName      	nvarchar(256),
CREDealID	nvarchar(256),
SourceDealID uniqueidentifier,
DealType      	Int,
LoanProgram	Int,
LoanPurpose      	Int,
Status      	Int,
AppReceived      	date,
EstClosingDate      	date,
BorrowerRequest      	nvarchar(256),
RecommendedLoan      	decimal(28,15),
TotalFutureFunding      	decimal(28,15),
Source      	Int,
BrokerageFirm      	nvarchar(256),
BrokerageContact      	nvarchar(256),
Sponsor      	nvarchar(256),
Principal      	nvarchar(256),
NetWorth      	decimal(28,15),
Liquidity      	decimal(28,15),
ClientDealID	nvarchar(256),
GeneratedBy      	Int,
TotalCommitment decimal (28,15),
AdjustedTotalCommitment   decimal (28,15),
AggregatedTotal    decimal (28,15),
AssetManagerComment nvarchar(max),
[DealComment] [nvarchar](max) NULL,
AssetManager nvarchar(256),
DealCity nvarchar(256),
DealState nvarchar(256),
DealPropertyType nvarchar(256),
FullyExtMaturityDate date,
UnderwritingStatus int null,
LinkedDealID  nvarchar(256) null,
IsDeleted bit null ,
AllowSizerUpload int null,
CreatedBy      	nvarchar(256),
CreatedDate      	datetime,
UpdatedBy      	nvarchar(256),
UpdatedDate      	datetime,
AMUserID uniqueidentifier null,
DealRule nvarchar(2000) null,
AMTeamLeadUserID uniqueidentifier null,
AMSecondUserID uniqueidentifier null
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Deal'
);

-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_TransactionEntry] (
	[TransactionEntryID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NULL,
	[Date] [datetime] NULL,
	[Amount] [decimal](28, 15) NULL,
	[Type] nvarchar(MAX) null,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,

	AnalysisID uniqueidentifier null,
	FeeName nvarchar(256) null,
	StrCreatedBy 	nvarchar(256) NULL,
	GeneratedBy 	nvarchar(256) NULL

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'TransactionEntry'
);
-----------------------------------------------
CREATE EXTERNAL TABLE [dbo].[Ex_Staging_NotePeriodicCalc] (
[NotePeriodicCalcID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NULL,
	[PeriodEndDate] [date] NULL,
	[Month] [int] NULL,
	[ActualCashFlows] [decimal](28, 15) NULL,
	[GAAPCashFlows] [decimal](28, 15) NULL,
	[EndingGAAPBookValue] [decimal](28, 15) NULL,
	[TotalGAAPIncomeforthePeriod] [decimal](28, 15) NULL,
	[InterestAccrualforthePeriod] [decimal](28, 15) NULL,
	[PIKInterestAccrualforthePeriod] [decimal](28, 15) NULL,
	[TotalAmortAccrualForPeriod] [decimal](28, 15) NULL,
	[AccumulatedAmort] [decimal](28, 15) NULL,
	[BeginningBalance] [decimal](28, 15) NULL,
	[TotalFutureAdvancesForThePeriod] [decimal](28, 15) NULL,
	[TotalDiscretionaryCurtailmentsforthePeriod] [decimal](28, 15) NULL,
	[InterestPaidOnPaymentDate] [decimal](28, 15) NULL,
	[TotalCouponStrippedforthePeriod] [decimal](28, 15) NULL,
	[CouponStrippedonPaymentDate] [decimal](28, 15) NULL,
	[ScheduledPrincipal] [decimal](28, 15) NULL,
	[PrincipalPaid] [decimal](28, 15) NULL,
	[BalloonPayment] [decimal](28, 15) NULL,
	[EndingBalance] [decimal](28, 15) NULL,
	[ExitFeeIncludedInLevelYield] [decimal](28, 15) NULL,
	[ExitFeeExcludedFromLevelYield] [decimal](28, 15) NULL,
	[AdditionalFeesIncludedInLevelYield] [decimal](28, 15) NULL,
	[AdditionalFeesExcludedFromLevelYield] [decimal](28, 15) NULL,
	[OriginationFeeStripping] [decimal](28, 15) NULL,
	[ExitFeeStrippingIncldinLevelYield] [decimal](28, 15) NULL,
	[ExitFeeStrippingExcldfromLevelYield] [decimal](28, 15) NULL,
	[AddlFeesStrippingIncldinLevelYield] [decimal](28, 15) NULL,
	[AddlFeesStrippingExcldfromLevelYield] [decimal](28, 15) NULL,
	[EndOfPeriodWAL] [decimal](28, 15) NULL,
	[PIKInterestFromPIKSourceNote] [decimal](28, 15) NULL,
	[PIKInterestTransferredToRelatedNote] [decimal](28, 15) NULL,
	[PIKInterestForThePeriod] [decimal](28, 15) NULL,
	[BeginningPIKBalanceNotInsideLoanBalance] [decimal](28, 15) NULL,
	[PIKInterestForPeriodNotInsideLoanBalance] [decimal](28, 15) NULL,
	[PIKBalanceBalloonPayment] [decimal](28, 15) NULL,
	[EndingPIKBalanceNotInsideLoanBalance] [decimal](28, 15) NULL,
	[CostBasis] [decimal](28, 15) NULL,
	[PreCapBasis] [decimal](28, 15) NULL,
	[BasisCap] [decimal](28, 15) NULL,
	[AmortAccrualLevelYield] [decimal](28, 15) NULL,
	[ScheduledPrincipalShortfall] [decimal](28, 15) NULL,
	[PrincipalShortfall] [decimal](28, 15) NULL,
	[PrincipalLoss] [decimal](28, 15) NULL,
	[InterestForPeriodShortfall] [decimal](28, 15) NULL,
	[InterestPaidOnPMTDateShortfall] [decimal](28, 15) NULL,
	[CumulativeInterestPaidOnPMTDateShortfall] [decimal](28, 15) NULL,
	[InterestShortfallLoss] [decimal](28, 15) NULL,
	[InterestShortfallRecovery] [decimal](28, 15) NULL,
	[BeginningFinancingBalance] [decimal](28, 15) NULL,
	[TotalFinancingDrawsCurtailmentsForPeriod] [decimal](28, 15) NULL,
	[FinancingBalloon] [decimal](28, 15) NULL,
	[EndingFinancingBalance] [decimal](28, 15) NULL,
	[FinancingInterestPaid] [decimal](28, 15) NULL,
	[FinancingFeesPaid] [decimal](28, 15) NULL,
	[PeriodLeveredYield] [decimal](28, 15) NULL,
	[OrigFeeAccrual] [decimal](28, 15) NULL,
	[DiscountPremiumAccrual] [decimal](28, 15) NULL,
	[ExitFeeAccrual] [decimal](28, 15) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[AllInCouponRate] [decimal](28, 15) NULL,

	[CleanCost] [decimal](28, 15) NULL,	
	[GrossDeferredFees] [decimal](28, 15) NULL,
	[DeferredFeesReceivable] [decimal](28, 15) NULL,
	[CleanCostPrice] [decimal](28, 15) NULL,
	[AmortizedCostPrice] [decimal](28, 15) NULL,
	[AdditionalFeeAccrual] [decimal](28, 15) NULL,
	[CapitalizedCostAccrual] [decimal](28, 15) NULL,
	[DailySpreadInterestbeforeStrippingRule] [decimal](28, 15) NULL,
	[DailyLiborInterestbeforeStrippingRule] [decimal](28, 15) NULL,
	[ReversalofPriorInterestAccrual] [decimal](28, 15) NULL,
	[InterestReceivedinCurrentPeriod] [decimal](28, 15) NULL,
	[CurrentPeriodInterestAccrual] [decimal](28, 15) NULL,
	[TotalGAAPInterestFortheCurrentPeriod] [decimal](28, 15) NULL,

	
	InvestmentBasis decimal(28,15) null,
	CurrentPeriodInterestAccrualPeriodEnddate  [decimal](28, 15) NULL, 
	LIBORPercentage  [decimal](28, 15) NULL,
	SpreadPercentage  [decimal](28, 15) NULL,
	AnalysisID UNIQUEIDENTIFIER null,
	FeeStrippedforthePeriod [decimal](28, 15) NULL,
	PIKInterestPercentage [decimal](28, 15) NULL,
	AmortizedCost [decimal](28, 15) NULL,
	InterestSuspenseAccountActivityforthePeriod decimal(28,15) null,
	InterestSuspenseAccountBalance  decimal(28,15) null


)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging ,
	   Schema_Name = 'CRE',
	   Object_Name = 'NotePeriodicCalc'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Client] (
	
	ClientID [int]  NULL,
ClientName nvarchar(256)	    NULL,
[Status] int null,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL,
EmailId      	nvarchar(256)	    NULL

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Client'
);



CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Fund] (
	
FundID [int]  NULL,
FundName nvarchar(256)	    NULL,
ClientID [int]  NULL,
[Pool] nvarchar(256)	    NULL,
CreatedBy      	nvarchar(256)	    NULL,
CreatedDate      	datetime	    NULL,
UpdatedBy      	nvarchar(256)	    NULL,
UpdatedDate      	datetime	    NULL


)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'Fund'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_Maturity] (
	
MaturityID	uniqueidentifier  NOT NULL ,
EventId	uniqueidentifier not null,
SelectedMaturityDate date   NULL,
 
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null



)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'Maturity'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_PIKSchedule] (
PIKScheduleID uniqueidentifier  NOT NULL ,
EventID uniqueidentifier  NOT NULL,
SourceAccountID uniqueidentifier   NULL,
TargetAccountID uniqueidentifier   NULL,
AdditionalIntRate decimal(28,15)   NULL,
AdditionalSpread decimal(28,15)   NULL,
IndexFloor decimal(28,15)   NULL,
IntCompoundingRate decimal(28,15)   NULL,
IntCompoundingSpread decimal(28,15)   NULL,
StartDate date   NULL,
EndDate date   NULL,
IntCapAmt decimal(28,15)   NULL,
PurBal decimal(28,15)   NULL,
AccCapBal decimal(28,15)   NULL,
[CreatedBy] [nvarchar](256) NULL,
[CreatedDate] [datetime] NULL,
[UpdatedBy] [nvarchar](256) NULL,
[UpdatedDate] [datetime] NULL

)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CORE',
	   Object_Name = 'PIKSchedule'
);


CREATE EXTERNAL TABLE [dbo].[Ex_Staging_LatestNoteFunding] (
NoteID UNIQUEIDENTIFIER   NULL,
CRENoteID nvarchar(256) null,
TransactionDate Date null,
Amount decimal(28,15)  NULL,
WireConfirm bit null,
PurposeBI nvarchar(256) null,
DrawFundingID nvarchar(256) null,
Comments nvarchar(max) null,
CreatedBy 	nvarchar(256) NULL,
CreatedDate 	datetime ,
UpdatedBy 	nvarchar(256) NULL,
UpdatedDate 	datetime 
)
WITH 
( 
       DATA_SOURCE = RemoteReferenceCRESStaging,
	   Schema_Name = 'CRE',
	   Object_Name = 'LatestNoteFunding'
);


END


END