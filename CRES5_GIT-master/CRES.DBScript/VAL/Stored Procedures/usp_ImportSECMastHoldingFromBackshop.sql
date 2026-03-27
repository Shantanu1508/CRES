CREATE PROCEDURE [VAL].[usp_ImportSECMastHoldingFromBackshop] 
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   

IF OBJECT_ID('tempdb..#tblSecMaster') IS NOT NULL         
DROP TABLE #tblSecMaster

CREATE TABLE #tblSecMaster(
InvestorID	int	 ,
InvestorName	nvarchar(256)	 ,
ManagerName	nvarchar(256)	 ,
MortgageType	nvarchar(256)	 ,
AsofDate	nvarchar(256)	 ,
Ticker	nvarchar(256)	 ,
LoanID	nvarchar(256)	 ,
ClientID	nvarchar(256)	 ,
Description	nvarchar(256)	 ,
Currency	nvarchar(256)	 ,
LoanType	nvarchar(256)	 ,
LoanPurpose	nvarchar(256)	 ,
FinancingSource	nvarchar(256)	 ,
Borrower	nvarchar(256)	 ,
Sponsor	nvarchar(MAX)	 ,
Guaranteed	nvarchar(256)	 ,
FundID	nvarchar(256)	 ,
NoteName	nvarchar(256)	 ,
LienPosition	nvarchar(256)	 ,
Priority	int	 ,
SeniorDebt	int	 ,
OriginationDate	nvarchar(256)	 ,
AccruedStartDate	nvarchar(256)	 ,
FirstCouponDate	nvarchar(256)	 ,
MaturityDate	nvarchar(256)	 ,
FixedorFloating	nvarchar(256)	 ,
AmortizationType	nvarchar(256)	 ,
Interestonlyperiod	int	 ,
ModandRefiDate	nvarchar(256)	 ,
LoanTerm	int	 ,
FullyExtendedMaturityDate	nvarchar(256)	 ,
FullyExtendedTerm_mos	int	 ,
CurrentCouponEffectiveDate	nvarchar(256)	 ,
LastPaymentDate	nvarchar(256)	 ,
NextResetDate	nvarchar(256)	 ,
DaysPastDue	int	 ,
PaymentFrequency	nvarchar(256)	 ,
DayCount	nvarchar(256)	 ,
PaymentDay	int	 ,
IndexName	nvarchar(256)	 ,
IndexRate_Rounded	nvarchar(256)	 ,
Spread	nvarchar(256)	 ,
InterestRate	nvarchar(256)	 ,
InitialFunding	nvarchar(256)	 ,
OriginalAmountofLoan	nvarchar(256)	 ,
AdjustedCommitment	nvarchar(256)	 ,
AmountofLoanOutstanding	nvarchar(256)	 ,
ValueofLandandBuildings	nvarchar(256)	 ,
Servicer	nvarchar(256)	 ,
PropertyType	nvarchar(256)	 ,
NumberofProperties	int	 ,
CrossCollateralization	nvarchar(256)	 ,
CrossCollateralizationIdentifier	nvarchar(256)	 ,
City	nvarchar(256)	 ,
State	nvarchar(256)	 ,
PostalCode	nvarchar(max)	 ,
Region	nvarchar(256)	 ,
MSA	nvarchar(256)	 ,
NonConstruction_HardCostUses	nvarchar(256)	 ,
TotalCapStack_includesequity	nvarchar(256)	 ,
NonConstruction	nvarchar(256)	 ,
Construction	nvarchar(256)	 ,
LastAppraisalDate	nvarchar(256)	 ,
LastAppraisalSource	nvarchar(256)	 ,
AsIsValue	nvarchar(256)	 ,
InitialLTV	nvarchar(256)	 ,
AsStabilizedValue	nvarchar(256)	 ,
StabilizedLTV	nvarchar(256)	 ,
AsIsCashFlow	nvarchar(256)	 ,
AsStabCashFlow	nvarchar(256)	 ,
AsIsDSCR	nvarchar(256)	 ,
AsStabDSCR	nvarchar(256)	 ,
InitialDebtYield	nvarchar(256)	 ,
StabilizedDebtYield	nvarchar(256)	 ,
PayRate	nvarchar(256)	 ,
MortgageLoanTrancheType	nvarchar(256)	 ,
IndexFloor	nvarchar(256)	 ,
RSLIC	nvarchar(256)	 ,
SNCC	nvarchar(256)	 ,
PIIC	nvarchar(256)	 ,
TMR	nvarchar(256)	 ,
HCC	nvarchar(256)	 ,
USSIC	nvarchar(256)	 ,
TMDDL	nvarchar(256)	 ,
HAIH	nvarchar(256)	 ,
TotalParticipationPer	nvarchar(256)	 ,
AccruedPIKBalanceAmount	nvarchar(256)	 ,
RSLICValLBPct	nvarchar(256)	 ,
SNCCValLBPct	nvarchar(256)	 ,
PIICValLBPct	nvarchar(256)	 ,
TMRValLBPct	nvarchar(256)	 ,
HCCValLBPct	nvarchar(256)	 ,
USSICValLBPct	nvarchar(256)	 ,
TMNFValLBPct	nvarchar(256)	 ,
HAIHValLBPct	nvarchar(256)	 ,
TotalParticipationMod2	nvarchar(256)	 ,
FHLBPledged	nvarchar(256),--nvarchar(256)	 ,
NOISecondPriorYear	nvarchar(256)	 ,
NOIPriorYear	nvarchar(256)	 ,
NOI	nvarchar(256)	 ,
TTM	nvarchar(256)	 ,
RollingAverageNOI	nvarchar(256)	 ,
RollingAverageNOIGrid	nvarchar(256)	 ,
LTV	nvarchar(256)	 ,
RBCDSR	nvarchar(256)	 ,
CMRATING	nvarchar(256)	 ,
NOTCHED	nvarchar(256)	 ,
RBCCharge	nvarchar(256)	 ,
StabLTVNumerator	nvarchar(256)	 ,
ASISLTVDENOMINATOR	nvarchar(256)	 ,
UsingRollup	nvarchar(256)	 , --nvarchar(256)	 ,
AsIsLTVNumerator	nvarchar(256)	 ,
ASSTABLTVDENOMINATOR	nvarchar(256)	 ,
asisdebtservice	nvarchar(256)	 ,
asstabdebtservice	nvarchar(256)	 ,
ShardName	nvarchar(MAX)	
)


