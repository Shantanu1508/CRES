CREATE PROCEDURE [dbo].[usp_GetPayoffStatementFeesDetailsByDealID] --'5DD8E0A2-A2A1-424B-8653-5E97AB046B50'
	@DealID UNIQUEIDENTIFIER 
AS
BEGIN

select 
p.PayoffStatementFeesID,
p.FeeName,
p.FeeType,
lFeeType.Name as FeeTypeText,
p.Value,
p.Comment,
p.DealID

from [CRE].[PayoffStatementFees] p
Left Join core.lookup lFeeType on lFeeType.lookupid = p.FeeType
where p.DealID = @DealID

END