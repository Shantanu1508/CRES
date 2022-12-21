CREATE TYPE [dbo].[tblFeeCredits] AS TABLE (
FeeCreditsID	int,
FeeType	int,
FeeCreditOverride	decimal(28,15),
UseActualFees	bit
);