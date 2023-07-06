


CREATE PROCEDURE [DW].[usp_GetDelphiNoteMatrixBI] 

AS
BEGIN
     SET NOCOUNT ON;
   

   truncate table [DW].[NoteMatrixBI]

SELECT 
[DealID],
[DealGroupID],
[NoteID],
[Pri],
[DealName],
[NoteName],
[LoanStatus],
[Client],
[Fund],
[AssetManager],
[Banker],
[Credit],
[Pool],
[FinancingSource],
[DebtType],
[CapStack],
[BillingNote],
[Commitment],
[Spread],
[IndexforStub],
[Floor],
[AllInRate],
[Type],
[InitialFunding],
[InitialMaturity],
--[ExtendedMaturity],	
ExtendedMaturity1,
ExtendedMaturity2,
ExtendedMaturity3,
ExtendedMaturity4,
FullyExtendedMaturity,
CurrentMaturityDate,
CurrentMaturity,
[PaidOffSold],
[FeesStart],
[RSLIC],
[SNCC],
[PIIC],
[TMR],
[HCC],
[USSIC],
[TMNF],
[HAIH],
[Check],
[CAMRA],
[Servicer],
[ServicerID],
[PremDisc],
[OriginationFee],
FutureFundingsatParor99,
[PaydownPayoffConvention],
PaymentDate,
[Other],
NoteClassification,

ClearwaterMortgageLoanTrancheType,

WholeLoanSpread,
[SeniorLoanSpread],
[SubLoanSpread],
ExtensionFee1,
ExtensionFee2,
ExtensionFee3,
ExtensionFee4,
ProductType,
MSA,
State,	
DealType,
[InquiryYear],
[Location],

SubDebtInitiaMaturity,
WLInitialMaturity,
SubDebtFullyExtended,
WLFullyExtended
--[UnderwrittenReturn]

FROM [DW].[NoteMatrixBI]



END

