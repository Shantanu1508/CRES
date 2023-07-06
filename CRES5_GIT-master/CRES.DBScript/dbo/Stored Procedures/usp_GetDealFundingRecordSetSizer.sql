
CREATE PROCEDURE [dbo].[usp_GetDealFundingRecordSetSizer] 
 

AS
BEGIN

	select 
		creDealID,
		Date,
		Amount,
		PurposeID,
		Comment
		from CRE.DealFunding df
		inner join CRE.Deal d on d.DealID= df.DealID
	where 1<>1



END
