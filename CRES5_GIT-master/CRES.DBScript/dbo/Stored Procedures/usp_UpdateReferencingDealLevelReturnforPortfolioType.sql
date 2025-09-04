CREATE PROCEDURE [dbo].[usp_UpdateReferencingDealLevelReturnforPortfolioType]

@XIRRConfigIdDealCopy int,
@XIRRConfigIdPortfolio int

AS
BEGIN

SET NOCOUNT ON;		

Update CRE.XIRRConfig set 
 ReferencingDealLevelReturn = @XIRRConfigIdDealCopy
 where XIRRConfigID = @XIRRConfigIdPortfolio

END