------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetDealFundingRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	  select 
d.CREDealID,
df.Date,
df.Amount,
df.PurposeID,
df.Comment,
df.UpdatedBy
from  [CRE].DealFunding df
inner join CRE.Deal d on d.DealID = df.DealID
where 1<>1
END


