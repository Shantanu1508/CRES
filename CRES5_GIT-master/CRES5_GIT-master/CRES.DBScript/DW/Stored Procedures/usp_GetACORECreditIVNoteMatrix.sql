



CREATE PROCEDURE [DW].[usp_GetACORECreditIVNoteMatrix] 

AS
BEGIN
     SET NOCOUNT ON;

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
CurrentEntity,
[CapStack],
[BillingNote],
[Commitment],
[Spread],
IndexforStub,
[Floor],

AllInRate,

[Type],
[InitialFunding],
[InitialMaturity],
ExtendedMaturity1,
ExtendedMaturity2,
ExtendedMaturity3,
ExtendedMaturity4,
FullyExtendedMaturity,
CurrentMaturityDate,
CurrentMaturity,
[PaidOffSold],
------------------------------
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

OriginationFee,
ExitFee,
PaydownPayoffConvention,
PaymentDate,
WholeLoanSpread,
ExtensionFee1,
ExtensionFee2,
ExtensionFee3,
ExtensionFee4,

AcoreOrig,

ProductType,
MSA,
State,	
DealType,
[InquiryYear],
[Location],
--[UnderwrittenReturn]
WLInitialMaturity,
WLFullyExtended,
SubDebtFullyExtended

FROM [DW].[NoteMatrixBI]


END

