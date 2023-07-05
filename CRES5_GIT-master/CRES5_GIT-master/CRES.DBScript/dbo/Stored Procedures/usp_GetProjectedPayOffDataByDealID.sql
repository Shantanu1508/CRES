-- [dbo].[usp_GetProjectedPayOffDataByDealID]'637F5DC0-8B07-4CC8-A19D-591D4BB650AE','b0e6697b-3534-4c09-be0a-04473401ab93'
-- [dbo].[usp_GetProjectedPayOffDataByDealID] '40CBA8C8-BDE5-4990-B2E3-3EAE7AA4E0F5','b0e6697b-3534-4c09-be0a-04473401ab93' 
CREATE PROCEDURE [dbo].[usp_GetProjectedPayOffDataByDealID]
(
	@DealID UNIQUEIDENTIFIER,
	@UserID nvarchar(256)	
)
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT	d.EarliestPossibleRepaymentDate as EarliestDate,
			d.LatestPossibleRepaymentDate as LatestDate,
			d.ExpectedFullRepaymentDate as ExpectedDate,
			d.AutoPrepayEffectiveDate as AuditUpdateDate,
			dpa.AsOfDate as ProjectedPayoffAsofDate,
			ISNULL(dpa.CumulativeProbability,0) as CumulativeProbability,
			dpa.DealProjectedPayOffAccountingID
 
	from cre.DealProjectedPayOffAccounting dpa
	left join cre.deal d on d.DealID = dpa.DealID
	where dpa.DealID = @DealID
	and d.IsDeleted<>1
	and dpa.AsOfDate is not null
	order by dpa.AsOfDate asc

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