Declare @RptCutOffDate date;
SET @RptCutOffDate = (Select EOMONTH(getdate()))


Declare @query nvarchar(max);
SET @query = N'EXEC acore.spSecMasterHoldings 
@InvestorIDs = ''5|15|7|10|12|8|9|1|6|19|16|14|4|13|2|17'', 
@RptCutOffDate = '''+ Convert(nvarchar(256),@RptCutOffDate,101) +''', 
@OpStmtDate = ''9/30/2022'', 
@IncludeThirdParties = 1, 
@LoanStatuses = ''F'', 
@FHLBPledgeStatuses = ''1|2|3'',  
@RecordForDelta = 0 '


INSERT INTO #tblSecMaster(InvestorID,InvestorName,ManagerName,MortgageType,AsofDate,Ticker,LoanID,ClientID,Description,Currency,LoanType,LoanPurpose,FinancingSource,Borrower,Sponsor,Guaranteed,FundID,NoteName,LienPosition,Priority,SeniorDebt,OriginationDate,AccruedStartDate,FirstCouponDate,MaturityDate,FixedorFloating,AmortizationType,Interestonlyperiod,ModandRefiDate,LoanTerm,FullyExtendedMaturityDate,FullyExtendedTerm_mos,CurrentCouponEffectiveDate,LastPaymentDate,NextResetDate,DaysPastDue,PaymentFrequency,DayCount,PaymentDay,IndexName,IndexRate_Rounded,Spread,InterestRate,InitialFunding,OriginalAmountofLoan,AdjustedCommitment,AmountofLoanOutstanding,ValueofLandandBuildings,Servicer,PropertyType,NumberofProperties,CrossCollateralization,CrossCollateralizationIdentifier,City,State,PostalCode,Region,MSA,NonConstruction_HardCostUses,TotalCapStack_includesequity,NonConstruction,Construction,LastAppraisalDate,LastAppraisalSource,AsIsValue,InitialLTV,AsStabilizedValue,StabilizedLTV,AsIsCashFlow,AsStabCashFlow,AsIsDSCR,AsStabDSCR,InitialDebtYield,StabilizedDebtYield,PayRate,MortgageLoanTrancheType,IndexFloor,RSLIC,SNCC,PIIC,TMR,HCC,USSIC,TMDDL,HAIH,TotalParticipationPer,AccruedPIKBalanceAmount,RSLICValLBPct,SNCCValLBPct,PIICValLBPct,TMRValLBPct,HCCValLBPct,USSICValLBPct,TMNFValLBPct,HAIHValLBPct,TotalParticipationMod2,FHLBPledged,NOISecondPriorYear,NOIPriorYear,NOI,TTM,RollingAverageNOI,RollingAverageNOIGrid,LTV,RBCDSR,CMRATING,NOTCHED,RBCCharge,StabLTVNumerator,ASISLTVDENOMINATOR,UsingRollup,AsIsLTVNumerator,ASSTABLTVDENOMINATOR,asisdebtservice,asstabdebtservice,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @query



IF EXISTS(Select LoanID from #tblSecMaster)
BEGIN
	Truncate table [IO].[L_SECMastHolding] 

	INSERT INTO [IO].[L_SECMastHolding] (
	Ticker
	,LoanID
	,Description
	,FinancingSource
	,NoteName
	,Priority
	,OriginationDate
	,FullyExtendedMaturityDate
	,PaymentDay
	,InterestRate
	,InitialFunding
	,OriginalAmountofLoan
	,AdjustedCommitment
	,AmountofLoanOutstanding
	,IndexFloor
	,CreatedBy
	,CreatedDate
	,UpdateBy
	,UpdatedDate)
	SELECT 
	sec.Ticker
	,sec.LoanID as LoanID
	,sec.[Description]
	,sec.FinancingSource
	,sec.NoteName
	,sec.[Priority]
	,sec.OriginationDate
	,sec.FullyExtendedMaturityDate
	,sec.PaymentDay

	,NULLIF(sec.InterestRate,'N/A')
	,NULLIF(sec.InitialFunding,'N/A')
	,NULLIF(sec.OriginalAmountofLoan,'N/A')
	,NULLIF(sec.AdjustedCommitment,'N/A')
	,NULLIF(sec.AmountofLoanOutstanding,'N/A')
	,NULLIF(sec.IndexFloor,'N/A')

	,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
	,getdate()
	,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
	,getdate()
	from #tblSecMaster sec



END



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

