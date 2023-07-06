


CREATE PROCEDURE [DW].[usp_GetTREACRNoteMatrixBI] 

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
[DebtType],
[CapStack],
[BillingNote],
[Commitment],
[Spread],
IndexforStub,
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

--[UnderwrittenReturn],

WLInitialMaturity,
WLFullyExtended

--[PremDisc],
--[OriginationFee],
--[Other]

  FROM [DW].[NoteMatrixBI]


END

