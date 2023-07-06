------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetPayruleSetupRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	 select 
d.CREDealID,
ps.StripTransferFrom,
ps.StripTransferTo,
ps.Value,
ps.RuleID,
ps.UpdatedBy
from  [CRE].[PayruleSetup] ps
inner join CRE.Deal d on d.DealID = ps.DealID
where 1<>1
END


